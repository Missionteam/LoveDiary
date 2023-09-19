import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../models/thanks.dart';
import 'firebase_provider.dart';
import 'talkroom_provider.dart';

///ThanksReferenceProviderが提供する
///ReferenceにあるThanksを取得するプロバイダー
final thanksProvider = StreamProvider((ref) {
  final thanksReference = ref.watch(thanksReferenceProvider);
  return thanksReference.orderBy('createdAt', descending: true).snapshots();
});

final thanksListProvider =
    StreamProvider.autoDispose.family<List<Thanks>, bool>((ref, isMine) {
  final thanksReference = ref.watch(thanksReferenceProvider);
  final uid = ref.watch(uidProvider);
  final partnerUid =
      ref.watch(CurrentAppUserDocProvider).value?.get("chattingWith") ??
          'P18KIdVBUqdcqVGyJt6moTLoONf2';
  return thanksReference
      .orderBy('date')
      .where("posterId", isEqualTo: isMine ? uid : partnerUid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});
final groupedThanksByDateProvider =
    Provider.family<Map<DateTime, List<Thanks>>, List<Thanks>>(
        (ref, thanksList) {
  return thanksList.fold<Map<DateTime, List<Thanks>>>({}, (map, thanks) {
    final date = DateTime(thanks.date.toDate().year, thanks.date.toDate().month,
        thanks.date.toDate().day);
    if (!map.containsKey(date)) {
      map[date] = [];
    }
    map[date]!.add(thanks);
    return map;
  });
});

final thanksPartnerProvider = StreamProvider.family((ref, String roomId) {
  final thanksReference = ref.watch(thanksReferenceProvider);
  final partner = ref.watch(partnerUserDocProvider).value;
  final partnerUid = partner?.id ?? 'P18KIdVBUqdcqVGyJt6moTLoONf2';

  return thanksReference
      .where('roomId', isEqualTo: roomId)
      .where('ThankserId', isEqualTo: partnerUid)
      .orderBy('createdAt', descending: true)
      .snapshots();
});

///現在のtalkroom直下のThanksのReferenceを取得するプロバイダー
final thanksReferenceProvider = Provider<CollectionReference<Thanks>>((ref) {
  final talkroomReference = ref.watch(talkroomReferenceProvider).value;

  ///talkroomReferenceが取得中のときは、空のコレクションを渡す。
  if (talkroomReference == null) {
    final firestore = ref.read(firestoreProvider);
    return firestore.collection('null').withConverter<Thanks>(
          fromFirestore: ((snapshot, _) => Thanks.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
  }

  return talkroomReference.collection("thanks").withConverter<Thanks>(
        fromFirestore: ((snapshot, _) => Thanks.fromFirestore(snapshot)),
        toFirestore: ((value, _) => value.toJson()),
      );
});
