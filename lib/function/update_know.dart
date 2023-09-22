import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/know.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../models/cloud_storage_model.dart';

Future<void> updateKnow(
  WidgetRef ref,
  DocumentReference knowReference, {
  String? text,
  String? what,
  String? feelings,
  String? why,
  String? imageLocalPath,
  bool? isSoleved,
  File? imageFile,
  String? imageCloudPath,
}) async {
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final posterId = userDoc?.get('id');
  final posterName = userDoc?.get('displayName');

  if (imageFile != null && imageCloudPath != null) {
    uploadFile(imageFile, imageCloudPath);
  }
  final newPost = Know(
      message: text,
      why: why ?? "",
      what: what ?? "",
      feeling: feelings ?? "",
      date: Timestamp.now(),
      posterName: posterName,
      posterId: posterId,
      isSolved: isSoleved,
      imageUrl: (imageFile != null) ? imageCloudPath ?? '' : '',
      reference: knowReference,
      id: knowReference.id);

  knowReference.update(newPost.toJson());
  // FirebaseCloudMessagingService().sendPushNotification(
  //     token: token,
  //     title: 'パートナーがありがとうを伝えました。',
  //     body: '',
  //     type: 'home',
  //     room: '',
  //     postId: '');
}
