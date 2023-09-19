import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/function/text_functions.dart';
import 'package:thanks_diary/models/cloud_storage_model.dart';
import 'package:thanks_diary/widgets/fundomental/image.dart';
import 'package:thanks_diary/widgets/fundomental/post_widget.dart';
import 'package:thanks_diary/widgets/record/player/player.dart';

import '../../../models/post.dart';
import '../../../models/room.dart';
import '../../../pages/tworoom/reply_page.dart';
import '../../../providers/auth_provider.dart';
import '../../fundomental/userIconWidget.dart';

class PostWidget2 extends ConsumerWidget {
  const PostWidget2({
    Key? key,
    required this.post,
    this.isReplyPage = false,
  }) : super(key: key);

  final Post post;
  final bool isReplyPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget image =
        ref.watch(imageOfPostProvider(post.imageUrl)).value ?? SizedBox();
    final uid = ref.watch(uidProvider);
    Future<void> updatePost(String text) async {
      post.reference.update({'stamps': text});
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserIcon(
                radius: 40,
                uid: post.posterId,
              ),
              const SizedBox(width: 8),
              Expanded(
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
                                height: 8,
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5,
                            bottom: (post.text == '')
                                ? 8
                                : (post.stamps != '')
                                    ? 5
                                    : (post.replyCount != 0)
                                        ? 5
                                        : 25,
                            right: 5),
                        child: (post.text != '')
                            ? TextWithUrl(
                                text: post.text,
                                // style: const TextStyle(
                                //   fontSize: 14.6,
                                //   color: Color.fromARGB(225, 59, 59, 59),
                                //   height: 1.5,
                                // ),
                              )
                            : SizedBox(),
                      ),
                      ImageWidget(this.post.imageUrl),
                      (post.isVoice)
                          ? AudioPlayer(
                              source: post.voiceRemotePath!,
                              isMine: (post.posterId == uid),
                              isTweet: true,
                              onDelete: () {
                                post.reference.delete();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              })
                          : SizedBox(),
                      SizedBox(
                          height: (post.imageUrl != '' && post.stamps == '')
                              ? 40
                              : (post.imageUrl != '')
                                  ? 8
                                  : (post.isVoice)
                                      ? 18
                                      : 0),
                      SizedBox(
                        height: (post.stamps == '') ? 0 : 38,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: (post.replyCount != 0) ? 0 : 8),
                          child: ElevatedButton(
                            onPressed: (() =>
                                post.reference.update({'stamps': ''})),
                            child: Text(post.stamps ?? ''),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  Color.fromARGB(69, 255, 255, 255),
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
                        height:
                            (this.isReplyPage == false && post.replyCount != 0)
                                ? 34
                                : 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 4),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: UserIcon(
                                  radius: 20,
                                  uid: post.posterId,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        room.roomname,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
  // if (FirebaseAuth.instance.currentUser!.uid == post.posterId)
  //   IconButton(
  //       onPressed: () {
  //         post.reference.delete();
  //       },
  //       icon: const Icon(Icons.delete)),

}
