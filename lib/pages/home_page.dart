import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/fundomental/thanks_list.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../providers/cloud_messeging_provider.dart';
import '../providers/users_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> getTokenfunction() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      final fcmToken = await messaging.getToken();
      print('これがfcmTokenです:${fcmToken}');
      ref.watch(currentAppUserDocRefProvider).update({'fcmToken': fcmToken});
    }

    return Scaffold(
        backgroundColor: AppColors.main,
        body: Container(
          color: AppColors.main,
          height: double.infinity,
          child: HomePageContent(),
        ));
  }
}

class HomePageContent extends ConsumerStatefulWidget {
  HomePageContent({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageContentState();
}

class HomePageContentState extends ConsumerState<HomePageContent> {
  final formKey = GlobalKey<FormState>();
  bool isMine = false;

  Future<void> getTokenfunction() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    print('これがfcmTokenです:${fcmToken}');
    ref.watch(currentAppUserDocRefProvider).update({'fcmToken': fcmToken});
  }

  @override
  void initState() {
    super.initState();

    /// FCMのパーミッション設定
    FirebaseCloudMessagingService().setting();

    /// FCMのトークン表示(テスト用)
    getTokenfunction();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserDoc = ref.watch(CurrentAppUserDocProvider).value;
    final partnerUserDoc = ref.watch(partnerUserDocProvider).value;
    final String currentUserName = currentUserDoc?.get('displayName') ?? '未登録';
    final String partnerUserName = partnerUserDoc?.get('displayName') ?? '未登録';
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(height: 46),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              NotoText(
                text: "8月",
                fontSize: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.expand_more),
              )
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isMine = false;
                });
              },
              child: NotoText(
                text: partnerUserName,
                fontWeight: FontWeight.w600,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: !isMine
                      ? Color.fromARGB(184, 195, 195, 195)
                      : AppColors.noColor,
                  shape: const StadiumBorder(),
                  elevation: 0,
                  foregroundColor: Colors.black),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isMine = true;
                });
              },
              child: NotoText(
                text: currentUserName,
                fontWeight: FontWeight.w600,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: isMine
                      ? Color.fromARGB(184, 195, 195, 195)
                      : AppColors.noColor,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  foregroundColor: Colors.black),
            )
          ],
        ),
        ThanksList(
          isMine: isMine,
        ),
        ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push('/Input');
          },
          child: Text("今日のありがとうを書く。"),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(
            280,
            40,
          )),
        ),
        SizedBox(height: 40),
      ]),
      Positioned(
          right: sWidth(context) * 0.1,
          top: sHieght(context) * 0.05,
          width: 26,
          child: InkWell(
              onTap: () {
                GoRouter.of(context).push('/Home1/Setting');
              },
              child: Image.asset('images/home/SettingIcon.png'))),
    ]);
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });