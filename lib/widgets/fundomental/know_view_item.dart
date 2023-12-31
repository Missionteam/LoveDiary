import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/loveDialog/know_talk_summary.dart';

import '../../allConstants/color_constants.dart';
import '../../providers/know_provider.dart';
import '../loveDialog/dialog/save_know_content.dart';
import '../util/dialog.dart';
import '../util/text.dart';

class KnowViewItem extends ConsumerStatefulWidget {
  const KnowViewItem({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KnowViewState();
}

class _KnowViewState extends ConsumerState<KnowViewItem> {
  String? _selectedFeelings;
  String? what;
  String? why;
  String? baseReason;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(knowProvider).value?.docs;
    final know = docs != null && docs.isNotEmpty ? docs[0].data() : null;

    return (know == null)
        ? Container(
            height: sHieght(context) * 0.8,
            child: Center(
              child: NotoText(text: "もやもやはありません。"),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              NotoText(
                  text: "話したいことまとめ", fontWeight: FontWeight.w600, fontSize: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ref.watch(knowProvider).when(
                  data: (data) {
                    /// 値が取得できた場合に呼ばれる。
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10, left: 10),
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        final know = data.docs[index].data();
                        final formKey5 = GlobalKey<FormState>();
                        final formKey6 = GlobalKey<FormState>();
                        final formKey7 = GlobalKey<FormState>();
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: KnowTalkSummary(
                                formKey5: formKey5,
                                formKey6: formKey6,
                                formKey7: formKey7,
                                know: know,
                                baseReason: know.baseReason,
                                what: know.what,
                                why: know.why,
                                onBaseReasonLoveSaved: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      this.baseReason = "love";
                                    });
                                  }
                                },
                                onBaseReasonStaySaved: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      this.baseReason = "stay";
                                    });
                                  }
                                },
                                onWhatSaved: (String? value) {
                                  setState(() {
                                    this.what = value;
                                  });
                                },
                                onWhySaved: (String? value) {
                                  setState(() {
                                    this.why = value;
                                  });
                                },
                                onFeeingsSaved: (String? value) {
                                  setState(() {
                                    this._selectedFeelings = value;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => BaseDialog(
                                            onButtonPressd: () {},
                                            buttonExist: false,
                                            color: Colors.white,
                                            closeIconExist: true,
                                            height: 300,
                                            children: [
                                              SaveKnowContent(
                                                know: know,
                                              )
                                            ],
                                          ));
                                  know.reference.update({"isSolved": true});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonGreen,
                                  maximumSize: Size(300, 60),
                                ),
                                child: NotoText(
                                  text: "解決！",
                                  color: Colors.white,
                                )),
                          ],
                        );
                      },
                    );
                  },
                  error: (_, __) {
                    /// 読み込み中にErrorが発生した場合に呼ばれる。
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
            ],
          );
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}
