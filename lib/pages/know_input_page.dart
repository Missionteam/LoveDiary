import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/update_know.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/advise_content.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/save_know_content.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/save_love_content.dart';
import 'package:thanks_diary/widgets/loveDialog/know_text_form.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../function/send_know.dart';
import '../models/know.dart';
import '../models/loveCategory_model.dart';

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
                if (this.situation != "" ||
                    this.feeling != "" ||
                    this.why != "" ||
                    this.view != "" ||
                    this.want != "" ||
                    this.talk != "")
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
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => BaseDialog(
                              onButtonPressd: () {},
                              buttonExist: false,
                              color: Colors.white,
                              closeIconExist: true,
                              children: [
                                SaveLoveContent(
                                  text: "",
                                )
                              ],
                            ));
                  },
                  icon: Icon(Icons.share_outlined,
                      color: Color.fromARGB(255, 40, 40, 40), size: 20))
            ],
            backgroundColor: AppColors.appbar,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                    KnowTextForm(
                        formKey: formKey,
                        text: "状況を書き出してみよう",
                        hintText: "(例)夏休みどこ行く？と聞いたら、「どこでもいいよ」と言われた",
                        initialValue: widget.know?.situation ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.situation = value;
                        }),
                    KnowTextForm(
                        formKey: formKey1,
                        text: "感情を書き出してみよう",
                        hintText: "(例)腹立つ。考える素振りくらい見せろ。任せておけばプラン立ってると思うなよ？",
                        initialValue: widget.know?.feeling ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.feeling = value;
                        }),
                    KnowTextForm(
                        formKey: formKey2,
                        text: "なぜそう感じた？",
                        hintText:
                            "(例)デートのプランを立てているのは毎回自分で、私と出かけるのそんなに楽しみじゃないのかなと思ってしまうから。",
                        initialValue: widget.know?.why ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.why = value;
                        }),
                    KnowTextForm(
                        formKey: formKey3,
                        text: "○○の肩を持ってみよう",
                        hintText:
                            "(例)楽しみじゃないわけじゃない。選んでくれるところは全部楽しいし、調べるのが好きなんだと思っていた。",
                        initialValue: widget.know?.view ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.view = value;
                        }),
                    KnowTextForm(
                        formKey: formKey4,
                        text: "どうしてほしい？",
                        hintText: "(例)たまにはデートプランを立ててほしい。",
                        maxline: 2,
                        initialValue: widget.know?.want ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.want = value;
                        }),
                    KnowTextForm(
                        formKey: formKey5,
                        text: "話したいこと",
                        hintText:
                            "(例)デートの行き先決めがわりと負担。○○の行きたいところにも行ってみたい。できれば順番に決めたいけどどうか。",
                        maxline: 2,
                        initialValue: widget.know?.talk ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          this.talk = value;
                        }),
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
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });