import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/room_id_model.dart';

class GreenRoomBoxBef extends ConsumerWidget {
  const GreenRoomBoxBef({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 62, 213, 152),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 25,
                left: 20,
                child: Text('行きたいところ\nの部屋',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ))),
            Positioned(
                left: 30,
                top: 90,
                width: 100,
                child: Image.asset('images/roomgrid/GreenBoxImage.png')),
            Positioned(
                width: 160,
                height: 200,
                child: MaterialButton(
                  onPressed: () {
                    ref.watch(roomIdProvider.notifier).setRoomId('date');
                    GoRouter.of(context).push('/RoomGrid/Chat');
                  },
                ))
          ],
        ),
      ),
    );
  }
}
