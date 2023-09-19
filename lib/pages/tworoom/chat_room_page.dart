// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/models/activity.dart';
import 'package:thanks_diary/models/room_id_model.dart';
import 'package:thanks_diary/providers/cloud_messeging_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/widgets/fundomental/post_widget.dart';
import 'package:thanks_diary/widgets/specific/RoomGridPage/change_room_dialog%20.dart';

import '../../models/cloud_storage_model.dart';
import '../../models/post.dart';
import '../../providers/posts_provider.dart';
import '../../providers/rooms_provider.dart';
import '../../providers/users_provider.dart';

class ChatRoomPage1 extends ConsumerStatefulWidget {
  ChatRoomPage1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatRoomPage1> {
  //get onUnityCreated => null;
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;
  Future<void> sendPost(String text) async {
    // まずは user という変数にログイン中のユーザーデータを格納します
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final posterId = userDoc?.get('id'); // ログイン中のユーザーのIDがとれます
    final posterName = userDoc?.get('displayName'); // Googleアカウントの名前がとれます
    final posterImageUrl = userDoc?.get('photoUrl'); //Googleアカウントのアイコンデータがとれます
    final roomId = ref.watch(roomIdProvider).id;
    final imageLocalPath = this.imageLocalPath;
    // final String talkroomId = userDoc?.get('talkroomId') ?? '';
    // final imageRemotePath =
    //     '${talkroomId}/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';
    // // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
    // // doc の引数を空にするとランダムなIDが採番されます
    final newDocumentReference = ref.watch(postsReferenceProvider).doc();
    final id = newDocumentReference.id;
    if (imageFile != null) {
      uploadFile(imageFile!, imageCloudPath);
    }
    final newPost = Post(
        text: text,
        roomId: roomId,
        createdAt: Timestamp.now(), // 投稿日時は現在とします
        posterName: posterName,
        posterImageUrl: posterImageUrl,
        posterId: posterId,
        stamps: '',
        imageLocalPath: imageLocalPath,
        imageUrl: (imageFile != null) ? imageCloudPath : '',
        reference: newDocumentReference,
        id: id);

    // 先ほど作った newDocumentReference のset関数を実行するとそのドキュメントにデータが保存されます。
    // 引数として Post インスタンスを渡します。
    // 通常は Map しか受け付けませんが、withConverter を使用したことにより Post インスタンスを受け取れるようになります。
    if (text != '' || imageFile != null) {
      newDocumentReference.set(newPost);
      incrementActivity(ref, 'room');
    }
    ;
    setState(() {
      imageFile = null;
      imageCloudPath = '';
    });
  }

  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider).value;
    final currentRoomName = currentRoom?.data()?.roomname ?? '';
    final roomId = ref.watch(roomIdProvider).id;
    final currentRoomDescription = currentRoom?.data()?.description ?? '';
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    final Size size = MediaQuery.of(context).size;
    final talkroomId = ref.watch(talkroomIdProvider).value;
    bool isNotify = ref.watch(isNotifyProvider).istrue;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            color: Color.fromARGB(255, 248, 231, 229),
            child: Stack(alignment: Alignment.topCenter, children: [
              Column(children: [
                Container(
                  height: (currentRoomDescription != '') ? 140 : 100,
                  color: Color.fromARGB(255, 241, 141, 141),
                ),

                Flexible(
                  fit: FlexFit.loose,
                  child: ref.watch(postsProvider(roomId)).when(
                    data: (data) {
                      /// 値が取得できた場合に呼ばれる。
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.only(top: 10, left: 10),
                        itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          final post = data.docs[index].data();
                          return PostWidget1(post: post);
                        },
                      );
                    },
                    error: (_, __) {
                      /// 読み込み中にErrorが発生した場合に呼ばれる。
                      return const Center(
                        child: Text('不具合が発生しました。'),
                      );
                    },
                    loading: () {
                      /// 読み込み中の場合に呼ばれる。
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 90,
                )
                // Expanded(flex: 1, child: SizedBox()),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('パートナーに通知する'),
                        Checkbox(
                            activeColor: Colors.black,
                            value: isNotify,
                            onChanged: (value) {
                              ref
                                  .watch(isNotifyProvider.notifier)
                                  .setisNotify(value);
                            }),
                      ],
                    ),
                    Container(
                      color: Color.fromARGB(255, 248, 231, 229),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  final image = await select_icon(context);
                                  final imageRemotePath =
                                      '${talkroomId}/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';
                                  setState(() {
                                    this.imageFile = image;
                                  });
                                  if (imageFile != null) {
                                    uploadFile(imageFile!, imageRemotePath);
                                    setState(() {
                                      imageCloudPath = imageRemotePath;
                                    });
                                  }
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Icon(Icons.add),
                                )),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: controller,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(47, 165, 165, 165),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(110, 206, 206, 206),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (text) {
                                  sendPost(text);
                                  controller.clear();
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  sendPost(controller.text);

                                  primaryFocus?.unfocus();
                                  if (isNotify)
                                    FirebaseCloudMessagingService()
                                        .sendPushNotification(
                                      token: token,
                                      title:
                                          'パートナーが${currentRoomName}部屋で話しています。',
                                      body: '',
                                      type: 'room',
                                      room: roomId,
                                    );
                                  controller.clear();
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Icon(Icons.send),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/chat/chatHeader1.png'),
                ),
              ),
              Positioned(
                  top: 32,
                  right: 30,
                  width: 30,
                  child: InkWell(
                      onTap: () {
                        final room = currentRoom!.data()!;
                        showDialog(
                            context: context,
                            builder: (_) => ChangeRoomDialog(
                                  room: room,
                                ));
                      },
                      child: Image.asset('images/home/settings1.png'))),
              Positioned(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 40, right: 40, bottom: 15),
                      child: Text(
                        '${currentRoomName}部屋',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 228, 228, 228),
                            fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 50, right: 50, bottom: 20),
                        child: Text(
                          currentRoomDescription,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 228, 228, 228),
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 8,
                  top: 34,
                  child: IconButton(
                      // onPressed: () => GoRouter.of(context).pop(),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.white,
                        size: 20,
                      ))),
              Positioned(
                  bottom: 60,
                  left: 50,
                  child: (imageFile != null)
                      ? Stack(
                          children: [
                            SizedBox(
                                width: 80,
                                height: 100,
                                child: Image.file(imageFile!)),
                            Positioned(
                                left: 5,
                                child: InkWell(
                                  onTap: (() {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  }),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 131, 131, 131),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      : SizedBox()),
            ]),
          ),
        ),
        // */
      ),
    );
  }
}

class HelpBotton extends StatelessWidget {
  HelpBotton({
    Key? key,
    required this.text,
    required this.title,
    this.color = const Color.fromARGB(162, 186, 186, 186),
  }) : super(key: key);
  String text;
  String title;
  Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Container(
                    padding: const EdgeInsets.only(bottom: 0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 241, 141, 141),
                        ),
                      ),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.nunito(),
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 30),
                    child: Text(
                      text,
                      style: GoogleFonts.notoSans(),
                    ),
                  ),
                ));
      },
      child: Icon(
        Icons.help_rounded,
        color: color,
      ),
    );
  }
}

class RoomDescriptionPage extends ConsumerWidget {
  const RoomDescriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: Text(
          'こちらのページでは、二人のつぶやきを見ることができます。\nまた、画面下の４つ目のアイコンからもつぶやくことができますが、そちらのページは、自分のつぶやきのみが表示されます。'),
    );
  }
}
