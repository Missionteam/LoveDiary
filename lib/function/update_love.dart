import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/loveCategory_model.dart';
import 'package:thanks_diary/providers/love_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../models/cloud_storage_model.dart';
import '../models/love.dart';

Future<void> updateLove(
  WidgetRef ref,
  DocumentReference loveReference,
  LoveReason loveReason, {
  String? messege,
  String? imageLocalPath,
  File? imageFile,
  String? imageCloudPath,
}) async {
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final posterId = userDoc?.get('id');
  final posterName = userDoc?.get('displayName');
  final newDocumentReference = ref.watch(loveReferenceProvider).doc();
  final token = ref.watch(PartnerfcmTokenProvider).value ?? '';

  final id = newDocumentReference.id;
  if (imageFile != null && imageCloudPath != null) {
    uploadFile(imageFile, imageCloudPath);
  }
  final newPost = Love(
      message: messege,
      loveReason: loveReason,
      date: Timestamp.now(),
      posterName: posterName,
      posterId: posterId,
      // imageLocalPath: imageLocalPath ?? '',
      imageUrl: imageCloudPath ?? '',
      reference: newDocumentReference,
      id: id);

  loveReference.update(newPost.toJson());
  // FirebaseCloudMessagingService().sendPushNotification(
  //     token: token,
  //     title: 'パートナーがありがとうを伝えました。',
  //     body: '',
  //     type: 'home',
  //     room: '',
  //     postId: '');
}
