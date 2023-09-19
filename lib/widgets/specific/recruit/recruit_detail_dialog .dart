import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/providers/rooms_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/recruit.dart';
import '../../../models/room.dart';

enum RadioIsShowValue {
  always,
  whenTap,
}

const double _kItemExtent = 32.0;
const List<String> _dulationNames = <String>[
  '無制限',
  '12時間',
  '24時間',
  '３日間',
  '１週間',
];

class RecruitDetailDialog extends ConsumerStatefulWidget {
  RecruitDetailDialog({super.key, required this.recruit});
  Recruit recruit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecruitDetailDialogState();
}

class _RecruitDetailDialogState extends ConsumerState<RecruitDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  int _selectedDulation = 2;
  String _time = '';
  String _isShow = '';
  String _showDuration = '';
  RadioIsShowValue gValue = RadioIsShowValue.always;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider);
    final partnerUid = ref.watch(partnerUserDocProvider).value?.id;
    final showList =
        ref.watch(myRecruitProvider('phone')).value?.data()?.showList;
    if (isFirst) {
      setState(() {
        final bool isOpenMyRecruit = (showList?.contains(partnerUid) != false);
        gValue = (isOpenMyRecruit)
            ? RadioIsShowValue.always
            : RadioIsShowValue.whenTap;
      });
    }

    final index = 2;
    final color = (index % 3 == 0)
        ? Color.fromARGB(255, 62, 213, 152)
        : (index % 3 == 1)
            ? Color.fromARGB(255, 255, 210, 30)
            : (index % 3 == 2)
                ? Color.fromRGBO(255, 203, 205, 1)
                : Color.fromARGB(255, 255, 210, 30);
    final image = (index % 3 == 0)
        ? 'GreenBoxImage.png'
        : (index % 3 == 1)
            ? 'YellowBoxImage.png'
            : (index % 3 == 2)
                ? 'Red2BoxImage.png'
                : 'YellowBoxImage.png';
    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 100),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Color.fromARGB(0, 255, 193, 7),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TitleText(
                        text: '詳細設定',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          TitleText(
                            text: '相手画面への表示：',
                          ),
                          helpButtom(context),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            color: Color.fromARGB(0, 255, 255, 255),
                            child: Radio(
                                value: RadioIsShowValue.always,
                                groupValue: gValue,
                                onChanged: (value) {
                                  setState(() {
                                    isFirst = false;
                                  });
                                  _onRadioSelected(value);
                                }),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TitleText(
                                text: '最初から相手の画面に表示する。',
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            color: Color.fromARGB(0, 255, 255, 255),
                            child: Radio(
                                value: RadioIsShowValue.whenTap,
                                groupValue: gValue,
                                onChanged: (value) {
                                  setState(() {
                                    isFirst = false;
                                  });
                                  _onRadioSelected(value);
                                }),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TitleText(
                                text: 'パートナーが通話したいを押したときに表示する。',
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 40),
                      TextButton(
                          onPressed: () {
                            final bool _isShowRecruit =
                                (gValue != RadioIsShowValue.whenTap);
                            updateUserData(ref,
                                field: 'isShowRecruit', value: _isShowRecruit);
                            if (_isShowRecruit)
                              updateRecruit(ref, 'phone', {
                                'isShow': _isShowRecruit,
                                'showList': [uid, partnerUid]
                              });
                            if (_isShowRecruit == false)
                              updateRecruit(ref, 'phone', {
                                'isShow': _isShowRecruit,
                                'showList': [uid]
                              });
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            fixedSize: Size(150, 40),
                          ),
                          child: Text(
                            '設定を保存',
                            style: GoogleFonts.nunito(
                                // color: Color.fromARGB(255, 243, 243, 243)),
                                color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Positioned(
                    left: 25,
                    top: 25,
                    child: IconButton(
                        onPressed: (() => Navigator.of(context).pop()),
                        icon: Icon(Icons.close))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: 100,
                        child: Image.asset('images/roomgrid/${image}'))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell helpButtom(BuildContext context) {
    return InkWell(
      onTap: showBaseDialog(context,
          onButtonPressd: null,
          height: sHieght(context) * 0.9,
          width: sWidth(context) * 0.96,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: NotoText(
                  text: '1.最初から相手の画面に表示:',
                  textHight: 1.2,
                  fontSize: 20,
                )),
            NotoText(text: 'パートナーの画面に最初から「通話したい」が表示されます。'),
            Image.asset(
              'images/home/RecruitShowDescriptionB.png',
              width: 150,
            ),
            SizedBox(height: 20),
            Align(
                alignment: Alignment.centerLeft,
                child: NotoText(
                    fontSize: 20,
                    textHight: 1.2,
                    text: '2.パートナーが通話したいを押したときに表示:')),
            NotoText(text: 'パートナーが通話したい気分を押したときに、あなたの「通話したい」がパートナーの画面に表示されます。'),
            Row(
              children: [
                Flexible(
                  child: Image.asset(
                    'images/home/RecruitShowDescriptionA.png',
                  ),
                ),
                Icon(Icons.arrow_forward_rounded),
                Flexible(
                  child: Image.asset(
                    'images/home/RecruitShowDescriptionB.png',
                  ),
                ),
              ],
            ),
          ],
          buttonExist: false),
      child: Icon(
        Icons.help_rounded,
        color: Color.fromARGB(162, 186, 186, 186),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  _onRadioSelected(value) {
    setState(() {
      gValue = value;
    });
  }

  void _submission() {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
    }
  }

  Future<void> addRoom(
    String roomname,
    String description,
  ) async {
    final user = ref.watch(authStateProvider).value!;
    final lastRoomIndex = ref.watch(lastRoomIndexProvider).value ?? 1;
    final roomIndex = lastRoomIndex + 1;

    final newDocumentReference = ref.read(roomsReferenceProvider).doc();

    final newRoom = Room(
      roomname: roomname,
      roomId: newDocumentReference.id,
      reference: newDocumentReference,
      roomIndex: roomIndex,
    );

    // 先ほど作った newDocumentReference のset関数を実行するとそのドキュメントにデータが保存されます。
    // 引数として Post インスタンスを渡します。
    // 通常は Map しか受け付けませんが、withConverter を使用したことにより Post インスタンスを受け取れるようになります。
    newDocumentReference.set(newRoom);
    ref
        .watch(talkroomReferenceProvider)
        .value
        ?.update({'lastRoomIndex': roomIndex});
  }
}

class TextForm extends StatefulWidget {
  TextForm({
    Key? key,
    required this.formKey,
    required this.text,
    required this.hintText,
    required this.onSaved,
    this.color = Colors.white,
  }) : super(key: key);
  String text;
  String hintText;
  Color color;
  Key? formKey;
  void Function(String?)? onSaved;

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Container(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Row(
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.nunito(
                      fontSize: 24,
                      color: widget.color,
                      fontWeight: FontWeight.w800),
                ),
                Material(
                  color: Color.fromARGB(0, 255, 214, 64),
                  child: Container(
                    width: 160,
                    child: new TextFormField(
                      enabled: true,
                      obscureText: false,
                      style:
                          GoogleFonts.nunito(color: widget.color, fontSize: 24),
                      decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle:
                              TextStyle(color: widget.color, fontSize: 24),
                          // labelText: '部屋の名前',
                          // labelStyle: TextStyle(
                          //     color: Colors.white, fontSize: 24),
                          filled: true,
                          fillColor: Color.fromARGB(0, 255, 193, 7)),
                      onSaved: widget.onSaved,
                    ),
                  ),
                ),
              ],
            )));
  }
}
