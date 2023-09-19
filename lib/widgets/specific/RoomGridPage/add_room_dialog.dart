import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/rooms_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';

import '../../../models/room.dart';

enum RadioColorValue {
  Red,
  Yellow,
  Orange,
}

class AddRoomDialog extends ConsumerStatefulWidget {
  AddRoomDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends ConsumerState<AddRoomDialog> {
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
    return Padding(
      padding:
          const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 100),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                      key: _formKey,
                      child: Container(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: Row(
                            children: [
                              Material(
                                color: Color.fromARGB(0, 255, 214, 64),
                                child: Container(
                                  width: 160,
                                  child: new TextFormField(
                                    enabled: true,
                                    obscureText: false,
                                    style: GoogleFonts.nunito(
                                        color: Colors.white, fontSize: 24),
                                    decoration: const InputDecoration(
                                        hintText: '〇〇の',
                                        hintStyle: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                        // labelText: '部屋の名前',
                                        // labelStyle: TextStyle(
                                        //     color: Colors.white, fontSize: 24),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(0, 255, 193, 7)),
                                    onSaved: (String? value) {
                                      this._roomName = value ?? '';
                                    },
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
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: Material(
                            color: Color.fromARGB(0, 255, 214, 64),
                            child: new TextFormField(
                              enabled: true,
                              maxLength: 80,
                              obscureText: false,
                              decoration: const InputDecoration(
                                hintText: 'この部屋がどんな部屋か説明してください。',
                                labelText: '部屋の説明',
                              ),
                              onSaved: (String? value) {
                                this._description = value ?? '';
                              },
                            ),
                          ))),
                  TextButton(
                      onPressed: () {
                        _submission();
                        addRoom(this._roomName, this._description);
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
}
