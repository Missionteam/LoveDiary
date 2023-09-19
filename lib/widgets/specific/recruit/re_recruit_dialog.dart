import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/providers/users_provider.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/activity.dart';
import '../../../providers/cloud_messeging_provider.dart';
import '../../../providers/recruit_provider.dart';
import '../../util/text_form.dart';
import 'conffeti_dialog.dart';

class ReRecruitDialog extends ConsumerStatefulWidget {
  const ReRecruitDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReRecruitDialogState();
}

class _ReRecruitDialogState extends ConsumerState<ReRecruitDialog> {
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
              width: sWidth(context) * 0.9,
              onButtonPressd: (() async {
                _submission();
                if (_messege != '') {
                  sendOfficialPost(
                      ref,
                      '''
【時間あったら通話したい !】
　希望時間：${_time}''',
                      isShowDate: false);
                  sendOfficialPost(ref, '''
　${userName}が別の通話の時間を提案しました。''');
                  incrementActivity(ref, 'approve call');

                  sendPost(ref, _messege, roomId: 'init');
                  // removePartnerRecruit(ref, 'phone');
                  FirebaseCloudMessagingService().sendPushNotification(
                    token: _token,
                    title: '${userName}が別の通話時間を提案しました。',
                    body: _messege,
                    type: 'chat',
                  );

                  int count = 0;
                  Navigator.of(context).pop(true);
                }
              }),
              children: [
                MagicText(text: '時間を提案', topPadding: 40),
                TextForm(
                    formKey: _formKey,
                    topPadding: 60,
                    text: '',
                    hintText: '例：20時~22時ならいける！🙆‍♀️',
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
