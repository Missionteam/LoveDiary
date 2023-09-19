import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/widgets/util/text.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveKnowContent extends ConsumerWidget {
  const SaveKnowContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 30, width: 300),
        NotoText(
          text: "保存しました！",
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: AppColors.buttonGreen,
        ),
        SizedBox(
          height: 50,
        ),
        NotoText(
          text: "○○に伝えてみよう",
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotoText(
                text: "今日ちょっと話したいことあるから時間欲しい！",
                fontSize: 10,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () async {
                await launchUrl(Uri.parse(
                    'https://line.me/R/share?text=今日ちょっと話したいことあるから時間欲しい！'));
              },
              child: Image.asset(
                "images/line.png",
                width: 160,
              )),
        ),
      ],
    );
  }
}
