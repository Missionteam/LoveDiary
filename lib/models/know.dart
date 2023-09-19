import 'package:cloud_firestore/cloud_firestore.dart';

class Know {
  Know({
    required this.date,
    this.message,
    required this.why,
    required this.posterId,
    required this.posterName,
    required this.situation,
    required this.feeling,
    required this.view,
    required this.want,
    required this.talk,
    this.stamps,
    this.imageUrl,
    this.imageLocalPath,
    required this.reference,
    this.id = '',
  });

  final Timestamp date;
  final String? message;
  final String situation;
  final String feeling;
  final String why;
  final String view;
  final String want;
  final String talk;
  final String? imageUrl;
  final String? stamps;
  final String? imageLocalPath;
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
      why: map["why"],
      situation: map["situation"],
      feeling: map["feeling"],
      view: map["view"],
      want: map["want"],
      talk: map["talk"],
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
      'why': why,
      'situation': situation,
      'feeling': feeling,
      'view': view,
      'want': want,
      'talk': talk,
      'stamps': stamps,
      'imageUrl': imageUrl,
      'imageLocalPath': imageLocalPath,
      'posterId': posterId,
      'posterName': posterName,
      'id': id,
    };
  }
}
