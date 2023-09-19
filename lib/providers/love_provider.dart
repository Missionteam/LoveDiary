import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/love.dart';
import 'firebase_provider.dart';
import 'talkroom_provider.dart';

///LoveReferenceProviderが提供する
///ReferenceにあるLoveを取得するプロバイダー
final loveProvider = StreamProvider((ref) {
  final LoveReference = ref.watch(loveReferenceProvider);
  return LoveReference.orderBy('createdAt', descending: true).snapshots();
});

final loveListProvider =
    StreamProvider.autoDispose.family<List<Love>, bool>((ref, isMine) {
  final LoveReference = ref.watch(loveReferenceProvider);

  return LoveReference.orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});
final groupedLoveByDateProvider =
    Provider.family<Map<DateTime, List<Love>>, List<Love>>((ref, LoveList) {
  return LoveList.fold<Map<DateTime, List<Love>>>({}, (map, Love) {
    final date = DateTime(Love.date.toDate().year, Love.date.toDate().month,
        Love.date.toDate().day);
    if (!map.containsKey(date)) {
      map[date] = [];
    }
    map[date]!.add(Love);
    return map;
  });
});

// final LovePartnerProvider = StreamProvider.family((ref, String roomId) {
//   final LoveReference = ref.watch(LoveReferenceProvider);
//   final partner = ref.watch(partnerUserDocProvider).value;
//   final partnerUid = partner?.id ?? 'P18KIdVBUqdcqVGyJt6moTLoONf2';

//   return LoveReference
//       .where('roomId', isEqualTo: roomId)
//       .where('LoveerId', isEqualTo: partnerUid)
//       .orderBy('createdAt', descending: true)
//       .snapshots();
// });

///現在のtalkroom直下のLoveのReferenceを取得するプロバイダー
final loveReferenceProvider = Provider<CollectionReference<Love>>((ref) {
  final talkroomReference = ref.watch(talkroomReferenceProvider).value;

  ///talkroomReferenceが取得中のときは、空のコレクションを渡す。
  if (talkroomReference == null) {
    final firestore = ref.read(firestoreProvider);
    return firestore.collection('null').withConverter<Love>(
          fromFirestore: ((snapshot, _) => Love.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
  }

  return talkroomReference.collection("love").withConverter<Love>(
        fromFirestore: ((snapshot, _) => Love.fromFirestore(snapshot)),
        toFirestore: ((value, _) => value.toJson()),
      );
});
