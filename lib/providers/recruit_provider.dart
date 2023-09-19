import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/providers/auth_provider.dart';

import '../models/recruit.dart';
import 'firebase_provider.dart';
import 'talkroom_provider.dart';
import 'users_provider.dart';

final recruitsProvider = StreamProvider.family((ref, String collectionName) {
  final recruitsReference =
      ref.watch(recruitsReferenceProvider(collectionName)).value;
  final uid = ref.watch(uidProvider);
  if (recruitsReference == null) {
    return FirebaseFirestore.instance
        .collection('nulls')
        .withConverter<Recruit>(
          fromFirestore: ((snapshot, _) => Recruit.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        )
        .snapshots();
  }
  ;
  return recruitsReference.where('showList', arrayContains: uid).snapshots();
});

final recruitsReferenceProvider =
    FutureProvider.family((ref, String collectionName) async {
  final uid = ref.watch(uidProvider);
  final talkroomReference = ref.watch(talkroomReferenceProvider).value;
  if (talkroomReference == null) {
    final firestore = ref.read(firestoreProvider);
    return firestore.collection('null').withConverter<Recruit>(
          fromFirestore: ((snapshot, _) => Recruit.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
  }
  final myRecruitDoc =
      await talkroomReference.collection(collectionName).doc(uid).get();
  if (myRecruitDoc.exists == false) {
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final posterName = userDoc?.get('displayName');
    final posterImageUrl = userDoc?.get('photoUrl');
    final recruitDocRef = talkroomReference.collection(collectionName).doc(uid);
    final recruit = Recruit(
        createdAt: Timestamp.now(),
        id: uid!,
        type: collectionName,
        posterImageUrl: posterImageUrl,
        reference: recruitDocRef);
    await recruitDocRef.set(recruit.toJson());
  }
  ;
  return talkroomReference.collection(collectionName).withConverter<Recruit>(
    fromFirestore: ((snapshot, _) {
      return Recruit.fromFirestore(snapshot);
    }),
    toFirestore: ((value, _) {
      return value.toJson();
    }),
  );
});

final myRecruitProvider = StreamProvider.family((ref, String collectionName) {
  final recruitsReference =
      ref.watch(recruitsReferenceProvider(collectionName)).value;
  final uid = ref.watch(uidProvider);

  if (recruitsReference == null)
    return FirebaseFirestore.instance
        .collection('nulls')
        .withConverter<Recruit>(
          fromFirestore: ((snapshot, _) => Recruit.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        )
        .doc(uid)
        .snapshots();
  ;
  return recruitsReference.doc(uid).snapshots();
});

final partnerRecruitProvider =
    StreamProvider.family((ref, String collectionName) {
  final recruitsReference =
      ref.watch(recruitsReferenceProvider(collectionName)).value;
  final partnerUid = ref.watch(partnerUserDocProvider).value?.id;
  if (recruitsReference == null)
    return FirebaseFirestore.instance
        .collection('nulls')
        .withConverter<Recruit>(
          fromFirestore: ((snapshot, _) => Recruit.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        )
        .doc(partnerUid)
        .snapshots();
  ;
  return recruitsReference.doc(partnerUid).snapshots();
});

final myRecruitRefProvider = Provider.family((ref, String collectionName) {
  final recruitsReference =
      ref.watch(recruitsReferenceProvider(collectionName)).value;
  final uid = ref.watch(uidProvider);
  return recruitsReference!.doc(uid);
});

final partnerRecruitRefProvider = Provider.family((ref, String collectionName) {
  final recruitsReference =
      ref.watch(recruitsReferenceProvider(collectionName)).value;
  final partnerUid = ref.watch(partnerUserDocProvider).value?.id;
  return recruitsReference!.doc(partnerUid);
});

Future<void> addRecruit(WidgetRef ref, String collectionName) async {
  final myRecruitDoc = ref.watch(myRecruitRefProvider(collectionName));
  final myDoc = ref.watch(CurrentAppUserDocProvider).value;
  final uid = ref.watch(uidProvider);
  final partnerUid = ref.watch(partnerUserDocProvider).value?.data()!.id;
  final bool? isShow = myDoc?.data()!.isShowRecruit;
  if (isShow == false) {
    myRecruitDoc.update({
      'showList': [uid],
      'isJoin': true
    });
  }
  ;
  if (isShow != false)
    myRecruitDoc.update({
      'showList': [
        uid,
        partnerUid,
      ],
      'isShow': true,
      'isJoin': true
    });
}

Future<void> updateRecruit(WidgetRef ref, String collectionName,
    Map<String, dynamic> updateData) async {
  final myDoc = ref.watch(myRecruitRefProvider(collectionName));
  myDoc.update(updateData);
}

Future<void> updatePartnerRecruit(WidgetRef ref, String collectionName,
    Map<String, dynamic> updateData) async {
  final partnerDoc = ref.watch(partnerRecruitRefProvider(collectionName));
  partnerDoc.update(updateData);
}

Future<void> removeRecruit(WidgetRef ref, String collectionName) async {
  final myDoc = ref.watch(myRecruitRefProvider(collectionName));
  myDoc.update({'showList': [], 'time': '', 'isJoin': false});
}

Future<void> removePartnerRecruit(WidgetRef ref, String collectionName) async {
  final partnerDoc = ref.watch(partnerRecruitRefProvider(collectionName));
  partnerDoc.update({'showList': [], 'time': '', 'isJoin': false});
}
