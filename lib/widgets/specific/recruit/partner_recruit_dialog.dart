import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/widgets/specific/recruit/conffeti_dialog.dart';
import 'package:thanks_diary/widgets/specific/recruit/deny_recruit_dialog%20.dart';
import 'package:thanks_diary/widgets/specific/recruit/recruit_detail_dialog%20.dart';

import '../../../allConstants/color_constants.dart';
import '../../../function/util_functions.dart';
import '../../../models/recruit.dart';
import '../../util/text.dart';
import 're_recruit_dialog.dart';

const double _kItemExtent = 32.0;
const List<String> _dulationNames = <String>[
  '無制限',
  '12時間',
  '24時間',
  '3日間',
  '1週間',
];

class PartnerRecruitDialog extends ConsumerStatefulWidget {
  PartnerRecruitDialog({super.key, required this.recruit});
  Recruit recruit;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PartnerRecruitDialogState();
}

class _PartnerRecruitDialogState extends ConsumerState<PartnerRecruitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  late int _selectedDulation;
  String _time = '';
  String _isShow = '';
  String _showDuration = '';
  RadioIsShowValue _gValue = RadioIsShowValue.always;
  bool isNotify = false;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  void _submission() {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
    }
  }

  Future<void> updateData(
    String time,
    int dulation,
  ) async {
    final data = {'time': time, 'dulation': dulation};
    updateRecruit(ref, widget.recruit.type, data);
  }

  @override
  void initState() {
    _selectedDulation = widget.recruit.dulation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final index = 0;
    final color = (index % 3 == 0)
        ? Color.fromARGB(255, 62, 213, 152)
        : (index % 3 == 1)
            ? Color.fromARGB(255, 255, 210, 30)
            : (index % 3 == 2)
                ? Color.fromARGB(255, 255, 86, 94)
                : Color.fromARGB(255, 255, 210, 30);
    final image = (index % 3 == 0)
        ? 'GreenBoxImage.png'
        : (index % 3 == 1)
            ? 'YellowBoxImage.png'
            : (index % 3 == 2)
                ? 'Red2BoxImage.png'
                : 'YellowBoxImage.png';
    return SizedBox(
      height: 900,
      width: 400,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: (sHieght(context) - 400) * 0.3,
          horizontal: sWidth(context) * 0.09,
        ),
        child: Material(
          color: Color.fromARGB(0, 255, 193, 7),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: 90,
                        child: Image.asset('images/roomgrid/${image}'))),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                  child: SizedBox(
                    width: 250,
                    height: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MagicText(
                          text: '~通話の詳細~',
                          textAlign: TextAlign.center,
                          color: Color.fromARGB(255, 255, 34, 34),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: MagicText(
                              text: '通話したい時間：',
                              color: Color.fromARGB(255, 24, 24, 24),
                              fontSize: 20,
                            )),
                        SizedBox(height: 20),
                        MagicText(
                            text: (widget.recruit.time != '')
                                ? widget.recruit.time
                                : '未記入',
                            fontSize: (widget.recruit.time != '') ? 24 : 16),
                        SizedBox(height: 30),
                        TextButton(
                            onPressed: () async {
                              final _isMoveChat = await showDialog(
                                  context: context,
                                  builder: ((_) => ConffetiDialog()));
                              if (_isMoveChat == true)
                                Navigator.of(context).pop(true);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              fixedSize: Size(150, 40),
                            ),
                            child: Text(
                              '通話しよ！',
                              style: GoogleFonts.nunito(
                                  // color: Color.fromARGB(255, 243, 243, 243)),
                                  color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: TextButton(
                        child: MainText(
                          text: '別の時間を提示',
                          color: Color.fromARGB(255, 12, 89, 255),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          final _isMoveChat = await showDialog<bool>(
                            context: context,
                            builder: (context) => ReRecruitDialog(),
                          );
                          if (_isMoveChat == true)
                            Navigator.of(context).pop(true);
                        })),
                Positioned(
                    bottom: 10,
                    left: 15,
                    child: TextButton(
                        child: MainText(
                          text: 'ごめん、\n今通話できない…',
                          color: Color.fromARGB(255, 255, 12, 12),
                        ),
                        onPressed: () {
                          showDialog<bool>(
                            context: context,
                            builder: (context) => DenyRecruitDialog(),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  Future<void> showConfirmDialog(BuildContext context, WidgetRef ref,
      {String title = '', String main = '', Future<void>? onTapOK}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 255, 231, 239),
        title: NotoText(
          text: title,
          fontSize: 18,
        ),
        content: NotoText(text: main),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              int count = 0;
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              removeRecruit(ref, 'phone');
              int count = 0;
              Navigator.popUntil(context, (_) => count++ >= 2);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
