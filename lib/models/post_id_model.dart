import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class PostId {
  PostId({required this.id});
  final String id;
}

class PostIdNotifier extends StateNotifier<PostId> {
  PostIdNotifier() : super(PostId(id: ''));

  void setPostId(id) {
    state = PostId(id: id);
  }
}

final PostIdProvider = StateNotifierProvider<PostIdNotifier, PostId>((ref) {
  return PostIdNotifier();
});
