import 'package:flutter/material.dart';

class LoveReason {
  final String reason;
  final Color color;

  LoveReason._({required this.reason, required this.color});

  static final LoveReason kindness =
      LoveReason._(reason: "優しさ", color: Color(0xffEF90AC));
  static final LoveReason entertaining =
      LoveReason._(reason: "面白い", color: Color(0xffF4E66F));
  static final LoveReason calm =
      LoveReason._(reason: "落ち着く", color: Color(0xff86DAE6));
  static final LoveReason work =
      LoveReason._(reason: "仕事できる", color: Color(0xff6F54BA));
  static final LoveReason cool =
      LoveReason._(reason: "かっこいい", color: Color(0xff0B6AF9));
  static final LoveReason cute =
      LoveReason._(reason: "かわいい", color: Color(0xffE73461));
  static final LoveReason hear =
      LoveReason._(reason: "聞き上手", color: Color(0xffF6AF46));
  static final LoveReason other =
      LoveReason._(reason: "その他", color: Color(0xff231F20));

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'color': color.value,
    };
  }

  static LoveReason fromJson(Map<String, dynamic> json) {
    return LoveReason._(
      reason: json['reason'] as String,
      color: Color(json['color'] as int),
    );
  }
}
