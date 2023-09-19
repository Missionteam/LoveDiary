import 'package:cloud_firestore/cloud_firestore.dart';

class Thanks {
  Thanks({
    required this.date,
    this.message,
    required this.category,
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
  final String category;
  final String? imageUrl;
  final String? stamps;
  final String? imageLocalPath;
  final String posterId;
  final String posterName;
  final String id;
  final DocumentReference reference;

  ///month

  factory Thanks.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Thanks(
      date: map['date'],
      message: map['message'],
      category: map['category'],
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
      'category': category,
      'stamps': stamps,
      'imageUrl': imageUrl,
      'imageLocalPath': imageLocalPath,
      'posterId': posterId,
      'posterName': posterName,
      'id': id,
    };
  }
}
