import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  Room({
    required this.roomname,
    required this.roomId,
    required this.reference,
    this.roomIndex = 0,
    this.boxColor = 'not use',
    this.image = 'YellowBoxImage.png',
    this.description = '',
  });

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!; // data() の中には Map 型のデータが入っています。
    return Room(
      roomId: map['roomId'],
      roomname: map['roomname'] ?? '',
      roomIndex: map['roomIndex'] ?? 0,
      boxColor: map['boxColor'] ?? '',
      image: map['image'] ?? 'YellowBoxImage.png',
      description: map['description'] ?? '',
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'roomname': roomname,
      'roomId': roomId,
      'roomIndex': roomIndex,
      'color': boxColor,
      'image': image,
      'description': description,
      // 'reference': reference, reference は field に含めなくてよい
      // field に含めなくても DocumentSnapshot に reference が存在するため
    };
  }

  final String roomname;

  final String roomId;

  final DocumentReference reference;

  final int roomIndex;
  final String boxColor;
  final String image;
  final String description;
}
