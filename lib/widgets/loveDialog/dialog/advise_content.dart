import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/widgets/util/text.dart';

class AdviseContent extends ConsumerWidget {
  const AdviseContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10, width: 300),
          Align(
            alignment: Alignment.center,
            child: NotoText(
              text: "整理のコツ",
              fontWeight: FontWeight.w700,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 50),
          NotoText(
            text: "①まずは感じたままに書き出そう",
            fontSize: 16,
            textAlign: TextAlign.start,
          ),
          NotoText(
            text: "そのまま見せるわけじゃないからね！",
            fontSize: 10,
            fontWeight: FontWeight.w400,
            topPadding: 10,
            leftPadding: 16,
          ),
          SizedBox(height: 40),
          NotoText(
            text: "②あまりにもイライラしてきたら、\n　あとにして好きなことしよう！",
            fontSize: 16,
          ),
          NotoText(
            text: "無理は禁物",
            fontSize: 10,
            fontWeight: FontWeight.w400,
            topPadding: 10,
            leftPadding: 16,
          ),
          SizedBox(height: 40),
          NotoText(
            text: "③性善説に基づいて、相手の主張を\n　考えてみよう",
            fontSize: 16,
          ),
          NotoText(
            text: "好きなとこリストを見直して、いいとこ思いだそう。",
            fontSize: 10,
            fontWeight: FontWeight.w400,
            topPadding: 10,
            leftPadding: 16,
          ),
          SizedBox(height: 40),
          NotoText(
            text: "④話したいことだけまとめておこう",
            fontSize: 16,
          ),
          NotoText(
            text: "解決策はふたりで考える！",
            fontSize: 10,
            fontWeight: FontWeight.w400,
            topPadding: 10,
            leftPadding: 16,
          ),
        ],
      ),
    );
  }
}
