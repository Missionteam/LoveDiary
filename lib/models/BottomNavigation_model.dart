import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class NavigationIndex {
  NavigationIndex({required this.index});
  final int index;
}

class NavigationIndexNotifier extends StateNotifier<NavigationIndex> {
  NavigationIndexNotifier() : super(NavigationIndex(index: 0));

  void setNavigationIndex(index) {
    state = NavigationIndex(index: index);
  }
}

final NavigationIndexProvider =
    StateNotifierProvider<NavigationIndexNotifier, NavigationIndex>((ref) {
  return NavigationIndexNotifier();
});
