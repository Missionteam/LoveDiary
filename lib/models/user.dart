import 'package:cloud_firestore/cloud_firestore.dart';

import '../allConstants/all_constants.dart';

class AppUser {
  final String id;
  final String photoUrl;
  final String displayName;
  final Timestamp? updateAt;
  final String? partnerName;
  final String talkroomId;
  final String chtattingWith;
  final String whatNow;
  final String fcmToken;
  final bool isShowRecruit;
  final bool isShowRecruitButton;
  final bool isGirl;
  final bool isFirstUseRecruit;
  final bool isFirstUseVoice;
  final bool isFirstUseRecording;
  final bool isFirstUseVoiceRecording;
  final bool isGetAnnouncement0505;

  const AppUser(
      {required this.id,
      required this.photoUrl,
      required this.displayName,
      this.updateAt = null,
      this.partnerName = '',
      this.isShowRecruit = true,
      required this.talkroomId,
      required this.chtattingWith,
      required this.whatNow,
      this.isShowRecruitButton = false,
      this.isFirstUseRecruit = true,
      this.isFirstUseRecording = true,
      this.isFirstUseVoice = true,
      this.isFirstUseVoiceRecording = true,
      this.isGetAnnouncement0505 = false,
      required this.fcmToken,
      required this.isGirl});

  Map<String, dynamic> toJson() => {
        Consts.id: id,
        Consts.displayName: displayName,
        Consts.photoUrl: photoUrl,
        Consts.updateAt: updateAt,
        'partnerName': partnerName,
        Consts.talkroomId: talkroomId,
        'chattingWith': chtattingWith,
        Consts.whatNow: whatNow,
        'isShowRecruit': isShowRecruit,
        'fcmToken': fcmToken,
        'isGirl': isGirl,
        'isShowRecruitButton': isShowRecruitButton,
        'isFirstUseRecruit': isFirstUseRecruit,
        'isFirstUseRecording': isFirstUseRecording,
        'isFirstUseVoice': isFirstUseVoice,
        'isFirstUseVoiceRecording': isFirstUseVoiceRecording,
        'isGetAnnouncement0505': isGetAnnouncement0505,
      };
  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    return AppUser(
      id: snapshot.id,
      photoUrl: map[Consts.photoUrl] ?? 'Girl',
      displayName: map[Consts.displayName] ?? '',
      updateAt: map[Consts.updateAt],
      partnerName: map['partnerName'],
      talkroomId: map[Consts.talkroomId] ?? '',
      chtattingWith: map[Consts.chattingWith] ?? 'P18KIdVBUqdcqVGyJt6moTLoONf2',
      isShowRecruit: map['isShowRecruit'] ?? true,
      whatNow: map[Consts.whatNow] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      isGirl: map['isGirl'] ?? true,
      isFirstUseRecording: map['isFirstUseRecording'] ?? true,
      isFirstUseVoice: map['isFirstUseVoice'] ?? true,
      isShowRecruitButton: map['isShowRecruitButton'] ?? false,
      isFirstUseVoiceRecording: map['isFirstUseVoiceRecording'] ?? true,
      isFirstUseRecruit: map['isFirstUseRecruit'] ?? true,
      isGetAnnouncement0505: map['isGetAnnouncement0505'] ?? false,
    );
  }
}
