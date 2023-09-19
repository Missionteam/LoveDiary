import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/widgets/util/text.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveLoveContent extends ConsumerWidget {
  const SaveLoveContent({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 30, width: 300),
        Text("〇個目の好きなところ\n記入完了！\nおめでとう！",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 24, height: 2)),
        SizedBox(
          height: 50,
        ),
        NotoText(
          text: "今すぐ、\n〇〇に伝えてみよう",
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
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
                text: text,
                fontSize: 10,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () async {
                await launchUrl(
                    Uri.parse('https://line.me/R/share?text=' + text));
              },
              child: Image.asset(
                "images/line.png",
                width: 160,
              )),
        ),
        SizedBox(height: 40)
      ],
    );
  }
}
