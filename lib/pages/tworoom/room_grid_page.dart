import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/rooms_provider.dart';
import 'package:thanks_diary/widgets/specific/RoomGridPage/add_room_dialog.dart';

import '../../widgets/specific/RoomGridPage/red.dart';
import '../../widgets/specific/RoomGridPage/roombox.dart';

class RoomGridPage extends ConsumerStatefulWidget {
  const RoomGridPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomGridPageState();
}

class _RoomGridPageState extends ConsumerState<RoomGridPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          GoRouter.of(context).go('/Chat1');
        } else {
          GoRouter.of(context).go('/MyRoom1');
        }
      },
      child: Container(
        color: Color.fromARGB(255, 34, 52, 60),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 45, right: 45, bottom: 40),
          child: ref.watch(roomsProvider).when(
            data: (data) {
              final firstroom = data.docs[2];
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 30,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: RedRoomBox(
                    roomId: firstroom.data().roomId,
                    RoomName: firstroom.data().roomname,
                  )),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      ((context, index) {
                        final room = (index != data.docs.length - 3)
                            ? data.docs[index + 3].data()
                            : data.docs[index].data();
                        return (index != data.docs.length - 3)
                            ? RoomBox(
                                RoomName: room.roomname,
                                roomId: room.roomId,
                                imgPath: (index % 3 == 0)
                                    ? 'GreenBoxImage.png'
                                    : (index % 3 == 1)
                                        ? 'YellowBoxImage.png'
                                        : (index % 3 == 2)
                                            ? 'Red2BoxImage.png'
                                            : 'YellowBoxImage.png',
                                color: (index % 3 == 0)
                                    ? Color.fromARGB(255, 62, 213, 152)
                                    : (index % 3 == 1)
                                        ? Color.fromARGB(255, 255, 210, 30)
                                        : (index % 3 == 2)
                                            ? Color.fromARGB(255, 255, 86, 94)
                                            : Color.fromARGB(255, 255, 210, 30),
                              )
                            : AddRoomBox();
                      }),
                      childCount: data.docs.length - 2,
                    ),
                  ),
                ],
              );
            },
            error: (_, __) {
              return const Center(
                child: Text('不具合が発生しました。'),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
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
      padding: const EdgeInsets.only(top: 20),
      child: DottedBorder(
        color: Color.fromARGB(255, 40, 96, 83),
        dashPattern: [7, 10],
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  // GoRouter.of(context).push('/RoomGrid1/AddRoom');
                  showDialog(context: context, builder: (_) => AddRoomDialog());
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
                'Add new room',
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
