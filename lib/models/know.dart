import 'package:cloud_firestore/cloud_firestore.dart';

class Know {
  Know({
    required this.date,
    this.message,
    required this.why,
    required this.posterId,
    required this.posterName,
    required this.what,
    required this.feeling,
    this.baseReason,
    this.imageUrl,
    this.isSolved,
    required this.reference,
    this.id = '',
  });

  final Timestamp date;
  final String? message;
  final String what;
  final String? feeling;
  final String why;

  final String? imageUrl;
  final String? baseReason;
  final bool? isSolved;
  final String posterId;
  final String posterName;
  final String id;
  final DocumentReference reference;

  ///month

  factory Know.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return Know(
      date: map['date'],
      message: map['message'],
      why: map["why"] ?? "",
      what: map["what"] ?? "",
      feeling: map["feeling"],
      imageUrl: map['imageUrl'] ?? '',
      isSolved: map['isSolved'],
      posterId: map['posterId'],
      baseReason: map['baseReason'] ?? '',
      posterName: map['posterName'],
      id: map['id'] ?? '',
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'message': message,
      'why': why,
      'what': what,
      'feeling': feeling,
      'baseReason': baseReason,
      'imageUrl': imageUrl,
      'isSolved': isSolved,
      'posterId': posterId,
      'posterName': posterName,
      'id': id,
    };
  }
}
