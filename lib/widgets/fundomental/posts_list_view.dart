import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/widgets/fundomental/userIconWidget.dart';
import 'package:thanks_diary/widgets/specific/record/voice_post_widget.dart';

import '../../providers/posts_provider.dart';
import '../record/player/player.dart';
import '../specific/recruit/official_init_postwidget.dart';
import 'post_widget.dart';

class PostsListView extends StatelessWidget {
  const PostsListView({
    Key? key,
    required this.ref,
    required this.roomId,
  }) : super(key: key);

  final WidgetRef ref;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: ref.watch(postsProvider(roomId)).when(
        data: (data) {
          /// 値が取得できた場合に呼ばれる。
          return ListView.builder(
            shrinkWrap: true,
            reverse: true,
            padding: EdgeInsets.only(top: 10, left: 10),
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final post = data.docs[index].data();
              return (post.isOfficial)
                  ? OfficialInitPostWidget(post: post)
                  : (post.isVoice)
                      ? VoicePostWidget(post: post)
                      : PostWidget1(post: post);
            },
          );
        },
        error: (_, __) {
          /// 読み込み中にErrorが発生した場合に呼ばれる。
          return const Center(
            child: Text('不具合が発生しました。'),
          );
        },
        loading: () {
          /// 読み込み中の場合に呼ばれる。
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class VoiceListView extends StatelessWidget {
  const VoiceListView({
    Key? key,
    required this.ref,
  }) : super(key: key);

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider);
    return ref.watch(voicesProvider).when(
      data: (data) {
        /// 値が取得できた場合に呼ばれる。
        return ListView.builder(
          shrinkWrap: true,
          itemCount: (data.docs.length <= 2) ? data.docs.length : 2,
          itemBuilder: (context, index) {
            final post = data.docs[index].data();
            final isMine = post.posterId == uid;
            return (post.voiceRemotePath != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UserIcon(
                          uid: post.posterId,
                          radius: 12,
                        ),
                        SizedBox(
                          width: 80,
                          height: 60,
                          child: IconAudioPlayer(
                              source: post.voiceRemotePath!,
                              onDelete: () {
                                post.reference.delete();
                              },
                              isMine: isMine),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          },
        );
      },
      error: (_, __) {
        /// 読み込み中にErrorが発生した場合に呼ばれる。
        return const Center(
          child: Text('不具合が発生しました。'),
        );
      },
      loading: () {
        /// 読み込み中の場合に呼ばれる。
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class VoicePageListView extends StatelessWidget {
  const VoicePageListView({
    Key? key,
    required this.ref,
  }) : super(key: key);

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider);
    return ref.watch(voicesProvider).when(
      data: (data) {
        /// 値が取得できた場合に呼ばれる。
        return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: (data.docs.length <= 3) ? data.docs.length : 3,
          itemBuilder: (context, index) {
            final post = data.docs[index].data();
            final isMine = post.posterId == uid;
            return (post.voiceRemotePath != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UserIcon(
                          uid: post.posterId,
                          radius: 12,
                        ),
                        Expanded(
                          child: AudioPlayer(
                              source: post.voiceRemotePath!,
                              onDelete: () {
                                post.reference.delete();
                              },
                              isMine: isMine),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          },
        );
      },
      error: (_, __) {
        /// 読み込み中にErrorが発生した場合に呼ばれる。
        return const Center(
          child: Text('不具合が発生しました。'),
        );
      },
      loading: () {
        /// 読み込み中の場合に呼ばれる。
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
