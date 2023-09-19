import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Gage {
  Gage({required this.gage});
  final int gage;
}

class GageNotifier extends StateNotifier<Gage> {
  GageNotifier() : super(Gage(gage: 0));

  void IncrementGage() {
    if (state.gage == 3) {
      state = Gage(gage: 0);
    } else {
      state = Gage(gage: state.gage + 1);
    }
  }
}

final GageProvider = StateNotifierProvider<GageNotifier, Gage>((ref) {
  return GageNotifier();
});
