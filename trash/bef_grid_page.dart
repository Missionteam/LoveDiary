import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/widgets/RoomGridPage/widges_2red.dart';
import 'package:thanks_diary/widgets/RoomGridPage/widges_green.dart';
import 'package:thanks_diary/widgets/RoomGridPage/widges_red%20copy.dart';

import '../lib/widgets/RoomGridPage/widges_yellow copy.dart';

class RoomGridPageBef extends ConsumerStatefulWidget {
  const RoomGridPageBef({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomGridPageState();
}

class _RoomGridPageState extends ConsumerState<RoomGridPageBef> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 800,
        // color: Color.fromARGB(255, 59, 46, 46),
        color: Color.fromARGB(255, 34, 52, 60),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 60, left: 35, right: 35, bottom: 40),
          child: Column(children: [
            RedRoomBoxBef(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [GreenRoomBoxBef(), Red2RoomBoxBef()],
                ),
                Column(
                  children: [YellowRoomBoxBef(), AddRoomBox()],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class AddRoomBox extends StatelessWidget {
  const AddRoomBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DottedBorder(
        color: Color.fromARGB(255, 40, 96, 83),
        dashPattern: [7, 10],
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(30),
        child: Container(
          width: 160,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  GoRouter.of(context).push('/RoomGrid/AddRoom');
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 40, 96, 83),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 62, 213, 152),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 212, 212, 212),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Add new item',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 53, 181, 130),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
