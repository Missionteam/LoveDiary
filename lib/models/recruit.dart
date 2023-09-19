import 'package:cloud_firestore/cloud_firestore.dart';

class Recruit {
  Recruit({
    this.time = '',
    this.memo = '',
    required this.createdAt,
    required this.type,
    required this.posterImageUrl,
    this.recruitText = '',
    required this.reference,
    this.isNotify = false,
    this.stamps = '',
    this.id = '',
    this.replyCount = 0,
    this.isJoin = false,
    this.dulation = 3,
    this.showList = const [],
    this.isFirst = true,
  });
  final String time;
  final String memo;
  final Timestamp createdAt;
  final String type;
  final String posterImageUrl;
  final String recruitText;
  final String? stamps;
  final int dulation;
  final List showList;
  final String id;
  final bool isJoin;
  final bool isNotify;
  final bool isFirst;

  final DocumentReference reference;
  final int replyCount;
  factory Recruit.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!; // data() の中には Map 型のデータが入っています。
    // data()! この ! 記号は nullable な型を non-nullable として扱うよ！ という意味です。
    // data の中身はかならず入っているだろうという仮説のもと ! をつけています。
    // map データが得られているのでここからはいつもと同じです。
    return Recruit(
      time: map['time'] ?? '',
      memo: map['memo'] ?? '',
      isJoin: map['isJoin'],
      createdAt: map['createdAt'],
      type: map['type'],
      posterImageUrl: map['posterImageUrl'],
      recruitText: map['recruitText'],
      stamps: map['stamps'],
      replyCount: map['replyCount'] ?? 0,
      dulation: map['dulation'] ?? '',
      showList: map['showList'] ?? [],
      isNotify: map['isNotify'] ?? false,
      isFirst: map['isFirst'] ?? true,
      id: map['id'] ?? '',
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'memo': memo,
      'createdAt': createdAt,
      'isJoin': isJoin,
      'type': type,
      'posterImageUrl': posterImageUrl,
      'recruitText': recruitText,
      'stamps': stamps,
      'replyCount': replyCount,
      'dulation': dulation,
      'showList': showList,
      'isNotify': isNotify,
      'isFirst': isFirst,
      'id': id
      // 'reference': reference, reference は field に含めなくてよい
      // field に含めなくても DocumentSnapshot に reference が存在するため
    };
  }
}
