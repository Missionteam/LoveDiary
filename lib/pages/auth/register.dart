import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/users_provider.dart';

enum RadioValue {
  FIRST,
  SECOND,
}

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  String name = '';
  String partnerName = "○○";
  RadioValue _gValue = RadioValue.FIRST;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDoc = ref.watch(currentAppUserDocRefProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 20),
                    child: Image.asset("images/mainIcon.png",
                        width: 100, height: 100)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'ありがとう日記を始めましょう！',
                  style: GoogleFonts.nunito(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'お名前',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'パートナーの名前',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      partnerName = value;
                    });
                  },
                ),

                SizedBox(
                  height: 30,
                ),
                // 3行目 ユーザ登録ボタン
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: const Text('登録完了'),
                    onPressed: () async {
                      try {
                        bool isGirl =
                            (_gValue == RadioValue.FIRST) ? true : false;
                        String userimage = (isGirl == true) ? 'Girl' : 'Boy';
                        userDoc.update(
                            {'displayName': name, 'partnerName': partnerName});
                        userDoc.update({'isGirl': isGirl});
                        userDoc.update({'photoUrl': userimage});

                        // showDialog(
                        //     context: context,
                        //     builder: (_) {
                        //       return AlertDialog(
                        //         title: Text('ご登録ありがとうございます！'),
                        //         content: Text('恋人との連携は、ホーム画面の設定から行えます。'),
                        //         actions: [
                        //           TextButton(
                        //             child: Text('OK'),
                        //             onPressed: (() {
                        //               Navigator.of(context).pop();
                        //             }),
                        //           )
                        //         ],
                        //       );
                        //     });
                        Navigator.of(context).pop();
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(builder: (context) {
                        //   return MyApp();
                        // }));
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                // 4行目 ログインボタン

                // 5行目 パスワードリセット登録ボタン
              ],
            ),
          ),
        ),
      ),
    );
  }
}
