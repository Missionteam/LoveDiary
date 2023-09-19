import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/rooms_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/room.dart';

enum RadioIsShowValue {
  always,
  whenTap,
  Orange,
}

const double _kItemExtent = 32.0;
const List<String> _dulationNames = <String>[
  '無制限',
  '12時間',
  '24時間',
  '３日間',
  '１週間',
];

class TextFormDialog extends ConsumerStatefulWidget {
  TextFormDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextFormDialogState();
}

class _TextFormDialogState extends ConsumerState<TextFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  int _selectedDulation = 2;
  String _time = '';
  String _isShow = '';
  String _showDuration = '';
  RadioIsShowValue _gValue = RadioIsShowValue.always;
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

  @override
  Widget build(BuildContext context) {
    final lastRoomIndex = ref.watch(lastRoomIndexProvider).value ?? 1;
    final index = lastRoomIndex + 1;
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextForm(
                        formKey: _formKey,
                        text: '時間：',
                        hintText: '',
                        onSaved: (String? value) {
                          this._time = value ?? '';
                        }),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TitleText(text: '相手画面への表示：')),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Color.fromARGB(0, 255, 255, 255),
                          child: Radio(
                              value: RadioIsShowValue.always,
                              groupValue: _gValue,
                              onChanged: (value) {
                                _onRadioSelected(value);
                              }),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MainText(text: '最初から相手の画面に表示する。'),
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
                              groupValue: _gValue,
                              onChanged: (value) {
                                _onRadioSelected(value);
                              }),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MainText(text: 'パートナーが通話したいを押したときに表示する。'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TitleText(text: '表示期間:'),
                        Expanded(
                          child: MaterialButton(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(bottom: 5),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: TitleText(
                                  text: _dulationNames[_selectedDulation],
                                ),
                              ),
                              onPressed: () => _showDialog(CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    useMagnifier: true,
                                    itemExtent: _kItemExtent,
                                    // This is called when selected item is changed.
                                    onSelectedItemChanged: (int selectedItem) {
                                      setState(() {
                                        _selectedDulation = selectedItem;
                                      });
                                    },
                                    children: List<Widget>.generate(
                                        _dulationNames.length, (int index) {
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
                    SizedBox(height: 40),
                    TextButton(
                        onPressed: () {
                          _submission();
                          addRoom(this._time, this._isShow);
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
                  ],
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 15,
                  child: TextButton(
                    child: MainText(
                      text: '詳細設定',
                      color: Color.fromARGB(255, 12, 89, 255),
                    ),
                    onPressed: (() => {}),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: 100,
                      child: Image.asset('images/roomgrid/${image}'))),
            ],
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
