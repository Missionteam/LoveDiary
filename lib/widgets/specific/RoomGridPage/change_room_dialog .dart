import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/providers/rooms_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/widgets/record/player/player.dart';

import '../../../models/room.dart';

enum RadioColorValue {
  Red,
  Yellow,
  Orange,
}

class ChangeRoomDialog extends ConsumerStatefulWidget {
  ChangeRoomDialog({super.key, required this.room});
  Room room;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeRoomDialogState();
}

class _ChangeRoomDialogState extends ConsumerState<ChangeRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String _roomName = '';
  String _description = '';
  RadioColorValue _gValue = RadioColorValue.Yellow;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  void _submission() {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
    }
    if (this._formKey1.currentState!.validate()) {
      this._formKey1.currentState!.save();
    }
  }

  Future<void> changeRoom(
    String roomname,
    String description,
  ) async {
    final DocumentReference = widget.room.reference;
    DocumentReference.update(
        {'roomname': roomname, 'description': description});
    // final user = ref.watch(authStateProvider).value!;
    // final lastRoomIndex = ref.watch(lastRoomIndexProvider).value ?? 1;
    // final roomIndex = lastRoomIndex + 1;

    // ref
    //     .watch(talkroomReferenceProvider)
    //     .value
    //     ?.update({'lastRoomIndex': roomIndex});
  }

  @override
  Widget build(BuildContext context) {
    final roomRef = ref.watch(currentRoomRefProvider);
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
    return Padding(
      padding: EdgeInsets.only(
          top: sHieght(context) * 0.14,
          left: 30,
          right: 30,
          bottom: sHieght(context) * 0.14),
      child: GestureDetector(
        onTap: () {
          primaryFocus!.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 60, right: 60),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                              width: 100,
                              child: Image.asset('images/roomgrid/${image}'))),
                      Form(
                          key: _formKey,
                          child: Container(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Color.fromARGB(0, 255, 214, 64),
                                      child: Container(
                                        width: 160,
                                        child: new TextFormField(
                                          enabled: true,
                                          initialValue: widget.room.roomname,
                                          obscureText: false,
                                          style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 24),
                                          decoration: const InputDecoration(
                                              hintText: '〇〇の',
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24),
                                              // labelText: '部屋の名前',
                                              // labelStyle: TextStyle(
                                              //     color: Colors.white, fontSize: 24),
                                              filled: true,
                                              fillColor: Color.fromARGB(
                                                  0, 255, 193, 7)),
                                          onSaved: (String? value) {
                                            this._roomName = value ?? '';
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '部屋',
                                    style: GoogleFonts.nunito(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ))),
                      Form(
                          key: _formKey1,
                          child: Container(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: Material(
                                color: Color.fromARGB(0, 255, 214, 64),
                                child: new TextFormField(
                                  enabled: true,
                                  maxLength: 120,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  initialValue: widget.room.description,
                                  obscureText: false,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'この部屋がどんな部屋か説明してください。',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    labelText: '部屋の説明',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onSaved: (String? value) {
                                    this._description = value ?? '';
                                  },
                                ),
                              ))),
                      TextButton(
                          onPressed: () {
                            _submission();
                            changeRoom(this._roomName, this._description);
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
                  Positioned(
                    right: 0,
                    child: Material(
                        color: AppColors.noColor,
                        child: RoomDeleteButton(
                          onDelete: () {
                            widget.room.reference.delete();
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
