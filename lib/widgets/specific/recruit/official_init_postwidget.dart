import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/models/cloud_storage_model.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/post.dart';

class OfficialInitPostWidget extends ConsumerWidget {
  const OfficialInitPostWidget({
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

    Future<void> updatePost(String text) async {
      post.reference.update({'stamps': text});
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: (post.isShowDate)
              ? BorderRadius.circular(40)
              : BorderRadius.circular(0),
          color: (post.isShowDate)
              ? Color.fromARGB(255, 255, 255, 255)
              : Color.fromARGB(96, 255, 255, 255),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                child: NotoText(
                  text: post.text,
                ),
              ),
              image,
              (post.isShowDate)
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat('MM/dd HH:mm')
                            .format(post.createdAt.toDate()),
                        style: const TextStyle(
                            fontSize: 8,
                            color: Color.fromARGB(126, 48, 48, 48)),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
