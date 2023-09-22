import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/know.dart';
import '../util/text.dart';
import '../util/text_form.dart';

class KnowTalkSummary extends ConsumerWidget {
  const KnowTalkSummary({
    Key? key,
    required this.formKey5,
    required this.formKey6,
    required this.formKey7,
    this.controller1,
    this.controller2,
    this.controller3,
    this.what,
    this.why,
    this.baseReason,
    this.onBaseReasonStaySaved,
    this.onWhatSaved,
    this.onWhySaved,
    this.onFeeingsSaved,
    this.onBaseReasonLoveSaved,
    this.know,
  }) : super(key: key);
  final String? what;
  final String? why;
  final String? baseReason;
  final void Function(String?)? onWhatSaved;
  final void Function(String?)? onWhySaved;
  final void Function(String?)? onFeeingsSaved;
  final void Function(bool?)? onBaseReasonLoveSaved;
  final void Function(bool?)? onBaseReasonStaySaved;
  final Key formKey5;
  final Key formKey6;
  final Key formKey7;
  final Know? know;
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  final TextEditingController? controller3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: Color(0xffF7ECDE),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotoText(text: "今から言うことは、"),
          BaseReasonItem(baseReason: "love", text: "あなたのことが大好き"),
          BaseReasonItem(baseReason: "stay", text: "これからも一緒にいたい"),
          NotoText(text: "と思っているから伝えるんだけど"),
          TextForm(
            formKey: formKey5,
            text: "",
            controller: controller1,
            hintText: "(例)夏休みにどこ行きたいか聞いたら、「どこでもいいよ」と言われた。",
            initialValue: this.what ?? know?.what ?? "",
            color: Color.fromARGB(255, 28, 28, 28),
            width: double.maxFinite,
            topPadding: 0,
            fontSize: 10,
            onSaved: onWhatSaved,
          ),
          NotoText(text: "というできごとに、"),
          TextForm(
            formKey: formKey6,
            controller: controller2,
            text: "",
            hintText: "(例)出かけるの楽しみじゃないのかなと思ったから",
            initialValue: know?.why ?? "",
            color: Color.fromARGB(255, 28, 28, 28),
            width: double.maxFinite,
            topPadding: 0,
            fontSize: 10,
            onSaved: onWhySaved,
          ),
          Row(
            children: [
              NotoText(text: "私は"),
              TextForm(
                formKey: formKey7,
                text: "",
                hintText: "",
                controller: controller3,
                initialValue: know?.why ?? "",
                color: Color.fromARGB(255, 28, 28, 28),
                fontSize: 10,
                topPadding: 0,
                width: 100,
                onSaved: onFeeingsSaved,
              ),
              NotoText(text: "と感じた。"),
            ],
          ),
          NotoText(
            text: "悪気がないことは分かっているけど、\nもやもやするのでどうしたらいいか話したい。",
          )
        ],
      ),
    );
  }

  Row BaseReasonItem({required String baseReason, required text}) {
    return Row(
      children: [
        Checkbox(
            value: (this.baseReason == baseReason),
            onChanged: (baseReason == "love")
                ? onBaseReasonLoveSaved
                : (baseReason == "stay")
                    ? onBaseReasonStaySaved
                    : null),
        NotoText(text: text),
      ],
    );
  }
}
