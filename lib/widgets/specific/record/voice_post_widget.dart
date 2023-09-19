import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/widgets/fundomental/userIconWidget.dart';

import '../../../models/post.dart';
import '../../../pages/tworoom/reply_page.dart';
import '../../fundomental/post_widget.dart';
import '../../record/player/player.dart';

class VoicePostWidget extends ConsumerWidget {
  const VoicePostWidget({
    Key? key,
    required this.post,
    this.isReplyPage = false,
  }) : super(key: key);

  final Post post;
  final bool isReplyPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(uidProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserIcon(
            radius: 36,
            uid: post.posterId,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.posterName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Color.fromARGB(255, 194, 102, 102)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          DateFormat('MM/dd HH:mm')
                              .format(post.createdAt.toDate()),
                          style: const TextStyle(
                              fontSize: 8,
                              color: Color.fromARGB(126, 48, 48, 48)),
                        ),
                      ],
                    )
                  ],
                ),
                (post.voiceRemotePath != null)
                    ? InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            useRootNavigator: true,
                            context: context,
                            builder: (BuildContext context) {
                              return MenuPostDialog(post: post);
                            },
                          );
                        },
                        child: AudioPlayer(
                            source: post.voiceRemotePath!,
                            isMine: (post.posterId == uid),
                            onDelete: () {
                              post.reference.delete();
                              Navigator.of(context, rootNavigator: true).pop();
                            }),
                      )
                    : SizedBox(),
                SizedBox(
                  height: (post.stamps == '') ? 0 : 38,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                      onPressed: (() => null),
                      child: Text(post.stamps ?? ''),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Color.fromARGB(69, 255, 251, 251),
                        // shadowColor: Color.fromARGB(255, 194, 194, 194),
                        elevation: 0,
                        padding: EdgeInsets.all(0),
                        // maximumSize: Size(0.1, 0.1)
                        // (post.stamps == null) ? Size(0, 0) : Size(40, 40),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (this.isReplyPage == false && post.replyCount != 0)
                      ? 25
                      : 0,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: UserIcon(
                            radius: 20,
                            uid: post.posterId,
                          )),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => ReplyPage(post: post));
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: ((context) => ReplyPage(post: post))));
                        },
                        child: Text(
                          '${post.replyCount}件の返信',
                          style: GoogleFonts.nunito(
                              color: Color.fromARGB(255, 243, 103, 33),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
