import 'package:flutter/material.dart';

class ModalMenuWidget extends StatelessWidget {
  const ModalMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('👀'),
            Text('👍'),
            Text('🙏'),
            Text('✨'),
            Text('🙇'),
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
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'スレッドで返信する',
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
              '返信の通知をオフにする',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
  // if (FirebaseAuth.instance.currentUser!.uid == post.posterId)
  //   IconButton(
  //       onPressed: () {
  //         post.reference.delete();
  //       },
  //       icon: const Icon(Icons.delete)),

}
