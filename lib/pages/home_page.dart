import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/pages/know_input_page.dart';
import 'package:thanks_diary/pages/love_input_page.dart';
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
    final partnerName =
        ref.watch(CurrentAppUserDocProvider).value?.data()?.partnerName ?? "恋人";
    return Scaffold(
      backgroundColor: AppColors.main,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        elevation: 3,
        centerTitle: true,
        actions: [
          IconButton(
              color: Color.fromARGB(0, 0, 0, 0),
              onPressed: () {
                context.go('/Home1/Setting');
              },
              icon: Icon(
                Icons.settings,
                color: AppColors.spaceLight,
              ))
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            MyButton(
                text: "${partnerName}の好きなところを書く。",
                page: LoveInputPage(),
                path: "/LoveView"),
            MyButton(
                text: "もやもやを整理する", page: KnowInputPage(), path: "/KnowView"),
          ]),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.page,
    required this.path,
  });

  final String text;
  final Widget page;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
          onPressed: () {
            showDialog(context: context, builder: (_) => page);
            context.go(path);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonGreen,
            minimumSize: Size(sWidth(context) * 0.8, 50),
          ),
          child: NotoText(
            text: text,
            color: Colors.white,
          )),
    );
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });