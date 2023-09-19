import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thanks_diary/models/post.dart';

import 'firestore_constants.dart';

final partnerInitMessage = Post(
  text: 'ここは、思ったことを自由につぶやける部屋です。ふと思った何気ないことを言葉にしてみることで、なにか面白いことが起きるかもしれません。',
  roomId: 'tweet',
  createdAt: Timestamp.fromDate(DateTime.parse('2023-01-21 12:00:00')),
  posterName: '運営より',
  posterImageUrl: 'Boy',
  posterId: '',
  reference: FirebaseFirestore.instance.collection(Consts.rooms).doc('tweet'),
  stamps: '😌',
);
