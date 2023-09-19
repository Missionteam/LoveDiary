import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:thanks_diary/models/activity.dart';
import 'package:thanks_diary/providers/cloud_messeging_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';
import 'package:thanks_diary/widgets/record/circle_record_button%20.dart';

import '../../function/firestore_functions.dart';
import '../../models/cloud_storage_model.dart';
import '../../models/show_controller.dart';
import '../fundomental/snack_bar.dart';
import 'chat_record_button.dart';

class AudioRecorder extends ConsumerStatefulWidget {
  const AudioRecorder({
    Key? key,
    required this.isCircleButton,
    this.roomId = 'init',
  }) : super(key: key);
  final bool isCircleButton;
  final String roomId;

  @override
  ConsumerState<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends ConsumerState<AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _recordSub?.resume();
    _amplitudeSub?.resume();
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (detail) {
          ref.watch(showRecordDialogProvider.notifier).show();
          _start();
        },
        onTapUp: (details) {
          ref.watch(showRecordDialogProvider.notifier).hide();
          _stop();
        },
        onTapCancel: () {
          ref.watch(showRecordDialogProvider.notifier).hide();
          _stop();
        },
        child: (widget.isCircleButton && (_recordState == RecordState.record))
            ? CircleRecordingButton()
            : (widget.isCircleButton && (_recordState == RecordState.stop))
                ? CircleRecordButton()
                : (widget.isCircleButton == false &&
                        (_recordState == RecordState.record))
                    ? ChatRecordingButton()
                    : (widget.isCircleButton == false &&
                            (_recordState == RecordState.stop))
                        ? ChatRecordButton()
                        : SizedBox());
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    final user = ref.watch(CurrentAppUserDocProvider).value?.data();
    final token = ref.watch(PartnerfcmTokenProvider).value ?? '';
    final roomName = (widget.isCircleButton)
        ? 'Voice page'
        : (widget.roomId == 'init')
            ? '日常会話の部屋'
            : 'つぶやきの部屋';

    if (path != null) {
      print(path);
      final voice = File.fromUri(Uri.parse(path));
      final remotePath =
          'test/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';
      uploadFile(voice, remotePath);
      await Future.delayed(Duration(seconds: 1));
      sendPost(ref, '',
          roomId: widget.roomId,
          isVoice: true,
          voiceFile: voice,
          voiceCloudPath: remotePath);
      sendPost(ref, '',
          roomId: widget.roomId,
          isVoice: true,
          voiceFile: voice,
          voiceCloudPath: remotePath,
          isvoieCollection: true);
      incrementActivity(ref, 'voice ${roomName}');
      FirebaseCloudMessagingService().sendPushNotification(
          token: token,
          title: 'パートナーが${roomName}で話しています。',
          type: widget.roomId);
      if (user?.isFirstUseVoiceRecording == true && widget.roomId == 'init')
        showCustomSnackBar(context, text: '音声が日常会話の部屋に送られました。');
      updateUserData(ref, field: 'isFirstUseVoiceRecording', value: false);
    }
  }

  Future<void> _cancel() async {
    _timer?.cancel();
    _recordDuration = 0;
    final path = await _audioRecorder.stop();
    if (path != null) {
      print(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.pause();
    _amplitudeSub?.pause();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}




    // Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     // _buildRecordStopControl(),
    //     // const SizedBox(width: 20),
    //     // _buildPauseResumeControl(),
    //     // const SizedBox(width: 20),
    //     // _buildText(),
    //   ],
    // );