import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/room.dart';
import '../models/room_id_model.dart';
import 'firebase_provider.dart';
import 'talkroom_provider.dart';

final roomsProvider = StreamProvider((ref) {
  final roomsReference = ref.watch(roomsReferenceProvider);
  return roomsReference.orderBy('roomIndex').snapshots();
});

final roomsReferenceProvider = Provider<CollectionReference<Room>>((ref) {
  final talkroomReference = ref.watch(talkroomReferenceProvider).value;
  if (talkroomReference == null) {
    final firestore = ref.read(firestoreProvider);
    return firestore.collection('null').withConverter<Room>(
          fromFirestore: ((snapshot, _) => Room.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
  }

  return talkroomReference.collection('rooms').withConverter<Room>(
    fromFirestore: ((snapshot, _) {
      return Room.fromFirestore(snapshot);
    }),
    toFirestore: ((value, _) {
      return value.toJson();
    }),
  );
});

final currentRoomRefProvider = Provider((ref) {
  final roomId = ref.watch(roomIdProvider).id;
  final roomRef = ref.watch(roomsReferenceProvider).doc(roomId);
  return roomRef;
});

final currentRoomProvider = StreamProvider((ref) {
  final roomRef = ref.watch(currentRoomRefProvider);
  final currentRoom = roomRef.snapshots();
  return currentRoom;
});
