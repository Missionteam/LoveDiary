import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../models/cloud_storage_model.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';

void updateUserData(WidgetRef ref, {required String field, required value}) {
  final docRef = ref.watch(currentAppUserDocRefProvider);
  docRef.update({field: value});
}

void updatePartnerData(WidgetRef ref, {required String field, required value}) {
  final docRef = ref.watch(partnerUserDocRefProvider);
  docRef.update({field: value});
}

Future<void> sendPost(
  WidgetRef ref,
  String text, {
  String? imageLocalPath,
  File? imageFile,
  String? imageCloudPath,
  bool? isVoice,
  File? voiceFile,
  bool? isvoieCollection,
  String? voiceCloudPath,
  required String roomId,
}) async {
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final posterId = userDoc?.get('id');
  final posterName = userDoc?.get('displayName');
  final posterImageUrl = userDoc?.get('photoUrl');

  final newDocumentReference = (isvoieCollection != true)
      ? ref.watch(postsReferenceProvider).doc()
      : ref.watch(voiceReferenceProvider).doc();
  final id = newDocumentReference.id;
  if (imageFile != null && imageCloudPath != null) {
    uploadFile(imageFile, imageCloudPath);
  }
  final newPost = Post(
      text: text,
      roomId: roomId,
      createdAt: Timestamp.now(),
      posterName: posterName,
      posterImageUrl: posterImageUrl,
      posterId: posterId,
      stamps: '',
      imageLocalPath: imageLocalPath ?? '',
      imageUrl: (imageFile != null) ? imageCloudPath ?? '' : '',
      voiceRemotePath: voiceCloudPath,
      isVoice: isVoice ?? false,
      reference: newDocumentReference,
      id: id);

  if (text != '' || imageFile != null || voiceFile != null) {
    newDocumentReference.set(newPost);
  }
}
