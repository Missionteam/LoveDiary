import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/allConstants/color_constants.dart';
import 'package:thanks_diary/models/version_model.dart';
import 'package:thanks_diary/pages/tworoom/chat_room_page.dart';

import '../lib/models/gage_model.dart';
import '../lib/providers/cloud_messeging_provider.dart';
import '../lib/providers/users_provider.dart';
import '../lib/widgets/specific/whatNow/what_now_dialog.dart';

class HomePage1 extends ConsumerStatefulWidget {
  const HomePage1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePage1State();
}

class HomePage1State extends ConsumerState<HomePage1> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  // late UnityWidgetController unityWidgetController;
  bool isWoman = true;
  // @override
  // void dispose() {
  //   unityWidgetController.dispose();
  //   super.dispose();
  // }

  Future<void> getTokenfunction() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
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
    final gage = ref.watch(GageProvider).gage;
    final version = ref.watch(versionsProvider);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: AppColors.main,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                child: SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // UnityWidget(
                      //   onUnityCreated: onUnityCreated,
                      //   fullscreen: false,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 50, left: 30, right: 30, top: 110),
                        child: MaterialButton(
                          onPressed: () {
                            GoRouter.of(context).push('/Home1/Home11');
                          },
                          child: Image.asset(
                            'images/home/homeimg.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                      // ref.watch(whatNowProvider),
                      // GestureDetector(
                      //   onTap: () => showWhatNow(context),
                      //   onHorizontalDragEnd: (details) {
                      //     if (details.primaryVelocity! < 0) {
                      //       setActive('WaitGirl');
                      //     } else {
                      //       setActive('SleepBoy');
                      //     }
                      //   },
                      // )
                      // MaterialButton(
                      //   height: 200,
                      //   minWidth: 200,
                      //   onPressed: () => showWhatNow(context),
                      // )
                    ],
                  ),
                ),
              ),

              SizedBox(
                child: TextButton(
                    onPressed: () async {
                      GoRouter.of(context).push('/Home1/Chat1');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      fixedSize: Size(150, 40),
                    ),
                    child: Text(
                      'トークする',
                      style: GoogleFonts.nunito(
                          // color: Color.fromARGB(255, 243, 243, 243)),
                          color: Colors.white),
                    )),
              )
              // MaterialButton(
              //   // elevation: 8.0,
              //   child: Container(
              //     height: 50,
              //     width: 250,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage('images/SorryForLate.png'),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: (_) {
              //           return SorryGirdDialog();
              //           // return EngageDialog();
              //         });
              //   },
              //   // onPressed: () {}
              // ),
            ],
          ),
          // Positioned(
          //     right: 50,
          //     top: 30,
          //     child: CustomPaint(
          //       size: Size(40, 40),
          //       painter: DrawTriangle(ref),
          //     )),
          // Positioned(
          //     left: 120,
          //     top: 80,
          //     width: 200,
          //     child: Image.asset('images/whatNowStamp/WaitReply.png')),
          Positioned(
              right: 40,
              top: 70,
              child: InkWell(
                  onTap: () {
                    GoRouter.of(context).push('/Home1/Setting');
                  },
                  child: Image.asset('images/home/settings1.png'))),
          // Positioned(
          //     width: 70,
          //     height: 70,
          //     left: 50,
          //     top: 220,
          //     child: ref.watch(EngageStampProvider)
          //     // ),
          //     ),
          Positioned(
              left: 0,
              top: 0,
              width: 150,
              child: MaterialButton(
                child: Container(
                  width: 80,
                  height: 150,
                ),
                onPressed: () {
                  ref.watch(versionsProvider.notifier).setVersions();
                },
                hoverColor: (version == 0)
                    ? Colors.red
                    : (version == 1)
                        ? Colors.blue
                        : Colors.green,
              )),
          Positioned(
              top: 80,
              left: 30,
              child: HelpBotton(
                color: Color.fromARGB(201, 246, 246, 246),
                title: 'ヒント',
                text: '家をタップしてみましょう。',
              ))
        ]),
      ),
    );
  }

  Future<dynamic> showWhatNow(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          const workTimepath = 'whatNowStamp/WorkTime/';
          const whatnowpath = 'whatNowStamp/';
          return WhatNowDialog();
          // return EngageDialog();
        });
  }

  void setActive(String stampname) {
    final currentUserDoc = ref.watch(CurrentAppUserDocProvider).value;
    currentUserDoc?.reference.update({'whatNow': '${stampname}.jpg'});
  }
  // void setActive(String object) {
  //   ///Activeは最後に実行。
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWaitGirl',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWalkGirl',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWorkGirl',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishSleepGirl',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWaitBoy',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWalkBoy',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishWorkBoy',
  //     '',
  //   );
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'VanishSleepBoy',
  //     '',
  //   );

  //   ///Active
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'Active${object}',
  //     object,
  //   );
  // }

  // void setVanish(String object) {
  //   unityWidgetController.postMessage(
  //     'ActiveChanger',
  //     'Vanish${object}',
  //     object,
  //   );
  // }

  // void onUnitySceneLoaded(SceneLoaded scene) {
  //   print('Received scene loaded from unity: ${scene.name}');
  //   print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
  // }

  // void onUnityCreated(controller) {
  //   controller.resume();
  //   unityWidgetController = controller;
  // }
}
