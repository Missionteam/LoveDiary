import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/pages/tworoom/chat_room_page.dart';

import '../../../models/room_id_model.dart';

class RoomBox extends ConsumerWidget {
  RoomBox({
    super.key,
    required this.RoomName,
    this.color = const Color.fromARGB(255, 255, 210, 30),
    this.imgPath = 'YellowBoxImage.png',
    required this.roomId,
  });
  String RoomName;
  Color color;
  String imgPath;
  String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Container(
        width: 160,
        height: 300,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 25,
                left: 20,
                child: Text('''
${RoomName}
部屋''',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ))),
            Positioned(
                left: 30,
                bottom: 0,
                width: 100,
                child: Image.asset('images/roomgrid/${imgPath}')),
            Positioned(
                width: 160,
                height: 240,
                child: MaterialButton(
                  onPressed: () {
                    ref.watch(roomIdProvider.notifier).setRoomId(roomId);
                    showDialog(
                        context: context, builder: (_) => ChatRoomPage1());
                    // GoRouter.of(context).push('/RoomGrid1/Chat1');
                  },
                ))
          ],
        ),
      ),
    );
  }
}
