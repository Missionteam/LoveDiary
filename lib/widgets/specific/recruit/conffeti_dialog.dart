import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/function/firestore_functions.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/providers/cloud_messeging_provider.dart';
import 'package:thanks_diary/providers/recruit_provider.dart';
import 'package:thanks_diary/widgets/util/dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../../models/activity.dart';
import '../../../models/cloud_storage_model.dart';
import '../../../models/post.dart';
import '../../../providers/posts_provider.dart';
import '../../../providers/users_provider.dart';
import '../../util/text_form.dart';

class ConffetiDialog extends ConsumerStatefulWidget {
  const ConffetiDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConffetiDialogState();
}

class _ConffetiDialogState extends ConsumerState<ConffetiDialog> {
  late ConfettiController _controller;
  late ConfettiController _controllerCenter;
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
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 100));
    _controller.play();
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    final _timeData =
        ref.watch(partnerRecruitProvider('phone')).value?.data()?.time ?? '';
    final _time = (_timeData != '') ? _timeData : '希望時間未記入';

    return SafeArea(
      child: Stack(
        children: <Widget>[
          BaseDialog(
              height: 390,
              width: sWidth(context) * 0.82,
              onButtonPressd: (() {
                _submission();
                sendOfficialPost(
                    ref,
                    '''
【時間あったら通話したい !】
　希望時間：${_time}''',
                    isShowDate: false);
                sendOfficialPost(ref, '''
　通話の予定が決定しました🎊''');
                sendPost(ref, _messege, roomId: 'init');
                incrementActivity(ref, 'approve call');

                removePartnerRecruit(ref, 'phone');
                FirebaseCloudMessagingService().sendPushNotification(
                  token: _token,
                  title: '通話の予定が決定しました🎊',
                  body: _messege,
                  type: 'chat',
                );
                Navigator.of(context).pop(true);
              }),
              children: [
                MagicText(text: '通話決定🎊', topPadding: 40),
                MagicText(
                  text: '通話の時間を確定させましょう',
                  topPadding: 40,
                  fontSize: 16,
                ),
                TextForm(
                    formKey: _formKey,
                    text: '',
                    hintText: '例：今日の20時からでどう？',
                    initialValue: '',
                    fontSize: 20,
                    color: Color.fromARGB(255, 28, 28, 28),
                    onSaved: (String? value) {
                      this._messege = value ?? '';
                    }),
                SizedBox(
                  height: 20,
                )
              ]),
          ConfettiSideWidget(
              controller: _controller,
              direction: pi,
              alignment: Alignment.topRight),
          ConfettiSideWidget(
              controller: _controller,
              direction: 0,
              alignment: Alignment.topLeft),
          ConfettiCenterWidget(
              controllerCenter: _controllerCenter, direction: pi / 3),
          ConfettiCenterWidget(
              controllerCenter: _controllerCenter, direction: 2 * pi / 3),
          ConfettiCenterWidget(
              controllerCenter: _controllerCenter, direction: pi / 2),
        ],
      ),
    );
  }
}

class ConfettiSideWidget extends StatelessWidget {
  const ConfettiSideWidget(
      {Key? key,
      required ConfettiController controller,
      required this.direction,
      required this.alignment})
      : _controller = controller,
        super(key: key);

  final ConfettiController _controller;
  final double direction;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: direction,
        maxBlastForce: 13,
        minBlastForce: 0.1,
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.05, // how often it should emit
        numberOfParticles: 8, // number of particles to emit
        gravity: 0.05, // gravity - or fall speed
        shouldLoop: false,
        colors: const [
          Color.fromARGB(255, 145, 254, 149),
          Color.fromARGB(255, 83, 172, 244),
          Color.fromARGB(255, 255, 172, 200)
        ], // manually specify the colors to be used
      ),
    );
  }
}

class ConfettiCenterWidget extends StatelessWidget {
  const ConfettiCenterWidget({
    Key? key,
    required ConfettiController controllerCenter,
    required this.direction,
  })  : _controllerCenter = controllerCenter,
        super(key: key);

  final ConfettiController _controllerCenter;
  final double direction;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: direction,
        maxBlastForce: 50,
        minBlastForce: 10,
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.6, // how often it should emit
        numberOfParticles: 6, // number of particles to emit
        gravity: 0.05, // gravity - or fall speed
        shouldLoop: false,
        colors: const [
          Color.fromARGB(255, 145, 254, 149),
          Color.fromARGB(255, 83, 172, 244),
          Color.fromARGB(255, 255, 172, 200)
        ], // manually specify the colors to be used
      ),
    );
  }
}

Future<void> sendOfficialPost(
  WidgetRef ref,
  String text, {
  String? imageLocalPath,
  File? imageFile,
  String? imageCloudPath,
  bool isShowDate = true,
  String roomId = 'init',
}) async {
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final posterId = userDoc?.get('id');
  final posterName = userDoc?.get('displayName');
  final posterImageUrl = userDoc?.get('photoUrl');

  final newDocumentReference = ref.watch(postsReferenceProvider).doc();
  final id = newDocumentReference.id;
  if (imageFile != null && imageCloudPath != null) {
    uploadFile(imageFile, imageCloudPath);
  }
  final newPost = Post(
      isOfficial: true,
      text: text,
      roomId: roomId,
      createdAt: Timestamp.now(),
      posterName: posterName,
      posterImageUrl: posterImageUrl,
      posterId: posterId,
      stamps: '',
      imageLocalPath: imageLocalPath ?? '',
      imageUrl: (imageFile != null) ? imageCloudPath ?? '' : '',
      reference: newDocumentReference,
      isShowDate: isShowDate,
      id: id);

  if (text != '' || imageFile != null) {
    newDocumentReference.set(newPost);
  }
}
