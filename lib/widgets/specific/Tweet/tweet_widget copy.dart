import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/post.dart';
import '../../../pages/tworoom/reply_page.dart';

class TweetWidget2 extends ConsumerStatefulWidget {
  const TweetWidget2({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TweetWidget2State();
}

class _TweetWidget2State extends ConsumerState<TweetWidget2> {
  Future<void> updatePost(String text) async {
    widget.post.reference.update({'stamps': text});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Padding(
        padding: const EdgeInsets.only(right: 30, top: 40),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300),
          child: InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                useRootNavigator: true,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 330,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => updatePost('🤗'),
                                    child: Text('🤗',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () => updatePost('🙆‍♂️'),
                                    child: Text('🙆‍♂️',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () => updatePost('🥺'),
                                    child: Text('🥺',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () => updatePost('❤️'),
                                    child: Text('❤️',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () => updatePost('🤔'),
                                    child: Text('🤔',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'メッセージを編集する',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '未読にする',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '後でリマインドする',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'ブックマークに登録する',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) =>
                                          ReplyPage(post: widget.post))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'スレッドで返信する',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 300),
              child: Container(
                  constraints: BoxConstraints(minWidth: 300),
                  alignment: Alignment.center,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 35, left: 20, bottom: 35, right: 20),
                    child: Text(
                      widget.post.text,
                      style: TextStyle(height: 1.5),
                    ),
                  )),
            ),
          ),
        ),
      ),
      Positioned(
        right: 100,
        bottom: 15,
        child: Text(widget.post.stamps ?? ''),
      ),
    ]);
  }
}
