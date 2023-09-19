import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/models/activity.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../providers/cloud_messeging_provider.dart';
import '../../util/text_form.dart';
import 'conffeti_dialog.dart';

class DenyRecruitDialog extends ConsumerStatefulWidget {
  const DenyRecruitDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DenyRecruitDialogState();
}

class _DenyRecruitDialogState extends ConsumerState<DenyRecruitDialog> {
  final _formKey = GlobalKey<FormState>();
  String _messege = '';
  void _submission() {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDoc = ref.watch(CurrentAppUserDocProvider).value;
    final userName = userDoc?.data()!.displayName ?? '';
    final _token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    final _timeData =
        ref.watch(partnerRecruitProvider('phone')).value?.data()?.time ?? '';
    final _time = (_timeData != '') ? _timeData : '希望時間未記入';

    return SafeArea(
      child: Stack(
        children: <Widget>[
          BaseDialog(
              height: 460,
              width: sWidth(context) * 0.82,
              onButtonPressd: (() async {
                _submission();
                sendOfficialPost(
                    ref,
                    '''
【時間あったら通話したいかも】
　希望時間：${_time}''',
                    isShowDate: false);
                sendOfficialPost(ref, '''
　ごめん、今通話できない…''');
                sendPost(ref, _messege, roomId: 'init');
                incrementActivity(ref, 'deny call');
                removePartnerRecruit(ref, 'phone');
                FirebaseCloudMessagingService().sendPushNotification(
                  token: _token,
                  title: 'ごめん、今通話できない…',
                  body: _messege,
                  type: 'chat',
                );
                int count = 0;
                Navigator.popUntil(
                  context,
                  (_) => count++ >= 2,
                );
              }),
              children: [
                MagicText(text: 'ごめん、\n今通話できない…', topPadding: 40),
                TextForm(
                    formKey: _formKey,
                    topPadding: 60,
                    text: '',
                    hintText: 'ごめんね、を伝えましょう。',
                    initialValue: '',
                    fontSize: 20,
                    color: Color.fromARGB(255, 28, 28, 28),
                    onSaved: (String? value) {
                      this._messege = value ?? '';
                    }),
                SizedBox(
                  height: 50,
                )
              ]),
        ],
      ),
    );
  }
}
