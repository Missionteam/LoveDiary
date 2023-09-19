import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/know.dart';
import 'firebase_provider.dart';
import 'talkroom_provider.dart';

///KnowReferenceProviderが提供する
///ReferenceにあるKnowを取得するプロバイダー
final knowProvider = StreamProvider((ref) {
  final KnowReference = ref.watch(knowReferenceProvider);
  return KnowReference.orderBy('createdAt', descending: true).snapshots();
});

final knowListProvider =
    StreamProvider.autoDispose.family<List<Know>, bool>((ref, isMine) {
  final KnowReference = ref.watch(knowReferenceProvider);

  return KnowReference.orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});
final groupedKnowByDateProvider =
    Provider.family<Map<DateTime, List<Know>>, List<Know>>((ref, KnowList) {
  return KnowList.fold<Map<DateTime, List<Know>>>({}, (map, Know) {
    final date = DateTime(Know.date.toDate().year, Know.date.toDate().month,
        Know.date.toDate().day);
    if (!map.containsKey(date)) {
      map[date] = [];
    }
    map[date]!.add(Know);
    return map;
  });
});

// final KnowPartnerProvider = StreamProvider.family((ref, String roomId) {
//   final KnowReference = ref.watch(KnowReferenceProvider);
//   final partner = ref.watch(partnerUserDocProvider).value;
//   final partnerUid = partner?.id ?? 'P18KIdVBUqdcqVGyJt6moTLoONf2';

//   return KnowReference
//       .where('roomId', isEqualTo: roomId)
//       .where('KnowerId', isEqualTo: partnerUid)
//       .orderBy('createdAt', descending: true)
//       .snapshots();
// });

///現在のtalkroom直下のKnowのReferenceを取得するプロバイダー
final knowReferenceProvider = Provider<CollectionReference<Know>>((ref) {
  final talkroomReference = ref.watch(talkroomReferenceProvider).value;

  ///talkroomReferenceが取得中のときは、空のコレクションを渡す。
  if (talkroomReference == null) {
    final firestore = ref.read(firestoreProvider);
    return firestore.collection('null').withConverter<Know>(
          fromFirestore: ((snapshot, _) => Know.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
  }

  return talkroomReference.collection("know").withConverter<Know>(
        fromFirestore: ((snapshot, _) => Know.fromFirestore(snapshot)),
        toFirestore: ((value, _) => value.toJson()),
      );
});
