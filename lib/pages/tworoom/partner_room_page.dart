// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/pages/tworoom/chat_room_page.dart';
import 'package:thanks_diary/widgets/fundomental/post_widget.dart';
import 'package:thanks_diary/widgets/specific/Tweet/partner_postwidget.dart';

import '../../models/post.dart';
import '../../providers/cloud_messeging_provider.dart';
import '../../providers/posts_provider.dart';
import '../../providers/talkroom_provider.dart';
import '../../providers/users_provider.dart';
import '../../widgets/specific/Tweet/tweet_widget copy.dart';
import '../../widgets/specific/Tweet/tweet_widget.dart';

class MyRoomPage2 extends ConsumerStatefulWidget {
  MyRoomPage2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<MyRoomPage2> {
  //get onUnityCreated => null;

  Future<void> sendPost(String text) async {
    // まずは user という変数にログイン中のユーザーデータを格納します
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final posterId = userDoc?.get('id'); // ログイン中のユーザーのIDがとれます
    final posterName = userDoc?.get('displayName'); // Googleアカウントの名前がとれます
    final posterImageUrl = userDoc?.get('photoUrl');
    final roomId = 'tweet';

    // 先ほど作った postsReference からランダムなIDのドキュメントリファレンスを作成します
    // doc の引数を空にするとランダムなIDが採番されます
    final newDocumentReference = ref.read(postsReferenceProvider).doc();

    final newPost = Post(
      text: text,
      roomId: roomId,
      createdAt: Timestamp.now(), // 投稿日時は現在とします
      posterName: posterName,
      posterImageUrl: posterImageUrl,
      posterId: posterId,
      stamps: '',
      reference: newDocumentReference,
    );

    // 先ほど作った newDocumentReference のset関数を実行するとそのドキュメントにデータが保存されます。
    // 引数として Post インスタンスを渡します。
    // 通常は Map しか受け付けませんが、withConverter を使用したことにより Post インスタンスを受け取れるようになります。
    if (text != '') newDocumentReference.set(newPost);
  }

  // build の外でインスタンスを作ります。
  final controller = TextEditingController();

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
    final partnerName =
        ref.watch(partnerUserDocProvider).value?.get('displayName') ?? 'パートナー';
    final roomId = 'tweet';
    final isGirl =
        ref.watch(partnerUserDocProvider).value?.get('isGirl') ?? true;
    final imageName = (isGirl == true) ? 'Girl' : 'Boy';
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    bool isNotify = ref.watch(isNotifyProvider).istrue;
    final version = ref.watch(talkroomDocProvider).value?.get('version') ?? 1;

    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      onHorizontalDragEnd: (details) {
        GoRouter.of(context).push('/MyRoom1');
      },

      child: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 255, 228, 204),
          child: Stack(alignment: Alignment.topCenter, children: [
            // Positioned(
            //   child: Image.asset('images/chat/chatHeader.png'),
            // ),
            // Positioned(
            //     top: 80,
            //     child: Text(
            //       'ひとりごとの部屋',
            //       style: GoogleFonts.nunito(
            //           fontSize: 24, fontWeight: FontWeight.w500),
            //     )),
            Positioned(
              top: 70,
              left: 30,
              child: (version == 1)
                  ? InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.published_with_changes),
                      ),
                      onTap: () {
                        GoRouter.of(context).push('/MyRoom1');
                      },
                    )
                  : SizedBox(),
            ),

            Positioned(
              bottom: 60,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child:
                    Image.asset('images/whatNowStamp/Work${imageName}Icon.png'),
              ),
            ),
            // Positioned(
            //   bottom: 60,
            //   left: 20,
            //   child: Row(
            //     children: [
            //       Text('パートナーに通知する'),
            //       Checkbox(
            //           activeColor: Colors.black,
            //           value: isNotify,
            //           onChanged: (value) {
            //             ref.watch(isNotifyProvider.notifier).setisNotify(value);
            //           }),
            //     ],
            //   ),
            // ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Text(
                  '${partnerName}の部屋',
                  style: GoogleFonts.nunito(
                      fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Flexible(
                  child: ref.watch(postsPartnerProvider(roomId)).when(
                data: (data) {
                  /// 値が取得できた場合に呼ばれる。
                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.only(top: 10, left: 10),
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      // if (index < 2) {
                      //   final initpost = partnerInitMessage;
                      //   return PostWidget2(post: initpost);
                      // } else {
                      final post = data.docs[index].data();
                      return PostWidget2(post: post);
                      // }
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextFormField(
              //           keyboardType: TextInputType.multiline,
              //           maxLines: null,
              //           controller: controller,
              //           decoration: InputDecoration(
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide: const BorderSide(
              //                 color: Color.fromARGB(47, 165, 165, 165),
              //                 width: 1,
              //               ),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide: const BorderSide(
              //                 color: Color.fromARGB(110, 206, 206, 206),
              //                 width: 1,
              //               ),
              //             ),
              //           ),
              //           onFieldSubmitted: (text) {
              //             sendPost(text);
              //             controller.clear();
              //           },
              //         ),
              //       ),
              //       IconButton(
              //           onPressed: () {
              //             sendPost(controller.text);
              //             primaryFocus?.unfocus();
              //             if (isNotify == true) {
              //               FirebaseCloudMessagingService()
              //                   .sendPushNotification(token, '恋人が呟いています。', '');
              //             }
              //             controller.clear();
              //           },
              //           icon: Icon(Icons.send))
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 30,
              )
            ]),

            Positioned(
                top: 77,
                right: 30,
                child: HelpBotton(
                  color: Color.fromARGB(71, 154, 154, 154),
                  title: 'つぶやきルームの使い方',
                  text: '吹き出しをタップすると、スタンプや返信ができます。',
                )),
          ]),
        ),
      ),
      // */
    );
  }

  // final partnerInitMessage = Post(
  //   text: 'ここは、思ったことを自由につぶやける部屋です。ふと思った何気ないことを言葉にしてみることで、なにか面白いことが起きるかもしれません。',
  //   roomId: 'tweet',
  //   createdAt: Timestamp.fromDate(DateTime.parse('2023-01-21 12:00:00')),
  //   posterName: '運営より',
  //   posterImageUrl: 'Boy',
  //   posterId: '',
  //   reference: FirebaseFirestore.instance.collection('talkrooms').doc('8BrMKgNHbCWEcdoUTvyxOivRJJy1').collection('posts').doc('46v3MGYEADrYrDINNtV7'),
  //   stamps: '😌',
  // );
}
