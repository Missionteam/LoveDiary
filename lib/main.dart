import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:thanks_diary/pages/home_page.dart';
import 'package:thanks_diary/pages/know_input_page.dart';
import 'package:thanks_diary/pages/know_view_page.dart';
import 'package:thanks_diary/pages/love_input_page.dart';
import 'package:thanks_diary/pages/love_view_page.dart';
import 'package:thanks_diary/pages/review_page.dart';
import 'package:thanks_diary/pages/tworoom/chat_page.dart';
import 'package:thanks_diary/pages/tworoom/notification_page.dart';
import 'package:thanks_diary/pages/tworoom/tworoom_home_page.dart';
import 'package:thanks_diary/widgets/fundomental/BtmNavigation.dart';

import 'firebase_options.dart';
import 'pages/auth/auth_checker.dart';
import 'pages/setting_page.dart';

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
  await initializeDateFormatting('ja_JP', null);
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
          return ScaffoldWithNavBar1Review(child: child);
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
            path: '/LoveInput',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: LoveInputPage());
            },
          ),
          GoRoute(
            path: '/LoveView',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: LoveViewPage());
            },
          ),
          GoRoute(
            path: '/KnowInput',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: KnowInputPage());
            },
          ),
          GoRoute(
            path: '/KnowView',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(child: KnowViewPage());
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
