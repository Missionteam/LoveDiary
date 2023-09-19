import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/function/text_functions.dart';
import 'package:thanks_diary/models/cloud_storage_model.dart';
import 'package:thanks_diary/widgets/fundomental/image.dart';
import 'package:thanks_diary/widgets/fundomental/userIconWidget.dart';
import 'package:thanks_diary/widgets/record/player/player.dart';

import '../../models/post.dart';
import '../../models/room.dart';
import '../../pages/tworoom/reply_page.dart';
import '../../providers/auth_provider.dart';

class PostWidget1 extends ConsumerWidget {
  const PostWidget1({
    Key? key,
    required this.post,
    this.isReplyPage = false,
  }) : super(key: key);

  final Post post;
  final bool isReplyPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget image =
        ref.watch(imageOfPostProvider(this.post.imageUrl)).value ?? SizedBox();
    Widget postImage = (image != SizedBox())
        ? SizedBox(
            height: 200,
            child: image,
          )
        : image;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
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
                  (post.text != '')
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 5),
                          child: TextWithUrl(
                            text: post.text,
                          ),
                        )
                      : SizedBox(
                          height: 5,
                        ),
                  ImageWidget(this.post.imageUrl),
                  SizedBox(
                    height: (post.stamps == '') ? 0 : 38,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        onPressed: (() =>
                            post.reference.update({'stamps': ''})),
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
      ),
    );
  }
}

class MenuPostDialog extends ConsumerWidget {
  const MenuPostDialog({
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
    return SizedBox(
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  updatePost('🤗');
                  Navigator.of(context).pop();
                },
                child: Text('🤗',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  updatePost('🙆‍♂️');
                },
                child: Text('🙆‍♂️',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  updatePost('🥺');
                },
                child: Text('🥺',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  updatePost('❤️');
                },
                child: Text('❤️',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  updatePost('🤔');
                },
                child: Text('🤔',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: (post.posterId == uid)
                ? PostDeleteButton(
                    onDelete: () {
                      post.reference.delete();
                      int count = 0;
                      Navigator.popUntil(context, (_) => count++ >= 2);
                    },
                  )
                : SizedBox(height: 40),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => ReplyPage(post: post))));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'スレッドで返信する',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
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
