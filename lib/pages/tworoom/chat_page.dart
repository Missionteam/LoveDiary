// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/models/activity.dart';
import 'package:thanks_diary/models/cloud_storage_model.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';
import 'package:thanks_diary/widgets/fundomental/post_widget.dart';
import 'package:thanks_diary/widgets/record/recorder.dart';
import 'package:thanks_diary/widgets/specific/Tweet/partner_postwidget.dart';
import 'package:thanks_diary/widgets/specific/recruit/official_init_postwidget.dart';
import 'package:thanks_diary/widgets/specific/review/official_post_widget.dart';

import '../../models/post.dart';
import '../../providers/cloud_messeging_provider.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/fundomental/posts_list_view.dart';
import 'chat_room_page.dart';

class ChatPage1 extends ConsumerStatefulWidget {
  ChatPage1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage1> {
  //get onUnityCreated => null;

  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;
  bool isOpenMic = false;
  final FocusNode myFocusNode = FocusNode();

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoomName = '日常会話の部屋';
    final roomId = 'init';
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    final talkroomId = ref.watch(talkroomIdProvider).value;
    final user = ref.watch(CurrentAppUserDocProvider).value?.data();
    final userDocRef = ref.watch(currentAppUserDocRefProvider);

    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
        setState(() {
          isOpenMic = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color.fromARGB(255, 248, 231, 229),
          child: Stack(alignment: Alignment.topCenter, children: [
            // Positioned(
            //     child: Container(
            //   height: 105,
            //   color: Color.fromARGB(255, 255, 173, 173),
            // )),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      color: Color.fromARGB(255, 255, 173, 173),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 45, left: 40, right: 40, bottom: 25),
                        child: Text(
                          '日常会話の部屋',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24),
                        ),
                      ),
                    ),
                    PostsListView(ref: ref, roomId: roomId),
                  ]),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        color: Color.fromARGB(255, 248, 231, 229),
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
                                    if (imageFile != null) {
                                      uploadFile(imageFile!, imageRemotePath);
                                      imageCloudPath = imageRemotePath;
                                    }
                                  });
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Icon(
                                    Icons.add,
                                  ),
                                )),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: controller,
                                focusNode: myFocusNode,
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
                            (controller.text.isEmpty &&
                                    !myFocusNode.hasFocus &&
                                    imageFile == null)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isOpenMic = !isOpenMic;
                                      });
                                      if (isOpenMic == true &&
                                          user?.isFirstUseRecording == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration: Duration(
                                                    milliseconds: 2500),
                                                content: Text(
                                                  'タップしながら話すとボイスメッセージを送れます。',
                                                  textAlign: TextAlign.center,
                                                )));
                                        userDocRef.update(
                                            {'isFirstUseRecording': false});
                                      }
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: (isOpenMic)
                                          ? Icon(
                                              Icons.mic_none,
                                              color: AppColors.main,
                                            )
                                          : Icon(Icons.mic),
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      sendPost(controller.text);

                                      primaryFocus?.unfocus();
                                      FirebaseCloudMessagingService()
                                          .sendPushNotification(
                                              token: token,
                                              title: 'パートナーからメッセージです。',
                                              body: '',
                                              type: 'init',
                                              room: '',
                                              postId: '');
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
                    (isOpenMic &&
                            controller.text.isEmpty &&
                            !myFocusNode.hasFocus &&
                            imageFile == null)
                        ? Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: AudioRecorder(isCircleButton: false),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(top: 35, left: 8),
                child: Image.asset('images/chat/chatHeader1.png'),
              ),
            ),
            Positioned(
                top: 55,
                right: 20,
                child: HelpBotton(
                  color: Color.fromARGB(71, 154, 154, 154),
                  title: '日常会話の部屋の使い方',
                  text:
                      'LINEの代わりとして使用して頂けます。\n既読機能がなく、スタンプやスレッドで返信できるため、LINEより返信負荷が少ないのが魅力です。\n\n・メッセージをタップすると、スタンプ機能や返信機能が使えます。',
                )),
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
                    : SizedBox())
          ]),
        ),
      ),
      // */
    );
  }

  Future<void> sendPost(String text) async {
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final posterId = userDoc?.get('id');
    final posterName = userDoc?.get('displayName');
    final posterImageUrl = userDoc?.get('photoUrl');
    final roomId = 'init';
    final imageLocalPath = this.imageLocalPath;
    // final String talkroomId = userDoc?.get('talkroomId') ?? '';
    // final imageRemotePath =
    //     '${talkroomId}/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';

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
      incrementActivity(ref, 'chat');
    }

    setState(() {
      imageFile = null;
    });
  }
}
