import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thanks_diary/widgets/record/recorder.dart';

class VoicePage extends ConsumerStatefulWidget {
  VoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => VoicePageState();
}

class VoicePageState extends ConsumerState<VoicePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 30)
          GoRouter.of(context).go('/RoomGrid1');
      },
      child: Container(
        color: Color.fromARGB(255, 52, 52, 52),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flexible(
            //     child: Column(
            //   children: [
            //     VoicePageListView(
            //       ref: ref,
            //     ),
            //   ],
            // )),
            SizedBox(height: 100),
            AudioRecorder(isCircleButton: true),
            // SizedBox(
            //   height: 60,
            // ),
            // MainText(
            //   text: 'タップしながら話す',
            //   color: Color.fromARGB(255, 180, 180, 180),
            // )
          ],
        ),
      ),
    );
  }
}
