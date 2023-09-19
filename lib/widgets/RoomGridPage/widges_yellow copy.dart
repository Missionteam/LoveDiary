import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/room_id_model.dart';

class YellowRoomBoxBef extends ConsumerWidget {
  const YellowRoomBoxBef({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Container(
        width: 160,
        height: 240,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 197, 66),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 25,
                left: 20,
                child: Text('趣味を語る\n部屋',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ))),
            Positioned(
                left: 30,
                bottom: 0,
                width: 100,
                child: Image.asset('images/roomgrid/YellowBoxImage.png')),
            Positioned(
                width: 160,
                height: 240,
                child: MaterialButton(
                  onPressed: () {
                    ref.watch(roomIdProvider.notifier).setRoomId('hobby');
                    GoRouter.of(context).push('/RoomGrid/Chat');
                  },
                ))
          ],
        ),
      ),
    );
  }
}
