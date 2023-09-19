import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.text,
    required this.roomId,
    required this.createdAt,
    required this.posterName,
    required this.posterImageUrl,
    required this.posterId,
    required this.reference,
    required this.stamps,
    this.id = '',
    this.replyCount = 0,
    this.imageUrl = '',
    this.imageLocalPath = '',
    this.voiceRemotePath,
    this.isOfficial = false,
    this.isShowDate = true,
    this.isVoice = false,
  });
  final String text;
  final String roomId;
  final Timestamp createdAt;
  final String posterName;
  final String posterImageUrl;
  final String posterId;
  final String? stamps;
  final String imageUrl;
  final String imageLocalPath;
  final String? voiceRemotePath;
  final String id;
  final bool isOfficial;
  final bool isShowDate;
  final bool isVoice;
  final DocumentReference reference;
  final int replyCount;
  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Post(
      text: map['text'],
      roomId: map['roomId'],
      createdAt: map['createdAt'],
      posterName: map['posterName'],
      posterImageUrl: map['posterImageUrl'],
      posterId: map['posterId'],
      stamps: map['stamps'],
      replyCount: map['replyCount'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      imageLocalPath: map['imageLocalPath'] ?? '',
      id: map['id'] ?? '',
      isOfficial: map['isOfficial'] ?? false,
      isShowDate: map['isShowDate'] ?? true,
      isVoice: map['isVoice'] ?? false,
      voiceRemotePath: map['voiceRemotePath'],
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'roomId': roomId,
      'createdAt': createdAt,
      'posterName': posterName,
      'posterImageUrl': posterImageUrl,
      'posterId': posterId,
      'stamps': stamps,
      'replyCount': replyCount,
      'imageUrl': imageUrl,
      'imageLocalPath': imageLocalPath,
      'isOfficial': isOfficial,
      'isShowDate': isShowDate,
      'isVoice': isVoice,
      'voiceRemotePath': voiceRemotePath,
      'id': id
      // 'reference': reference, reference は field に含めなくてよい
      // field に含めなくても DocumentSnapshot に reference が存在するため
    };
  }
}
