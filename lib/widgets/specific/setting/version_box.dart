import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';

import '../../../main.dart';

enum RadioModeValue {
  Tweet,
  Rooms,
}

class VersionBox extends ConsumerStatefulWidget {
  const VersionBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VersionBoxState();
}

class _VersionBoxState extends ConsumerState<VersionBox> {
  @override
  Widget build(BuildContext context) {
    final talkroomDoc = ref.watch(talkroomDocProvider).value;
    final version = talkroomDoc?.get('version');

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: InkWell(
        onTap: () async {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(
                  builder: ((context, setState) => ModeAlertDialog(
                        version: version,
                      ))));
          // GoRouter.of(context).push('/RoomGrid1/Chat1');
        },
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 251, 160, 25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                  ),
                  child: Text('アプリのモードを切り替える',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 10),
                child: Text('・つぶやき特化モード\n・色んなトークルームモード',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                ),
                child: Text('のどちらかに切り替えられます',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModeAlertDialog extends ConsumerStatefulWidget {
  ModeAlertDialog({super.key, required this.version});
  int version;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModeAlertDialogState();
}

class _ModeAlertDialogState extends ConsumerState<ModeAlertDialog> {
  RadioModeValue _gValue = RadioModeValue.Tweet;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    final talkroomRef = ref.watch(talkroomReferenceProvider).value;

    if (isFirst) {
      setState(() {
        _gValue =
            (widget.version == 0) ? RadioModeValue.Tweet : RadioModeValue.Rooms;
      });
    }
    return AlertDialog(
      title: Text(
        '※変更を反映させるにはアプリを再起動してください。',
        style: GoogleFonts.nunito(),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            Radio(
                value: RadioModeValue.Tweet,
                groupValue: _gValue,
                onChanged: (value) {
                  setState(() {
                    isFirst = false;
                  });
                  _onRadioSelected(value);
                }),
            Text('つぶやき特化モード')
          ],
        ),
        Row(
          children: [
            Radio(
                value: RadioModeValue.Rooms,
                groupValue: _gValue,
                onChanged: (value) {
                  setState(() {
                    isFirst = false;
                  });
                  _onRadioSelected(value);
                }),
            Text('色んなトークルームモード')
          ],
        ),
        Text('この変更はパートナーの画面にも反映されます。'),
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: const Text('変更'),
            onPressed: () async {
              try {
                int version = (_gValue == RadioModeValue.Tweet) ? 0 : 1;

                talkroomRef?.update({'version': version});
                runApp(
                  ProviderScope(child: InitPage()),
                );
                Navigator.of(context).pop();

                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return MyApp();
                // }));
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
      ]),
    );
  }
}
