import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/models/activity.dart';
import 'package:thanks_diary/widgets/fundomental/post_widget.dart';

import '../../allConstants/all_constants.dart';
import '../../models/cloud_storage_model.dart';
import '../../models/post.dart';
import '../../models/room_id_model.dart';
import '../../providers/cloud_messeging_provider.dart';
import '../../providers/talkroom_provider.dart';
import '../../providers/users_provider.dart';

class ReplyPage extends ConsumerStatefulWidget {
  const ReplyPage({super.key, required this.post});

  final Post post;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReplyPageState();
}

class _ReplyPageState extends ConsumerState<ReplyPage> {
  Future<void> sendPost(String text) async {
    // まずは user という変数にログイン中のユーザーデータを格納します
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final posterId = userDoc?.get('id'); // ログイン中のユーザーのIDがとれます
    final posterName = userDoc?.get('displayName'); // Googleアカウントの名前がとれます
    final posterImageUrl = userDoc?.get('photoUrl'); // Googleア
    final roomId = ref.watch(roomIdProvider).id;
    final postDoc = widget.post.reference;
    final postRef = postDoc.collection(Consts.posts).withConverter<Post>(
          fromFirestore: ((snapshot, _) => Post.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );

    // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
    // doc の引数を空にするとランダムなIDが採番されます
    final newDocumentReference = postRef.doc();
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
      reference: newDocumentReference,
      imageLocalPath: imageLocalPath,
      imageUrl: (imageFile != null) ? imageCloudPath : '',
      id: id,
    );

    if (text != '' || imageFile != null) {
      newDocumentReference.set(newPost);
      incrementActivity(
          ref,
          (widget.post.roomId == 'init')
              ? 'chat'
              : (widget.post.roomId == 'tweet')
                  ? 'tweet'
                  : 'room');
    }
    setState(() {
      imageFile = null;
      imageCloudPath = '';
      imageLocalPath = '';
    });
  }

  Future<void> addReplyCount() async {
    final count = widget.post.replyCount;
    widget.post.reference.update({'replyCount': count + 1});
  }

  // build の外でインスタンスを作ります。
  final controller = TextEditingController();
  int count = 0;
  bool isOpenMic = false;
  final FocusNode myFocusNode = FocusNode();
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(roomIdProvider).id;
    final postsDoc = widget.post.reference;

    final user = ref.watch(CurrentAppUserDocProvider).value?.data();
    final userDocRef = ref.watch(currentAppUserDocRefProvider);
    final talkroomId = ref.watch(talkroomIdProvider).value;
    final postsRef = postsDoc.collection(Consts.posts).withConverter<Post>(
          fromFirestore: ((snapshot, _) => Post.fromFirestore(snapshot)),
          toFirestore: ((value, _) => value.toJson()),
        );
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    bool isNotify = ref.watch(isNotifyProvider).istrue;
    return Container(
      color: Color.fromARGB(255, 248, 231, 229),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 248, 231, 229),
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(31, 0, 0, 0),
              size: 24,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            primaryFocus?.unfocus();
            setState(() {
              isOpenMic = false;
            });
          },
          child: Container(
            color: Color.fromARGB(255, 248, 231, 229),
            child: Stack(
              children: [
                SizedBox(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 14,
                            ),
                            PostWidget1(
                              post: widget.post,
                              isReplyPage: true,
                            ),
                            Divider(
                              color: Color.fromARGB(255, 212, 211, 211),
                              thickness: 1,
                              height: 12,
                            ),
                            StreamBuilder<QuerySnapshot<Post>>(
                              stream: postsRef.orderBy('createdAt').snapshots(),
                              builder: (context, snapshot) {
                                final docs = snapshot.data?.docs ?? [];
                                postsDoc.update({'replyCount': docs.length});
                                return ListView.builder(
                                  itemCount: docs.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final post = docs[index].data();
                                    return PostWidget1(post: post);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
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
                          // (controller.text.isEmpty &&
                          //         !myFocusNode.hasFocus &&
                          //         imageFile == null)
                          //     ? IconButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             isOpenMic = !isOpenMic;
                          //           });
                          //           if (isOpenMic == true &&
                          //               user?.isFirstUseRecording == true) {
                          //             ScaffoldMessenger.of(context).showSnackBar(
                          //                 SnackBar(
                          //                     duration:
                          //                         Duration(milliseconds: 2500),
                          //                     content: Row(children: [
                          //                       Text('タップしながら話すとボイスメッセージを送れます。')
                          //                     ])));
                          //             userDocRef
                          //                 .update({'isFirstUseRecording': false});
                          //           }
                          //         },
                          //         icon: Padding(
                          //           padding: const EdgeInsets.only(bottom: 8),
                          //           child: (isOpenMic)
                          //               ? Icon(
                          //                   Icons.mic_none,
                          //                   color: Color.fromARGB(
                          //                       255, 255, 255, 255),
                          //                 )
                          //               : Icon(Icons.mic),
                          //         ))
                          //     :
                          IconButton(
                              onPressed: () {
                                sendPost(controller.text);

                                primaryFocus?.unfocus();
                                if (isNotify) {
                                  FirebaseCloudMessagingService()
                                      .sendPushNotification(
                                    token: token,
                                    title: '恋人がスレッドで返信しました。',
                                    body: '',
                                    type: 'reply',
                                    room: '',
                                    postId: widget.post.id,
                                  );
                                }
                                controller.clear();
                              },
                              icon: Icon(Icons.send))
                        ],
                      ),
                    ),
                    // (isOpenMic &&
                    //         controller.text.isEmpty &&
                    //         !myFocusNode.hasFocus)
                    //     ? Container(
                    //         width: double.infinity,
                    //         color: Color.fromARGB(255, 255, 236, 236),
                    //         child: Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(24.0),
                    //             child: AudioRecorder(
                    //                 isCircleButton: false,
                    //                 roomId: widget.post.roomId),
                    //           ),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ]),
                ),
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
                                        color:
                                            Color.fromARGB(255, 131, 131, 131),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
