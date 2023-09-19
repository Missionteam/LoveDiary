import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class showRecordDialog {
  showRecordDialog({required this.isShow});
  final bool isShow;
}

class showRecordDialogNotifier extends StateNotifier<showRecordDialog> {
  showRecordDialogNotifier() : super(showRecordDialog(isShow: false));
  void show() {
    state = showRecordDialog(isShow: true);
  }

  void hide() {
    state = showRecordDialog(isShow: false);
  }
}

final showRecordDialogProvider =
    StateNotifierProvider<showRecordDialogNotifier, showRecordDialog>((ref) {
  return showRecordDialogNotifier();
});
