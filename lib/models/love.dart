import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thanks_diary/models/loveCategory_model.dart';

class Love {
  Love({
    required this.date,
    this.message,
    required this.loveReason,
    required this.posterId,
    required this.posterName,
    this.stamps,
    this.imageUrl,
    this.imageLocalPath,
    required this.reference,
    this.id = '',
  });

  final Timestamp date;
  final String? message;
  final LoveReason loveReason;
  final String? imageUrl;
  final String? stamps;
  final String? imageLocalPath;
  final String posterId;
  final String posterName;
  final String id;
  final DocumentReference reference;

  ///month

  factory Love.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Love(
      date: map['date'],
      message: map['message'],
      loveReason:
          LoveReason.fromJson(map['loveReason'] as Map<String, dynamic>),
      imageUrl: map['imageUrl'] ?? '',
      imageLocalPath: map['imageLocalPath'] ?? '',
      posterId: map['posterId'],
      stamps: map['stamps'] ?? '',
      posterName: map['posterName'],
      id: map['id'] ?? '',
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'message': message,
      'loveReason': loveReason.toJson(),
      'stamps': stamps,
      'imageUrl': imageUrl,
      'imageLocalPath': imageLocalPath,
      'posterId': posterId,
      'posterName': posterName,
      'id': id,
    };
  }
}
