import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/update_know.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/advise_content.dart';
import 'package:thanks_diary/widgets/loveDialog/know_talk_summary.dart';
import 'package:thanks_diary/widgets/loveDialog/know_text_form.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../function/send_know.dart';
import '../models/know.dart';
import '../widgets/loveDialog/know_check_box.dart';

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
  final formKey7 = GlobalKey<FormState>();
  String? _selectedHazy;
  String? _selectedFeelings;
  String? what;
  String? why;
  String? baseReason;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;

  void _handleHazyTap(String? text) {
    setState(() {
      _selectedHazy = text;
    });
  }

  void _handleFeelingTap(String? text) {
    setState(() {
      _selectedFeelings = text;
      _controller3.text = text ?? "";
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
          appBar: appBar(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    headText(),
                    SizedBox(height: 10),
                    watchTipsButton(context),
                    SizedBox(height: 26),
                    KnowCheckBoxList(
                      text: "もやもやしたことを選ぼう",
                      onItemTap: _handleHazyTap,
                      selectedItemText: _selectedHazy,
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
                        initialValue: widget.know?.what ?? "",
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontSize: 10,
                        onSaved: (String? value) {
                          setState(() {
                            this.what = value;
                            _controller1.text = value ?? "";
                          });
                        }),
                    KnowCheckBoxList(
                      text: "今の感情を探そう",
                      onItemTap: _handleFeelingTap,
                      selectedItemText: _selectedFeelings,
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
                          setState(() {
                            this.why = value;
                            _controller2.text = value ?? "";
                          });
                        }),
                    SizedBox(height: 40),
                    SaveButton(context),
                    SizedBox(height: 40)
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  KnowTalkSummary knowTalkSummary() {
    return KnowTalkSummary(
      formKey5: formKey5,
      formKey6: formKey6,
      formKey7: formKey7,
      controller1: _controller1,
      controller2: _controller2,
      controller3: _controller3,
      know: widget.know,
      baseReason: this.baseReason,
      what: this.what,
      why: this.why,
      onBaseReasonLoveSaved: (bool? value) {
        if (value == true) {
          setState(() {
            this.baseReason = "love";
          });
        }
      },
      onBaseReasonStaySaved: (bool? value) {
        if (value == true) {
          setState(() {
            this.baseReason = "stay";
          });
        }
      },
      onWhatSaved: (String? value) {
        setState(() {
          this.what = value;
        });
      },
      onWhySaved: (String? value) {
        setState(() {
          this.why = value;
        });
      },
      onFeeingsSaved: (String? value) {
        setState(() {
          this._selectedFeelings = value;
        });
      },
    );
  }

  ElevatedButton SaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        saveKnow();
        Navigator.of(context).pop();
        // showDialog(
        //     context: context,
        //     builder: (context) => BaseDialog(
        //           onButtonPressd: () {},
        //           buttonExist: false,
        //           color: Colors.white,
        //           closeIconExist: true,
        //           children: [SaveKnowContent()],
        //         ));
      },
      child: Text("保存"),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(260, 40),
        shape: const StadiumBorder(),
      ),
    );
  }

  void saveKnow() {
    formKey.currentState?.save();
    formKey1.currentState?.save();
    formKey2.currentState?.save();
    formKey3.currentState?.save();
    formKey4.currentState?.save();
    formKey5.currentState?.save();
    if (!(this.what != "" || this.why != "")) {
    } else if (widget.know == null) {
      sendKnow(ref,
          baseReason: this.baseReason,
          what: this.what,
          why: this.why,
          feelings: this._selectedFeelings);
    } else {
      updateKnow(
        ref,
        widget.know!.reference,
        what: this.what,
        why: this.why,
      );
    }
  }

  Align watchTipsButton(BuildContext context) {
    return Align(
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.buttonGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 189, 189, 189),
                        offset: Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ]),
              child: Text("コツを見る",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  )),
            )));
  }

  NotoText headText() {
    return NotoText(
      text: (widget.know == null)
          ? "もやもやを整理しよう"
          : DateFormat('M/d').format(widget.know!.date.toDate()),
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          formKey.currentState?.save();
          formKey1.currentState?.save();
          formKey2.currentState?.save();
          formKey3.currentState?.save();
          formKey4.currentState?.save();
          formKey5.currentState?.save();
          if ((this.what != "" || this.why != "") && widget.know == null)
            saveKnow();
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_new_outlined,
            color: Color.fromARGB(255, 40, 40, 40), size: 20),
      ),
      backgroundColor: AppColors.appbar,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}
