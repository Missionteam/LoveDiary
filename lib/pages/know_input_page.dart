import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/update_know.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/advise_content.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/save_know_content.dart';
import 'package:thanks_diary/widgets/loveDialog/know_text_form.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../function/send_know.dart';
import '../models/know.dart';
import '../models/loveCategory_model.dart';
import '../widgets/loveDialog/know_items.dart';

class KnowInputPage extends ConsumerStatefulWidget {
  KnowInputPage({Key? key, this.know}) : super(key: key);
  final Know? know;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InputPageState();
}

class InputPageState extends ConsumerState<KnowInputPage> {
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormState>();
  LoveReason? _selectedItemPath;
  String? situation;
  String? feeling;
  String? why;
  String? view;
  String? want;
  String? talk;
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  void _handleItemTap(LoveReason? loveReason) {
    setState(() {
      _selectedItemPath = loveReason;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColors.main,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                formKey.currentState?.save();
                formKey1.currentState?.save();
                formKey2.currentState?.save();
                formKey3.currentState?.save();
                formKey4.currentState?.save();
                formKey5.currentState?.save();
                if ((this.situation != "" ||
                        this.feeling != "" ||
                        this.why != "" ||
                        this.view != "" ||
                        this.want != "" ||
                        this.talk != "") &&
                    widget.know == null)
                  sendKnow(
                    ref,
                    situation: this.situation,
                    feelings: this.feeling,
                    why: this.why,
                    view: this.view,
                    want: this.want,
                    talk: this.talk,
                    imageCloudPath: imageCloudPath,
                    imageFile: imageFile,
                  );
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined,
                  color: Color.fromARGB(255, 40, 40, 40), size: 20),
            ),
            backgroundColor: AppColors.appbar,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    NotoText(
                      text: (widget.know == null)
                          ? "もやもやを整理しよう"
                          : DateFormat('M/d')
                              .format(widget.know!.date.toDate()),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => BaseDialog(
                                        onButtonPressd: () {},
                                        buttonExist: false,
                                        width: sWidth(context) * 0.83,
                                        height: 500,
                                        color: Colors.white,
                                        closeIconExist: true,
                                        children: [AdviseContent()],
                                      ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonGreen,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 189, 189, 189),
                                        offset: Offset(2, 2),
                                        blurRadius: 2,
                                        spreadRadius: 2)
                                  ]),
                              child: Text("コツを見る",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                            ))),
                    SizedBox(height: 26),
                    KnowItemList(
                      text: "もやもやしたことを選ぼう",
                      onItemTap: _handleItemTap,
                      selectedReason: _selectedItemPath,
                      text1: "言い方",
                      text2: "態度",
                      text3: "家事",
                      text4: "連絡頻度",
                      text5: "スキンシップ",
                      text6: "その他",
                    ),
                    KnowTextForm(
                        formKey: formKey,
                        text: "何があった？",
                        hintText: "(例)夏休みどこ行きたいか聞いたら、「どこでもいいよ」と言われた",
                        initialValue: widget.know?.feeling ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.feeling = value;
                        }),
                    KnowItemList(
                      text: "今の感情を探そう",
                      onItemTap: _handleItemTap,
                      selectedReason: _selectedItemPath,
                      text1: "悲しい",
                      text2: "イライラ",
                      text3: "悔しい",
                      text4: "寂しい",
                      text5: "無気力",
                      text6: "その他",
                    ),
                    KnowTextForm(
                        formKey: formKey4,
                        text: "なぜそう感じた？",
                        hintText: "(例)出かけるの楽しみじゃないのかなと思ったから",
                        initialValue: widget.know?.why ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.why = value;
                        }),
                    Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 14,
                        ),
                        Text(
                          "話したいことをまとめ",
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      color: Color(0xffF7ECDE),
                      child: Column(
                        children: [
                          NotoText(text: "今から言うことは、"),
                          NotoText(text: "あなたのことが大好き"),
                          NotoText(text: "これからも一緒にいたい"),
                          NotoText(text: "と思っているから伝えるんだけど"),
                          KnowTextForm(
                              formKey: formKey5,
                              text: "",
                              hintText: "(例)出かけるの楽しみじゃないのかなと思ったから",
                              initialValue: widget.know?.why ?? "",
                              color: Color.fromARGB(255, 28, 28, 28),
                              fontSize: 10,
                              onSaved: (String? value) {
                                this.why = value;
                              }),
                          NotoText(text: "というできごとに、"),
                          KnowTextForm(
                              formKey: formKey6,
                              text: "",
                              hintText: "(例)出かけるの楽しみじゃないのかなと思ったから",
                              initialValue: widget.know?.why ?? "",
                              color: Color.fromARGB(255, 28, 28, 28),
                              fontSize: 10,
                              onSaved: (String? value) {
                                this.why = value;
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        formKey.currentState?.save();
                        formKey1.currentState?.save();
                        formKey2.currentState?.save();
                        formKey3.currentState?.save();
                        formKey4.currentState?.save();
                        formKey5.currentState?.save();
                        if (widget.know == null) {
                          sendKnow(
                            ref,
                            situation: this.situation,
                            feelings: this.feeling,
                            why: this.why,
                            view: this.view,
                            want: this.want,
                            talk: this.talk,
                            imageCloudPath: imageCloudPath,
                            imageFile: imageFile,
                          );
                        } else {
                          updateKnow(
                            ref,
                            widget.know!.reference,
                            situation: this.situation,
                            feelings: this.feeling,
                            why: this.why,
                            view: this.view,
                            want: this.want,
                            talk: this.talk,
                            imageCloudPath: imageCloudPath,
                            imageFile: imageFile,
                          );
                        }

                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => BaseDialog(
                                  onButtonPressd: () {},
                                  buttonExist: false,
                                  color: Colors.white,
                                  closeIconExist: true,
                                  children: [SaveKnowContent()],
                                ));
                      },
                      child: Text("保存"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(260, 40),
                        shape: const StadiumBorder(),
                      ),
                    ),
                    SizedBox(height: 40)
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckboxList extends StatelessWidget {
  const CheckboxList({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
  });
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxAndText(text: text1),
        CheckboxAndText(text: text2),
        CheckboxAndText(text: text3),
      ],
    );
  }
}

class CheckboxAndText extends StatelessWidget {
  ///アプリに表示されない、ウィジェットが持っている変数を書くところ。
  const CheckboxAndText({super.key, required this.text});
  final String text;

  ///中身のウィジェット（実際にアプリが表示される部分）
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Checkbox(value: true, onChanged: (bool) {}), Text(text)],
    );
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });