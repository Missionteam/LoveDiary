import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/text_functions.dart';
import 'package:thanks_diary/widgets/record/player/player.dart';

import '../../../models/cloud_storage_model.dart';
import '../../../models/post.dart';
import '../../../pages/tworoom/reply_page.dart';
import '../../../providers/auth_provider.dart';
import '../../fundomental/image.dart';
import '../../fundomental/post_widget.dart';

class TweetWidget extends ConsumerWidget {
  const TweetWidget({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  Future<void> updatePost(String text) async {
    post.reference.update({'stamps': text});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(uidProvider);
    Widget image =
        ref.watch(imageOfPostProvider(post.imageUrl)).value ?? SizedBox();
    return Stack(alignment: Alignment.bottomRight, children: [
      Padding(
        padding: const EdgeInsets.only(
          right: 30,
          top: 14,
          bottom: 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200),
          child: InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                useRootNavigator: true,
                context: context,
                builder: (BuildContext context) {
                  return MenuPostDialog(post: post);
                },
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: (post.isVoice)
                              ? 8
                              : (post.imageUrl != '' && post.text != '')
                                  ? 20
                                  : (post.imageUrl != '')
                                      ? 0
                                      : (post.replyCount != 0)
                                          ? 30
                                          : 25,
                          left: 20,
                          bottom: (post.isVoice)
                              ? 8
                              : (post.imageUrl != '' && post.text != '')
                                  ? 12
                                  : (post.imageUrl != '')
                                      ? 0
                                      : (post.replyCount != 0)
                                          ? 5
                                          : 10,
                          right: 20),
                      child: (post.isVoice != true)
                          ? TextWithUrl(
                              text: post.text,
                            )
                          : AudioPlayer(
                              source: post.voiceRemotePath!,
                              isTweet: true,
                              isMine: (post.posterId == uid),
                              onDelete: () {
                                post.reference.delete();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 15, right: 15),
                      child: ImageWidget(this.post.imageUrl),
                    ),
                    SizedBox(height: (post.stamps != '') ? 12 : 0),
                    SizedBox(
                      height: (post.replyCount != 0) ? 30 : 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                // backgroundImage: NetworkImage(
                                //   post.posterImageUrl,
                                // ),
                                maxRadius: 10,
                                backgroundImage: AssetImage(
                                    'images/${post.posterImageUrl}Icon.png'),
                              ),
                            ),
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
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
      Positioned(
        right: 55,
        bottom: 30,
        child: Text(post.stamps ?? ''),
      ),
    ]);
  }
}
