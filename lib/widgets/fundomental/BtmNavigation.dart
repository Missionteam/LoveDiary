import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/models/user.dart';
import 'package:thanks_diary/providers/posts_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';

import '../../models/room_id_model.dart';
import '../../pages/tworoom/reply_page.dart';
import '../../providers/users_provider.dart';

class ScaffoldWithNavBar1Review extends ConsumerStatefulWidget {
  /// Constructs an [ScaffoldWithNavBar1Review].
  const ScaffoldWithNavBar1Review({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScaffoldWithNavBar1ReviewState();

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/Home1')) {
      return 0;
    }
    if (location.startsWith('/Chat1')) {
      return 1;
    }
    if (location.startsWith('/MyRoom2')) {
      return 2;
    }
    if (location.startsWith('/MyRoom1')) {
      return 3;
    }
    if (location.startsWith('/Review')) {
      return 4;
    }
    return 0;
  }

  static int _calculateSelectedIndex1(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/Home1')) {
      return 0;
    }
    if (location.startsWith('/Chat1')) {
      return 1;
    }
    if (location.startsWith('/RoomGrid1')) {
      return 2;
    }

    if (location.startsWith('/MyRoom1')) {
      return 3;
    }
    if (location.startsWith('/Review')) {
      return 4;
    }
    // if (location.startsWith('/Setting')) {
    //   return 4;
    // }
    return 0;
  }
}

class _ScaffoldWithNavBar1ReviewState
    extends ConsumerState<ScaffoldWithNavBar1Review> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    ///initalMessage （= アプリ終了中の通知）が存在するときに、関数_handleMessegeを実行。
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    ///　アプリ起動中に通知を監視。
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'init') {
      GoRouter.of(context).go('/Chat1');
    }
    if (message.data['type'] == 'tweet') {
      GoRouter.of(context).go('/MyRoom2');
    }
    if (message.data['type'] == 'room') {
      final roomId = message.data['room'];
      ref.watch(roomIdProvider.notifier).setRoomId(roomId);
      GoRouter.of(context).go('/RoomGrid1/Chat1');
    }
    if (message.data['type'] == 'home') {
      GoRouter.of(context).go('/Home1');
    }
    if (message.data['type'] == 'review') {
      ref.watch(roomIdProvider.notifier).setRoomId('rivew');
      GoRouter.of(context).go('/RoomGrid1/Chat1');
    }
    if (message.data['type'] == 'reply') {
      final postId = message.data['postId'];
      if (postId == '') {
        return null;
      }
      final postSnapshot =
          await ref.watch(postsReferenceProvider).doc(postId).get();
      final post = postSnapshot.data();
      if (post != null) {
        showDialog(context: context, builder: (_) => ReplyPage(post: post));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    // const backgroundColor = Color.fromARGB(255, 238, 192, 191);
    const backgroundColor = AppColors.main;
    final version = ref.watch(talkroomDocProvider).value?.get('version') ?? 1;
    final user = ref.watch(CurrentAppUserDocProvider).value?.data();

    return (version == 0)
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            body: widget.child,
            bottomNavigationBar: Container(
              color: AppColors.main,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(147, 59, 59, 59),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    height: 80,
                    child: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          backgroundColor: Color.fromARGB(255, 180, 35, 35),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.question_answer_outlined),
                          label: 'Chat',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.textsms),
                          label: 'PartnerRoom',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.textsms_outlined),
                          label: 'MyRoom',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.border_color),
                          label: 'Settings',
                          backgroundColor: backgroundColor,
                        ),
                      ],
                      currentIndex:
                          ScaffoldWithNavBar1Review._calculateSelectedIndex(
                              context),
                      backgroundColor: backgroundColor,
                      elevation: 10,
                      type: BottomNavigationBarType.fixed,
                      onTap: (int idx) => _onItemTapped(idx, context, user),
                      fixedColor: Color.fromARGB(255, 120, 140, 150),
                      // fixedColor: AppColors.red,
                      unselectedItemColor: Color.fromARGB(255, 150, 167, 175),
                      showUnselectedLabels: false,
                      showSelectedLabels: false,
                      selectedIconTheme: IconThemeData(size: 30),
                      unselectedIconTheme: IconThemeData(size: 30),
                      unselectedLabelStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 90, 90, 90),
                      ),
                      selectedLabelStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 90, 90, 90),
                      ),
                      enableFeedback: false,
                    ),
                  ),
                ),
              ),
            ))
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: widget.child,
            bottomNavigationBar: Container(
              color: AppColors.main,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(147, 59, 59, 59),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    height: 80,
                    child: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          backgroundColor: backgroundColor,
                        ),

                        BottomNavigationBarItem(
                          icon: Icon(Icons.question_answer_outlined),
                          label: 'Chat',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.menu_book),
                          label: 'Room',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.sms_outlined),
                          label: 'MyRoom',
                          backgroundColor: backgroundColor,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.border_color),
                          label: 'Settings',
                          backgroundColor: backgroundColor,
                        ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.account_circle_outlined),
                        //   label: 'Settings',
                        //   backgroundColor: backgroundColor,
                        // ),
                      ],
                      currentIndex:
                          ScaffoldWithNavBar1Review._calculateSelectedIndex1(
                              context),
                      backgroundColor: backgroundColor,
                      elevation: 10,
                      type: BottomNavigationBarType.fixed,
                      onTap: (int idx) => _onItemTapped1(idx, context),
                      fixedColor: Color.fromARGB(255, 120, 140, 150),
                      unselectedItemColor: Color.fromARGB(255, 150, 167, 175),
                      showUnselectedLabels: false,
                      showSelectedLabels: false,
                      selectedIconTheme: IconThemeData(size: 30),
                      unselectedIconTheme: IconThemeData(size: 30),
                      unselectedLabelStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 90, 90, 90),
                      ),
                      selectedLabelStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 90, 90, 90),
                      ),
                      enableFeedback: false,
                    ),
                  ),
                ),
              ),
            ));
  }

  void _onItemTapped(int index, BuildContext context, AppUser? user) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/Home1');
        break;
      case 1:
        GoRouter.of(context).go('/Chat1');
        break;
      case 2:
        GoRouter.of(context).go('/MyRoom2');
        // if (user?.isFirstUseVoice == true) {
        //   // showCustomSnackBar(context,
        //   //     bottomPadding: 30,
        //   //     paddingSWidthParcent: 0.04,
        //   //     text: 'タップしながら話すとボイスメッセージを送れます。');
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: Color.fromARGB(255, 212, 212, 212),
        //       duration: Duration(milliseconds: 4000),
        //       content: Text(
        //         'タップしながら話すとボイスメッセージを送れます。',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(color: Colors.black),
        //       )));
        //   updateUserData(ref, field: 'isFirstUseVoice', value: false);
        // }

        break;
      case 3:
        GoRouter.of(context).go('/MyRoom1');
        break;
      case 4:
        GoRouter.of(context).go('/Review');
        break;
    }
  }

  void _onItemTapped1(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/Home1');
        break;
      case 1:
        GoRouter.of(context).go('/Chat1');
        break;
      case 2:
        GoRouter.of(context).go('/RoomGrid1');
        break;
      case 3:
        GoRouter.of(context).go('/MyRoom1');
        // GoRouter.of(context).go('/Setting');
        break;
      case 4:
        GoRouter.of(context).go('/Review');
        break;
    }
  }
}
