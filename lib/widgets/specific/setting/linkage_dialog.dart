import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';

class LinkageDialog extends ConsumerStatefulWidget {
  LinkageDialog({
    Key? key,
    this.Screenpadding =
        const EdgeInsets.only(bottom: 10, left: 60, right: 60, top: 10),
  }) : super(key: key);
  EdgeInsetsGeometry Screenpadding;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LinkageDialogState();
}

class _LinkageDialogState extends ConsumerState<LinkageDialog> {
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
                height: 400,
                padding: EdgeInsets.all(40),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '以下のコードをパートナーに共有してください。',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    uid,
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
                    'または、パートナーのコードを以下に入力してください。',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                    ),
                  ),
                  Material(
                    child: new TextFormField(
                        enabled: true,
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 10),
                          hintText: 'パートナーのコードを入力してください。',
                          labelText: 'パートナーコード',
                        ),
                        onFieldSubmitted: ((value) {
                          _link(value);
                          controller.clear();
                          Navigator.of(context).pop();
                          showDialog(
                              context: context, builder: (_) => AlertWidget());
                        })),
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
