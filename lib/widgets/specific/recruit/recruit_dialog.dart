import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/providers/cloud_messeging_provider.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/widgets/specific/recruit/recruit_detail_dialog%20.dart';

import '../../../models/recruit.dart';
import '../../../providers/users_provider.dart';
import '../../util/text.dart';

const double _kItemExtent = 32.0;
const List<String> _dulationNames = <String>[
  '無制限',
  '12時間',
  '24時間',
  '3日間',
  '1週間',
];

class RecruitDialog extends ConsumerStatefulWidget {
  RecruitDialog({super.key, required this.recruit});
  Recruit recruit;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecruitDialogState();
}

class _RecruitDialogState extends ConsumerState<RecruitDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedDulation;
  String _time = '';

  String _isShow = '';
  String _showDuration = '';
  RadioIsShowValue _gValue = RadioIsShowValue.always;
  bool isNotify = true;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  void _submission() {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
    }
  }

  Future<void> updateData(
    String time,
    int dulation,
  ) async {
    final data = {'time': time, 'dulation': dulation};
    updateRecruit(ref, widget.recruit.type, data);
  }

  @override
  void initState() {
    _selectedDulation = widget.recruit.dulation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final partnerDoc = ref.watch(partnerUserDocProvider).value?.data();
    final partnerUid = partnerDoc?.id;
    final showList =
        ref.watch(myRecruitProvider('phone')).value?.data()?.showList;
    final bool isOpenMyRecruit = (showList?.contains(partnerUid) != false);
    final _token = ref.watch(PartnerfcmTokenProvider).value;
    setState(() {
      if (isOpenMyRecruit == false) isNotify = false;
    });

    final index = 0;
    final color = (index % 3 == 0)
        ? Color.fromARGB(255, 62, 213, 152)
        : (index % 3 == 1)
            ? Color.fromARGB(255, 255, 210, 30)
            : (index % 3 == 2)
                ? Color.fromARGB(255, 255, 86, 94)
                : Color.fromARGB(255, 255, 210, 30);
    final image = (index % 3 == 0)
        ? 'GreenBoxImage.png'
        : (index % 3 == 1)
            ? 'YellowBoxImage.png'
            : (index % 3 == 2)
                ? 'Red2BoxImage.png'
                : 'YellowBoxImage.png';
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: (sHieght(context) - 400) * 0.24,
          horizontal: 30,
        ),
        child: SingleChildScrollView(
          child: Material(
            color: Color.fromARGB(0, 255, 193, 7),
            child: GestureDetector(
              onTap: () {
                primaryFocus!.unfocus();
              },
              child: Container(
                width: 330,
                height: 500,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 40, right: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MagicText(
                            text: '~通話の詳細~',
                            textAlign: TextAlign.center,
                            color: Color.fromARGB(255, 255, 34, 34),
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: MagicText(
                                text: '通話したい時間：',
                                color: Color.fromARGB(255, 24, 24, 24),
                                fontSize: 20,
                              )),
                          TextForm(
                              initialValue: widget.recruit.time,
                              formKey: _formKey,
                              text: '',
                              hintText: '（例：夜はだいたい🙆‍♂️）',
                              fontSize: 20,
                              topPadding: 10,
                              color: Color.fromARGB(255, 24, 24, 24),
                              onSaved: (String? value) {
                                this._time = value ?? '';
                              }),
                          SizedBox(height: 15),
                          TextButton(
                              onPressed: () {
                                _submission();
                                updateData(this._time, this._selectedDulation);
                                updateUserData(ref,
                                    field: 'isFirstUseRecruit', value: false);
                                if (isNotify)
                                  FirebaseCloudMessagingService()
                                      .sendPushNotification(
                                          token: _token ?? '',
                                          title: 'パートナー：「時間あったら通話したい」',
                                          body: _time,
                                          type: 'home');
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                fixedSize: Size(150, 40),
                              ),
                              child: Text(
                                '保存',
                                style: GoogleFonts.nunito(
                                    // color: Color.fromARGB(255, 243, 243, 243)),
                                    color: Colors.white),
                              )),
                          SizedBox(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (isOpenMyRecruit)
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              activeColor: Colors.black,
                                              value: isNotify,
                                              onChanged: (value) {
                                                setState(() {
                                                  isNotify = !isNotify;
                                                });
                                              }),
                                          MainText(
                                            text: 'パートナーに通知する',
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 10,
                                      ),
                                SizedBox(height: 10),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 8),
                                //   child: MainText(
                                //       text: (isOpenMyRecruit)
                                //           ? '表示：        表示中'
                                //           : '表示：　パートナーが「通話したい」を押したときに表示。\n\n※現在は相手の画面には表示されていません'),
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 8),
                                    MainText(text: '表示期間:'),
                                    SizedBox(
                                      child: MaterialButton(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            alignment: Alignment.bottomCenter,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: MainText(
                                              text: _dulationNames[
                                                  _selectedDulation],
                                              textHight: 1,
                                            ),
                                          ),
                                          onPressed: () =>
                                              _showDialog(CupertinoPicker(
                                                magnification: 1.22,
                                                squeeze: 1.2,
                                                useMagnifier: true,
                                                itemExtent: _kItemExtent,
                                                // This is called when selected item is changed.
                                                onSelectedItemChanged:
                                                    (int selectedItem) {
                                                  setState(() {
                                                    _selectedDulation =
                                                        selectedItem;
                                                  });
                                                },
                                                children: List<Widget>.generate(
                                                    _dulationNames.length,
                                                    (int index) {
                                                  return Center(
                                                    child: Text(
                                                      _dulationNames[index],
                                                    ),
                                                  );
                                                }),
                                              ))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //     bottom: 10,
                    //     right: 15,
                    //     child: TextButton(
                    //         child: MainText(
                    //           text: '詳細設定',
                    //           color: Color.fromARGB(255, 12, 89, 255),
                    //         ),
                    //         onPressed: () {
                    //           showDialog(
                    //             context: context,
                    //             builder: (_) =>
                    //                 RecruitDetailDialog(recruit: widget.recruit),
                    //           );
                    //         })),
                    Positioned(
                        bottom: 10,
                        left: 15,
                        child: TextButton(
                            child: MainText(
                              text: '削除',
                              color: Color.fromARGB(255, 255, 12, 12),
                            ),
                            onPressed: () {
                              showConfirmDialog(
                                context,
                                ref,
                                title: '通話スタンプの削除',
                                main: '削除してよろしいですか？',
                              );
                            })),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: 90,
                            child: Image.asset('images/roomgrid/${image}'))),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  Future<void> showConfirmDialog(BuildContext context, WidgetRef ref,
      {String title = '', String main = '', Future<void>? onTapOK}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 255, 231, 239),
        title: NotoText(
          text: title,
          fontSize: 18,
        ),
        content: NotoText(text: main),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              int count = 0;
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              removeRecruit(ref, 'phone');
              int count = 0;
              Navigator.popUntil(context, (_) => count++ >= 2);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class TextForm extends StatefulWidget {
  TextForm({
    Key? key,
    required this.formKey,
    required this.text,
    required this.hintText,
    required this.initialValue,
    required this.onSaved,
    this.fontSize = 20,
    this.topPadding = 20,
    this.color = const Color.fromARGB(255, 28, 28, 28),
  }) : super(key: key);
  String text;
  String hintText;
  String initialValue;
  Color color;
  Key? formKey;
  double fontSize;
  double topPadding;
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
            padding: EdgeInsets.only(top: widget.topPadding, bottom: 20),
            child: Row(
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.nunito(
                      fontSize: 24,
                      color: widget.color,
                      fontWeight: FontWeight.w800),
                ),
                Expanded(
                  child: Material(
                    color: Color.fromARGB(0, 255, 214, 64),
                    child: Container(
                      width: 160,
                      child: new TextFormField(
                        enabled: true,
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        initialValue: widget.initialValue,
                        style: GoogleFonts.nunito(
                            color: widget.color,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(169, 72, 72, 72),
                              fontSize: 14,
                            ),

                            // labelText: '部屋の名前',
                            // labelStyle: TextStyle(
                            //     color: Colors.white, fontSize: 24),
                            filled: true,
                            fillColor: Color.fromARGB(0, 255, 193, 7)),
                        onSaved: widget.onSaved,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
