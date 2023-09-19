import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/know.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../models/cloud_storage_model.dart';
import '../providers/know_provider.dart';

Future<void> sendKnow(
  WidgetRef ref, {
  String? text,
  String? situation,
  String? feelings,
  String? why,
  String? view,
  String? want,
  String? talk,
  String? imageLocalPath,
  File? imageFile,
  String? imageCloudPath,
}) async {
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final posterId = userDoc?.get('id');
  final posterName = userDoc?.get('displayName');
  final newDocumentReference = ref.watch(knowReferenceProvider).doc();
  final token = ref.watch(PartnerfcmTokenProvider).value ?? '';

  final id = newDocumentReference.id;
  if (imageFile != null && imageCloudPath != null) {
    uploadFile(imageFile, imageCloudPath);
  }
  final newPost = Know(
      message: text,
      why: why ?? "",
      situation: situation ?? "",
      feeling: feelings ?? "",
      view: view ?? "",
      want: want ?? "",
      talk: talk ?? "",
      date: Timestamp.now(),
      posterName: posterName,
      posterId: posterId,
      imageLocalPath: imageLocalPath ?? '',
      imageUrl: (imageFile != null) ? imageCloudPath ?? '' : '',
      reference: newDocumentReference,
      id: id);

  newDocumentReference.set(newPost);
  // FirebaseCloudMessagingService().sendPushNotification(
  //     token: token,
  //     title: 'パートナーがありがとうを伝えました。',
  //     body: '',
  //     type: 'home',
  //     room: '',
  //     postId: '');
}
