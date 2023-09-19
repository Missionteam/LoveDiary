import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/users_provider.dart';

class WhatNow {
  String whatNow;

  WhatNow({required this.whatNow});

  factory WhatNow.fromFirestore(Map<String, dynamic> map) {
    // data() の中には Map 型のデータが入っています。
    // data()! この ! 記号は nullable な型を non-nullable として扱うよ！ という意味です。
    // data の中身はかならず入っているだろうという仮説のもと ! をつけています。
    // map データが得られているのでここからはいつもと同じです。
    return WhatNow(
      whatNow: map['whatNow'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'whatNow': whatNow,
      // 'reference': reference, reference は field に含めなくてよい
      // field に含めなくても DocumentSnapshot に reference が存在するため
    };
  }
}

@immutable
class IsUserWhatNow {
  IsUserWhatNow({required this.isUser});
  final bool isUser;
}

class IsUserWhatNowNotifier extends StateNotifier<IsUserWhatNow> {
  IsUserWhatNowNotifier() : super(IsUserWhatNow(isUser: true));

  void IsUserTrue() {
    state = IsUserWhatNow(isUser: true);
  }

  void IsUserChange(WidgetRef ref) {
    state = IsUserWhatNow(isUser: !state.isUser);
    final now = DateTime.now();

    final usertimeStamp =
        ref.watch(userupdateAtProvider).value?.toDate() ?? DateTime.now();
    final userdifference = now.difference(usertimeStamp).inHours;
    final userRef = ref.watch(currentAppUserDocRefProvider);
    if (userdifference >= 3)
      userRef.update({'whatNowMessage': '', 'updateAt': now});

    final partnertimeStamp =
        ref.watch(partnerUpdateAtProvider).value?.toDate() ?? DateTime.now();
    final partnerdifference = now.difference(partnertimeStamp).inHours;
    final partnerRef = ref.watch(partnerUserDocRefProvider);
    if (partnerdifference >= 24)
      partnerRef.update({'whatNowMessage': '', 'updateAt': now});
  }

  void IsUserFalse() {
    state = IsUserWhatNow(isUser: false);
  }
}

final isUserWhatNowProvider =
    StateNotifierProvider<IsUserWhatNowNotifier, IsUserWhatNow>((ref) {
  return IsUserWhatNowNotifier();
});

@immutable
class showText {
  showText({required this.isShow});
  final bool isShow;
}

class showTextNotifier extends StateNotifier<showText> {
  showTextNotifier() : super(showText(isShow: false));
  void show() {
    state = showText(isShow: true);
  }

  void hide() {
    state = showText(isShow: false);
  }
}

final showTextProvider =
    StateNotifierProvider<showTextNotifier, showText>((ref) {
  return showTextNotifier();
});
