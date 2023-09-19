import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/text_functions.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';

class ShareDialog extends ConsumerStatefulWidget {
  ShareDialog({
    Key? key,
    this.Screenpadding =
        const EdgeInsets.only(bottom: 10, left: 60, right: 60, top: 10),
  }) : super(key: key);
  EdgeInsetsGeometry Screenpadding;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareDialogState();
}

class _ShareDialogState extends ConsumerState<ShareDialog> {
  final controller = TextEditingController();
  void _link(String id) {
    ref
        .watch(currentAppUserDocRefProvider)
        .update({'talkroomId': id, 'chattingWith': id});

    final uid = ref.watch(uidProvider);
    final docRef = ref.watch(AppUsersReferenceProvider).doc(id);
    docRef.update({'talkroomId': id, 'chattingWith': uid});
  }

  @override
  void dispose() {
    // TextEditingController は使われなくなったら必ず dispose する必要があります。
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider) ?? '';
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Color.fromARGB(255, 138, 138, 138),
            ),
          ),
          Padding(
            padding: widget.Screenpadding,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                width: 300,
                height: 550,
                padding: EdgeInsets.all(40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'このアプリは試験版のため、Apple公式のテスト用サイトTestFlight、またはDeployGateというサイトからダウンロードする必要があります。',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '以下のURLをパートナーに共有してください。',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Color.fromARGB(226, 198, 198, 198),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '・iOS',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextWithUrl(
                        text: 'https://testflight.apple.com/join/DLPiSOZy',
                        fontSize: 16,
                        // style: GoogleFonts.nunito(
                        //   fontSize: 16,
                        // ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '・android',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextWithUrl(
                        text: 'https://dply.me/ccnwq4',
                        fontSize: 16,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("パートナーと連携しました。間違ったコードを入力した場合、再度入力しなおしてください。"),
    );
  }
}
