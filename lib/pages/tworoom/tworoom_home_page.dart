import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/models/recruit.dart';
import 'package:thanks_diary/models/show_controller.dart';
import 'package:thanks_diary/models/whatNow.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/widgets/specific/recruit/partner_recruit_dialog.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/red_button.dart';

import '../../allConstants/color_constants.dart';
import '../../models/activity.dart';
import '../../models/gage_model.dart';
import '../../models/user.dart';
import '../../providers/cloud_messeging_provider.dart';
import '../../providers/users_provider.dart';
import '../../widgets/fundomental/userIconWidget.dart';
import '../../widgets/specific/recruit/recruit_dialog.dart';
import '../../widgets/specific/whatNow/what_now_dialog.dart';
import '../../widgets/util/text.dart';
import 'chat_room_page.dart';

class HomePage11 extends ConsumerStatefulWidget {
  const HomePage11({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage11>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  // late UnityWidgetController unityWidgetController;

  Future<void> getTokenfunction() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    print('これがfcmTokenです:${fcmToken}');
    ref.watch(currentAppUserDocRefProvider).update({'fcmToken': fcmToken});
  }

  Future<void> sendPost(String text) async {
    final userRef = ref.watch(currentAppUserDocRefProvider);
    userRef.update({'whatNowMessage': text, 'updateAt': Timestamp.now()});
    incrementActivity(ref, 'home');
  }

  // build の外でインスタンスを作ります。
  final controller = TextEditingController();
  late AnimationController menuAnimation;

  @override
  void dispose() {
    controller.dispose();
    menuAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// FCMのパーミッション設定
    FirebaseCloudMessagingService().setting();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    /// FCMのトークン表示(テスト用)
    getTokenfunction();
  }

  @override
  Widget build(BuildContext context) {
    final gage = ref.watch(GageProvider).gage;
    final isUserWhatNow = ref.watch(isUserWhatNowProvider).isUser;
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final user = ref.watch(CurrentAppUserDocProvider).value?.data();
    final bool? isWoman = userDoc?.data()!.isGirl;
    final bool? isShowButton = userDoc?.data()!.isShowRecruitButton;

    final WhatNowName = ref.watch(whatNowNameProvider(isUserWhatNow));
    final displayName = ref.watch(whatNowDisplayNameProvider(isUserWhatNow));
    final whatNowMessage = ref.watch(whatNowMessageProvider(isUserWhatNow));
    final updateAt = ref.watch(whatNowUpdateAtProvider(isUserWhatNow));
    final showText = ref.watch(showTextProvider).isShow;
    final showRecordDialog = ref.watch(showRecordDialogProvider).isShow;
    final partnerDoc = ref.watch(partnerUserDocProvider).value?.data();
    final partnerUid = partnerDoc?.id;
    final uid = ref.watch(uidProvider) ?? '';
    final myRecruit = ref.watch(myRecruitProvider('phone')).value?.data();
    final List myRecruitShowList = myRecruit?.showList ?? [];
    ;
    final bool isExistMyRecruit = myRecruit?.isJoin ?? false;
    final partnerRecruit =
        ref.watch(partnerRecruitProvider('phone')).value?.data();
    final bool isExistPartnerRecruit = (partnerRecruit?.isJoin ?? false);
    final List partnerRecruitShowList = partnerRecruit?.showList ?? [];
    ;
    final bool isOpenPartnerRecruit = (partnerRecruitShowList.contains(uid));
    final bool isShowPartnerRecruit =
        (isOpenPartnerRecruit && isExistPartnerRecruit);

    final bool isShowRecruitButton = (!isExistMyRecruit &&
        !isShowPartnerRecruit &&
        (isWoman == false || isShowButton == true || isExistPartnerRecruit));

    final bool isShowRecruitIcon =
        (!isExistMyRecruit && !isShowPartnerRecruit && isWoman == true);

    final bool isShowRecruitList = (isExistMyRecruit || isShowPartnerRecruit);

    final Size size = MediaQuery.of(context).size;
    bool isVisible = ref.watch(isVisibleProvider).istrue;

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: (() {
          menuAnimation.reverse();
        }),
        child: Container(
          child: Container(
            width: double.infinity,
            // color: AppColors.main,
            color: Color.fromARGB(255, 255, 239, 225),
            child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 80,
                      ),

                      ///WhatNowスタンプ
                      whatNowStamp(
                          WhatNowName, displayName, whatNowMessage, context),
                      SizedBox(
                          height:
                              (MediaQuery.of(context).size.height - 600) * 0.3),
                      (isShowRecruitButton)
                          ? RecruitButton(
                              isExistPartnerRecruit, uid, partnerUid)
                          : SizedBox(),
                      (user?.isGetAnnouncement0505 == false)
                          ? MaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AnnounceDialog());
                              },
                              child: RedButton(
                                text: '運営からのお知らせ',
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),

                  ///VoiceList
                  // Positioned(
                  //     top: sHieght(context) * 0.28,
                  //     left: 30,
                  //     width: 100,
                  //     child: VoiceListView(
                  //       ref: ref,
                  //     )),

                  ///TextField
                  Positioned(
                    bottom: 0,
                    width: size.width,
                    child: (isUserWhatNow) ? textFormField() : SizedBox(),
                  ),

                  ///RecruitList
                  (isExistMyRecruit || isShowPartnerRecruit)
                      ? Positioned(
                          left: size.width * 0.09,
                          top: size.height * 0.16,
                          width: 300,
                          height: 60,
                          child: RecruitList(uid, userDoc),
                        )
                      : SizedBox(),

                  ///通話したいアイコン
                  (isShowRecruitIcon)
                      ? Positioned(
                          right: size.width * 0.07,
                          top: size.height * 0.17,
                          child: InkWell(
                            onTap: () {
                              addRecruit(ref, 'phone');
                              incrementActivity(ref, 'want to call');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 12),
                                Icon(Icons.call),
                                SizedBox(height: 12),
                                MainText(text: '通話したい')
                              ],
                            ),
                          ))
                      : SizedBox(),

                  ///ヒントボタン
                  Positioned(
                      top: size.height * 0.11,
                      left: size.width * 0.08,
                      child: HelpBotton(
                        color: Color.fromARGB(162, 186, 186, 186),
                        title: 'ヒント',
                        text: '「今何してる」をパートナーに伝えられます。\n画像をタップ、スワイプしてみてください。',
                      )),

                  ///設定ボタン
                  Positioned(
                      right: size.width * 0.1,
                      top: size.height * 0.1,
                      width: 40,
                      child: InkWell(
                          onTap: () {
                            GoRouter.of(context).push('/Home1/Setting');
                          },
                          child: Image.asset('images/home/SettingIcon.png'))),

                  ///なにしてるテキスト
                  MessageTimeDetail(showText, whatNowMessage, updateAt),

                  ///録音中画面
                  RecordingDialog(showRecordDialog, whatNowMessage, updateAt),

                  ///録音ボタン
                  // Positioned(
                  //     bottom: sHieght(context) * 0.15,
                  //     child: AudioRecorder(
                  //       isCircleButton: false,
                  //     )),
                ]),
          ),
        ),
      ),
    );
  }

  Align flowMenuItemButton(bool isExistPartnerRecruit, String uid,
      String? partnerUid, Recruit? myRecruit) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Flow(
        delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
        children: menuItems
            .map<Widget>((String text) => flowMenuItem(
                text, isExistPartnerRecruit, uid, partnerUid, myRecruit))
            .toList(),
      ),
    );
  }

  Widget RecruitButton(
      bool isExistPartnerRecruit, String uid, String? partnerUid) {
    return TextButton(
        onPressed: () async {
          addRecruit(ref, 'phone');
          if (isExistPartnerRecruit)
            updatePartnerRecruit(ref, 'phone', {
              'showList': [uid, partnerUid]
            });
          updatePartnerData(ref, field: 'isShowRecruit', value: true);
          incrementActivity(ref, 'want to call');
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          fixedSize: Size(150, 40),
        ),
        child: Text(
          '通話したい気分',
          style: GoogleFonts.nunito(
              // color: Color.fromARGB(255, 243, 243, 243)),
              color: Colors.white),
        ));
  }

  Row RecruitList(String uid, DocumentSnapshot<AppUser>? userDoc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text('時間あったら\n通話したいかも:',
              style:
                  GoogleFonts.yuseiMagic(color: Color.fromARGB(255, 0, 0, 0))),
        ),
        SizedBox(
          width: 5,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ref.watch(recruitsProvider('phone')).when(
            data: (data) {
              /// 値が取得できた場合に呼ばれる。
              return ListView.builder(
                shrinkWrap: true,
                reverse: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 10, top: 20),
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final recruit = data.docs[index].data();
                  return InkWell(
                    onTap: () async {
                      final id = recruit.id;
                      if (id == uid) {
                        showmyRecruitDialog(context, recruit);
                      }
                      if (id != uid) showPartnerRecruitDialog(context, recruit);
                    },
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: UserIcon(
                          uid: recruit.id,
                          radius: 40,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (_, __) {
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
        (userDoc?.data()!.isFirstUseRecruit != false)
            ? MagicText(
                text: '←タップ',
                fontSize: 14,
              )
            : SizedBox()
      ],
    );
  }

  Widget TalkButton(bool isExistPartnerRecruit, String uid, String? partnerUid,
      bool isRecording) {
    return GestureDetector(
        onTapDown: (detail) {
          ref.watch(showRecordDialogProvider.notifier).show();
        },
        onTapUp: (details) {
          ref.watch(showRecordDialogProvider.notifier).hide();
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.mic,
                  color: Color.fromARGB(255, 37, 151, 245),
                ),
                Text(
                  isRecording ? '         録音中' : 'タップしながら話す',
                  style: GoogleFonts.nunito(
                      // color: Color.fromARGB(255, 243, 243, 243)),
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }

  Align RecordingDialog(bool showText, String whatNowMessage, String updateAt) {
    return Align(
        alignment: Alignment.center,
        child: (showText == true)
            ? Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                color: Color.fromARGB(214, 96, 96, 96),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RippleAnimation(
                      color: Color.fromARGB(156, 76, 175, 79),
                      repeat: true,
                      ripplesCount: 3,
                      duration: Duration(milliseconds: 2500),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(Icons.mic),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 250.0),
                      child: NotoText(
                        text: '上にスライドでキャンセル',
                        color: Colors.white,
                      ),
                    )
                  ],
                ))
            : SizedBox());
  }

  Padding textFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: Colors.white,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: controller,
              decoration: InputDecoration(
                hintText: '今してることを一言で記入',
                hintStyle: GoogleFonts.nunito(
                    color: Color.fromARGB(147, 170, 169, 169)),
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

                controller.clear();
              },
              icon: Icon(
                Icons.chat_bubble_outline_outlined,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  Container whatNowStamp(
      String WhatNowName, displayName, whatNowMessage, BuildContext context) {
    return Container(
      width: 350,
      child: SizedBox(
        width: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showWhatNow(context);
              },
              onHorizontalDragEnd: (details) {
                ref.watch(isUserWhatNowProvider.notifier).IsUserChange(ref);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'images/whatNowStamp/${WhatNowName}',
                  height: MediaQuery.of(context).size.height * 0.34,
                ),
              ),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(displayName),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTapDown: (detail) {
                      ref.watch(showTextProvider.notifier).show();
                    },
                    onTapUp: (details) {
                      ref.watch(showTextProvider.notifier).hide();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 0.0, right: 54, left: 54),
                      child: Text(
                        whatNowMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.yuseiMagic(
                            fontSize: 20,
                            color: Color.fromARGB(255, 221, 29, 93)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Align MessageTimeDetail(
      bool showText, String whatNowMessage, String updateAt) {
    return Align(
        alignment: Alignment.center,
        child: (showText == true)
            ? GestureDetector(
                onTap: () => ref.watch(showTextProvider.notifier).hide(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: Color.fromARGB(214, 96, 96, 96),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        (whatNowMessage != '') ? '「${whatNowMessage}」' : '',
                        style: GoogleFonts.yuseiMagic(
                            fontSize: 28,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '記入した時刻',
                        style: GoogleFonts.yuseiMagic(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        updateAt,
                        style: GoogleFonts.yuseiMagic(
                            fontSize: 26,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        '記入時刻から24時間経つと、文章は自動で消えます。',
                        style: GoogleFonts.yuseiMagic(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox());
  }

  Future<dynamic> showmyRecruitDialog(BuildContext context, Recruit recruit) =>
      showDialog(
          context: context,
          builder: (context) => RecruitDialog(
                recruit: recruit,
              ));

  Future<void> showPartnerRecruitDialog(
      BuildContext context, Recruit recruit) async {
    final _isMoveChat = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => PartnerRecruitDialog(
              recruit: recruit,
            ));
    if (_isMoveChat == true) context.go('/Chat1');
  }

  Future<dynamic> showWhatNow(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return WhatNowDialog();

          // return EngageDialog();
        });
  }

  void setActive(String stampname) {
    final currentUserDoc = ref.watch(CurrentAppUserDocProvider).value;
    ref.watch(isUserWhatNowProvider.notifier).IsUserTrue();
    currentUserDoc?.reference.update({'whatNow': '${stampname}.png'});
  }

  final List<String> menuItems = <String>[
    'add',
    '準備中',
    '準備中',
    '通話したい気分',
  ];

  Widget flowMenuItem(String text, bool isExistPartnerRecruit, String? uid,
      String? partnerUid, Recruit? recruit) {
    final double buttonDiameter = 30;
    final double buttonWidth =
        (MediaQuery.of(context).size.width - 30) / (menuItems.length - 1);
    return Align(
      alignment: Alignment.bottomRight,
      child: (text != 'add')
          ? Container(
              constraints: BoxConstraints.tight(Size(buttonWidth, 60)),
              child: RawMaterialButton(
                  fillColor: (text == '通話したい気分')
                      ? AppColors.red
                      : Color.fromARGB(255, 132, 132, 132),
                  splashColor: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  constraints: BoxConstraints.tight(
                      Size(buttonDiameter, buttonDiameter)),
                  onPressed: () {
                    menuAnimation.status == AnimationStatus.completed
                        ? menuAnimation.reverse()
                        : menuAnimation.forward();
                    if (text == '通話したい気分') {
                      addRecruit(ref, 'phone');
                      if (isExistPartnerRecruit)
                        updatePartnerRecruit(ref, 'phone', {
                          'showList': [uid, partnerUid]
                        });
                      updatePartnerData(ref,
                          field: 'isShowRecruit', value: true);
                      if (recruit != null)
                        showmyRecruitDialog(context, recruit);

                      incrementActivity(ref, 'want to call');
                    }
                    ;
                  },
                  child: NotoText(
                    text: text,
                    color: Colors.white,
                  )),
            )
          : Container(
              width: 60,
              height: 60,
              constraints: BoxConstraints.tight(Size(30, 30)),
              child: RawMaterialButton(
                  fillColor: Color.fromARGB(255, 255, 234, 234),
                  shape: const CircleBorder(),
                  constraints: BoxConstraints.tight(
                      Size(buttonDiameter, buttonDiameter)),
                  onPressed: () {
                    menuAnimation.status == AnimationStatus.completed
                        ? menuAnimation.reverse()
                        : menuAnimation.forward();
                  },
                  child: Icon(
                    Icons.add,
                    color: Color.fromARGB(173, 152, 152, 152),
                    size: 20,
                  )),
            ),
    );
  }
}

class Ss extends ConsumerWidget {
  const Ss({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class AnnounceDialog extends ConsumerWidget {
  const AnnounceDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(onButtonPressd: () {}, buttonExist: false, children: [
      NotoText(
        text: 'アップデートのお知らせ',
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      NotoText(
        text: 'いつもふたりべやをご利用いただき本当にありがとうございます。',
        topPadding: 20,
      ),
      NotoText(
        text: '・「部屋」タブの復活\n・画像の保存、拡大',
        topPadding: 20,
      ),
      NotoText(
        text:
            'などのアップデートをおこないました。\n部屋タブについては、皆さま丁寧にご意見くださってありがとうございました。「部屋を残してほしい」という方が多かったので、復活を決定しました。',
        topPadding: 20,
      ),
      NotoText(
        text: '今後とも、二人部屋を楽しんでいただけましたら幸いです。\nいつでも、要望、コメント、感想、お待ちしております。',
        topPadding: 20,
      ),
      SizedBox(height: 10),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            updateUserData(ref, field: 'isGetAnnouncement0505', value: true);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: NotoText(
            text: '確認した',
            color: Colors.white,
          ))
    ]);
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    double dy = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * (i - 1) / 3;
      dy = (i == 0)
          ? 0
          : (i == 1)
              ? 0
              : (i == 2)
                  ? -80
                  : (i == 3)
                      ? -120
                      : 0;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          (menuAnimation.value == 0 && i != 0)
              ? 200
              : (menuAnimation.value == 0 && i == 0)
                  ? -20
                  : (menuAnimation.value != 0 && i == 0)
                      ? 50
                      : -dx * menuAnimation.value,
          (i == 0) ? -10 : 0,
          0,
        ),
      );
    }
  }
}
