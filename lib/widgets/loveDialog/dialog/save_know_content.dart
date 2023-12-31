import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/know.dart';

class SaveKnowContent extends ConsumerWidget {
  const SaveKnowContent({Key? key, required this.know}) : super(key: key);
  final Know know;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 30, width: 300),
        NotoText(
          text: "解決しました！",
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: AppColors.buttonGreen,
        ),
        SizedBox(
          height: 50,
        ),
        NotoText(
          text: "ちゃんと伝えてえらい！",
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              know.reference.update({"isSolved": false});
            },
            child: Text("キャンセル"))
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        //     borderRadius: BorderRadius.circular(14),
        //   ),
        //   child: Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: NotoText(
        //         text: "今日ちょっと話したいことあるから時間欲しい！",
        //         fontSize: 10,
        //       ),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: InkWell(
        //       onTap: () async {
        //         await launchUrl(Uri.parse(
        //             'https://line.me/R/share?text=今日ちょっと話したいことあるから時間欲しい！'));
        //       },
        //       child: Image.asset(
        //         "images/line.png",
        //         width: 160,
        //       )),
        // ),
      ],
    );
  }
}
