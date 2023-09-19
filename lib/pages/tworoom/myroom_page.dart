// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/pages/tworoom/chat_room_page.dart';

import '../../models/activity.dart';
import '../../models/cloud_storage_model.dart';
import '../../models/post.dart';
import '../../providers/cloud_messeging_provider.dart';
import '../../providers/posts_provider.dart';
import '../../providers/talkroom_provider.dart';
import '../../providers/users_provider.dart';
import '../../widgets/record/recorder.dart';
import '../../widgets/specific/Tweet/tweet_widget.dart';
import '../../widgets/specific/record/voice_post_widget.dart';

class MyRoomPage1 extends ConsumerStatefulWidget {
  MyRoomPage1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<MyRoomPage1> {
  //get onUnityCreated => null;

  // build の外でインスタンスを作ります。
  final controller = TextEditingController();
  bool isOpenMic = false;
  final FocusNode myFocusNode = FocusNode();
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  /// この dispose 関数はこのWidgetが使われなくなったときに実行されます。
  @override
  void dispose() {
    // TextEditingController は使われなくなったら必ず dispose する必要があります。
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoomName = 'ひとりごと';
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final userName = userDoc?.get('displayName');
    final roomId = 'tweet';
    final isGirl = ref.watch(isGirlProvider);
    final talkroomId = ref.watch(talkroomIdProvider).value;
    final user = ref.watch(CurrentAppUserDocProvider).value?.data();
    final userDocRef = ref.watch(currentAppUserDocRefProvider);

    final imageName = (isGirl == true) ? 'Girl' : 'Boy';
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    bool isNotify = ref.watch(isNotifyProvider).istrue;
    final version = ref.watch(talkroomDocProvider).value?.get('version') ?? 1;

    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
        setState(() {
          isOpenMic = false;
        });
      },
      onHorizontalDragEnd: (details) {
        GoRouter.of(context).push('/MyRoom2');
      },
      child: Scaffold(
        body: Container(
          color: AppColors.main,
          child: Stack(alignment: Alignment.topCenter, children: [
            Positioned(
              top: 60,
              left: 30,
              child: (version == 1)
                  ? InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.published_with_changes),
                      ),
                      onTap: () {
                        GoRouter.of(context).push('/MyRoom2');
                      },
                    )
                  : SizedBox(),
            ),
            Positioned(
              bottom: 80,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child:
                    Image.asset('images/whatNowStamp/Work${imageName}Icon.png'),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 30),
                child: Text(
                  '${userName}の部屋',
                  style: GoogleFonts.nunito(
                      fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                  child: ref.watch(postsReverseProvider(roomId)).when(
                data: (data) {
                  /// 値が取得できた場合に呼ばれる。
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 10, left: 10),
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      final post = data.docs[index].data();
                      return TweetWidget(post: post);
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
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      icon: Icon(
                        Icons.image_outlined,
                        color: Color.fromARGB(163, 158, 158, 158),
                      )),
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
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.white,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(milliseconds: 2500),
                                      content: Row(children: [
                                        Text('タップしながら話すとボイスメッセージを送れます。')
                                      ])));
                              userDocRef.update({'isFirstUseRecording': false});
                            }
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: (isOpenMic)
                                ? Icon(
                                    Icons.mic_none,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  )
                                : Icon(Icons.mic),
                          ))
                      : IconButton(
                          onPressed: () {
                            sendPost(controller.text);
                            primaryFocus?.unfocus();
                            if (isNotify == true) {
                              FirebaseCloudMessagingService()
                                  .sendPushNotification(
                                      token: token,
                                      title: '恋人が呟いています。',
                                      body: '',
                                      type: 'tweet',
                                      room: '',
                                      postId: '');
                            }
                            controller.clear();
                          },
                          icon: Icon(Icons.send))
                ],
              ),
              (isOpenMic && controller.text.isEmpty && !myFocusNode.hasFocus)
                  ? Container(
                      width: double.infinity,
                      color: Color.fromARGB(255, 255, 236, 236),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: AudioRecorder(
                              isCircleButton: false, roomId: 'tweet'),
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
            Positioned(
                top: 67,
                right: 20,
                child: HelpBotton(
                  color: Color.fromARGB(71, 154, 154, 154),
                  title: 'この部屋の使い方',
                  text:
                      'ここは思ったことを自由につぶやける部屋です。この部屋には、自分のつぶやきのみが表示されます。\n画面上の切り替えボタンでパートナーのつぶやきを見れます。',
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
    final roomId = 'tweet';
    final imageLocalPath = this.imageLocalPath;
    // final String talkroomId = userDoc?.get('talkroomId') ?? '';
    // final imageRemotePath =
    //     '${talkroomId}/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';

    final newDocumentReference = ref.watch(postsReferenceProvider).doc();
    final id = newDocumentReference.id;
    // if (imageFile != null) {
    //   uploadFile(imageFile!, imageCloudPath);
    // }
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
