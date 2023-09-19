import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class RoomId {
  RoomId({required this.id});
  final String id;
}

class RoomIdNotifier extends StateNotifier<RoomId> {
  RoomIdNotifier() : super(RoomId(id: 'init'));

  void setRoomId(id) {
    state = RoomId(id: id);
  }
}

final roomIdProvider = StateNotifierProvider<RoomIdNotifier, RoomId>((ref) {
  return RoomIdNotifier();
});
