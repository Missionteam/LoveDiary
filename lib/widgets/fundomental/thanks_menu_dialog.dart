import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/love.dart';

import '../../providers/auth_provider.dart';
import '../record/player/player.dart';
import '../util/text.dart';

class MenuThanksDialog extends ConsumerWidget {
  const MenuThanksDialog({
    Key? key,
    required this.love,
  }) : super(key: key);

  final Love love;
  Future<void> updatePost(String text) async {
    love.reference.update({'stamps': text});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(uidProvider);
    return SizedBox(
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: (love.posterId == uid)
                ? PostDeleteButton(
                    onDelete: () {
                      love.reference.delete();
                      int count = 0;
                      Navigator.popUntil(context, (_) => count++ >= 2);
                    },
                  )
                : SizedBox(height: 35),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              love.reference.update({'stamps': '❤️'});
            },
            child: Image.asset("images/home/love.png", width: 50),
          ),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: NotoText(
              text: "ダブルタップでもいいねできます    ",
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}
