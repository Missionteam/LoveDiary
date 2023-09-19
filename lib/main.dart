import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:thanks_diary/pages/home_page.dart';
import 'package:thanks_diary/pages/input_page.dart';
import 'package:thanks_diary/pages/review_page.dart';
import 'package:thanks_diary/pages/tworoom/chat_page.dart';
import 'package:thanks_diary/pages/tworoom/chat_room_page.dart';
import 'package:thanks_diary/pages/tworoom/myroom_page.dart';
import 'package:thanks_diary/pages/tworoom/notification_page.dart';
import 'package:thanks_diary/pages/tworoom/partner_room_page.dart';
import 'package:thanks_diary/pages/tworoom/tworoom_home_page.dart';
import 'package:thanks_diary/pages/tworoom/voice_page.dart';

import 'firebase_options.dart';
import 'pages/auth/auth_checker.dart';
import 'pages/setting_page.dart';
import 'pages/tworoom/room_grid_page.dart';

//      home: const SignInPage(),
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// プラットフォームの確認
final isAndroid =
    defaultTargetPlatform == TargetPlatform.android ? true : false;
final isIOS = defaultTargetPlatform == TargetPlatform.iOS ? true : false;

/// FCMバックグランドメッセージの設定
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  // main 関数でも async が使えます
  WidgetsFlutterBinding.ensureInitialized();
  // runApp 前に何かを実行したいときはこれが必要です。
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    // これが Firebase の初期化処理です。
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  runApp(
    ProviderScope(child: InitPage()),
  );
}

class InitPage extends ConsumerWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: AuthChecker(),
      builder: (context, child) {
        return MediaQuery(
          // 端末依存のフォントスケールを 1 に固定
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // final version = FirebaseFirestore.instance.collection();

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/NotificationPage',
    routes: <RouteBase>[
      /// Application shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return child;
        },
        routes: <RouteBase>[
          /// The first screen to display in the bottom navigation bar
          GoRoute(
              path: '/NotificationPage',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(child: NotificationPage());
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'Auth_checker',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      NoTransitionPage(
                    child: const AuthChecker(),
                  ),
                ),
              ]),

          GoRoute(
              path: '/Home1',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(child: HomePage());
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'Chat1',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(child: ChatPage1());
                  },
                ),
                GoRoute(
                  path: 'Home11',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(child: HomePage11());
                  },
                ),
                GoRoute(
                  path: 'Setting',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(child: ProfilePage());
                  },
                ),
              ]),
          GoRoute(
            path: '/Input',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: InputPage());
            },
          ),

          /// The third screen to display in the bottom navigation bar.
          GoRoute(
            path: '/Chat1',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: ChatPage1());
            },
          ),
          GoRoute(
            path: '/Voice',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: VoicePage());
            },
          ),
          GoRoute(
            path: '/RoomGrid1',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: RoomGridPage());
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'Chat1',
                builder: (BuildContext context, GoRouterState state) {
                  return ChatRoomPage1();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/MyRoom1',
            pageBuilder: (context, state) {
              return NoTransitionPage(child: MyRoomPage1());
            },
          ),
          GoRoute(
            path: '/MyRoom2',
            pageBuilder: (context, state) {
              return NoTransitionPage(child: MyRoomPage2());
            },
          ),
          GoRoute(
            path: '/Review',
            pageBuilder: (context, state) {
              return NoTransitionPage(child: ReviewPage());
            },
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(),
      // home: const SignInPage(),
      // home: const AuthChecker(),
      routerConfig: _router,

      // routes: <String, WidgetBuilder>{
      //   '/home': (BuildContext context) => new MainPage(),
      //   '/testPage': (BuildContext context) => new TestPage()
      // },
    );

    //   元々のAuth＿cheker
    //   if (FirebaseAuth.instance.currentUser == null) {
    //    // 未ログイン
    //    return MaterialApp(
    //      theme: ThemeData(),
    //      home: const SignInPage(),
    //    );
    //  } else {
    //    // ログイン中
    //    return MaterialApp(
    //      theme: ThemeData(),
    //      home: const MainPage(),
    //    );
    //  }
  }
}
