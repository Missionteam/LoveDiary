import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/room_id_model.dart';
import '../../../pages/tworoom/chat_room_page.dart';

class RedRoomBox extends ConsumerWidget {
  RedRoomBox({
    super.key,
    required this.RoomName,
    required this.roomId,
  });
  String RoomName;

  String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 340,
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 86, 94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
              top: 30,
              left: 30,
              child: Text('''
${RoomName}
部屋''',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ))),
          Positioned(
            child: DeepRedBox(),
            bottom: 0,
            left: 0,
          ),
          Positioned(
              right: 0,
              child: Container(
                width: 20,
                height: 160,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 70, 79),
                    borderRadius: BorderRadius.circular(10)),
              )),
          Positioned(
              bottom: 0,
              right: 20,
              child: Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 70, 79),
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
          Positioned(
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 70, 79),
              ),
            ),
            top: 70,
            left: 140,
          ),
          Positioned(
              right: 0,
              top: 90,
              width: 180,
              child: Image.asset('images/roomgrid/RedBoxImage.png')),
          Positioned(
              width: 340,
              height: 200,
              child: MaterialButton(
                onPressed: () {
                  ref.watch(roomIdProvider.notifier).setRoomId(roomId);
                  showDialog(context: context, builder: (_) => ChatRoomPage1());
                },
              ))
        ],
      ),
    );
  }
}

class DeepRedBox extends StatelessWidget {
  const DeepRedBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 70, 79),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
