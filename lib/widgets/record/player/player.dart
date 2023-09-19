import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/cloud_storage_model.dart';

import '../../../allConstants/color_constants.dart';
import '../../util/text.dart';

class AudioPlayer extends ConsumerStatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;
  final bool isMine;
  final bool isTweet;

  const AudioPlayer({
    Key? key,
    required this.source,
    required this.onDelete,
    required this.isMine,
    this.isTweet = false,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends ConsumerState<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = ref.watch(imageUrlProvider(widget.source)).value;
    if (url != null) _audioPlayer.setSourceUrl(url);

    final reaveTime = (_duration != null && _position != null)
        ? _duration! - _position!
        : null;
    final reaveTimeText = (reaveTime != null)
        ? reaveTime.inMinutes.toString().padLeft(2, '0') +
            ':' +
            (reaveTime.inSeconds % 60).toString().padLeft(2, '0')
        : '';
    final durationText = (_duration != null)
        ? _duration!.inMinutes.toString().padLeft(2, '0') +
            ':' +
            (_duration!.inSeconds % 60).toString().padLeft(2, '0')
        : '';
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          // color: Color.fromARGB(255, 148, 235, 251),

          color: (widget.isTweet == false)
              ? Color.fromARGB(131, 74, 233, 79)
              : AppColors.noColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _buildControl(url),
          // _buildCustomSlider(200),
          SizedBox(width: 10),
          NotoText(
            text: (reaveTime != null) ? reaveTimeText : durationText,
            topPadding: 10,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  Widget _buildControl(String? url) {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause_rounded,
          color: Color.fromARGB(255, 0, 0, 0), size: 30);
      color = Colors.red.withOpacity(0.0);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow_rounded, color: Colors.black, size: 30);
      color = theme.primaryColor.withOpacity(0.0);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play(url);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCustomSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
        child: CustomSlider(
            value: canSetValue && duration != null && position != null
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0,
            onChanged: (v) {
              if (duration != null) {
                final position = v * duration.inMilliseconds;
                _audioPlayer.seek(Duration(milliseconds: position.round()));
              }
            }));
  }

  Future<void> play(String? url) {
    if (url == null) {
      return _audioPlayer.stop();
    }
    ;
    return _audioPlayer.play(
        // kIsWeb ?
        ap.UrlSource(url)
        //:
        // ap.DeviceFileSource(widget.source),
        );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}

class PostDeleteButton extends StatelessWidget {
  PostDeleteButton({
    Key? key,
    required this.onDelete,
  }) : super(key: key);
  void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.delete, color: Color(0xFF73748D), size: 20),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 231, 239),
              title: NotoText(
                text: 'メッセージの削除',
                fontSize: 18,
              ),
              content: NotoText(text: 'このメッセージを削除してよろしいですか？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
  }
}

class RoomDeleteButton extends StatelessWidget {
  RoomDeleteButton({
    Key? key,
    required this.onDelete,
  }) : super(key: key);
  void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.delete, color: Color(0xFF73748D), size: 20),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 231, 239),
              title: NotoText(
                text: 'メッセージの削除',
                fontSize: 18,
              ),
              content: NotoText(text: 'このルームを削除してよろしいですか？トーク内容も全て削除されます。'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
  }
}

class IconAudioPlayer extends ConsumerStatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;
  final bool isMine;

  const IconAudioPlayer({
    Key? key,
    required this.source,
    required this.onDelete,
    required this.isMine,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IconAudioPlayerState();
}

class _IconAudioPlayerState extends ConsumerState<IconAudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = ref.watch(imageUrlProvider(widget.source)).value;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildControl(url),
            // widget.isMine
            //     ? IconButton(
            //         icon: const Icon(Icons.delete,
            //             color: Color(0xFF73748D), size: _deleteBtnSize),
            //         onPressed: () async {
            //           await stop();
            //           showDialog(
            //             context: context,
            //             builder: (_) => AlertDialog(
            //               backgroundColor: Color.fromARGB(255, 255, 231, 239),
            //               title: NotoText(
            //                 text: 'メッセージの削除',
            //                 fontSize: 18,
            //               ),
            //               content: NotoText(text: 'このメッセージを削除してよろしいですか？'),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     int count = 0;
            //                     Navigator.of(context, rootNavigator: true)
            //                         .pop();
            //                   },
            //                   child: const Text('Cancel'),
            //                 ),
            //                 TextButton(
            //                   onPressed: widget.onDelete,
            //                   child: const Text('OK'),
            //                 ),
            //               ],
            //             ),
            //           );
            //         })
            //     : SizedBox(),
          ],
        );
      },
    );
  }

  Widget _buildControl(String? url) {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.volume_up, color: Colors.black, size: 36);
      color = AppColors.noColor;
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play(url);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play(String? url) {
    if (url == null) {
      return _audioPlayer.stop();
    }
    ;
    return _audioPlayer.play(
        // kIsWeb ?
        ap.UrlSource(url)
        //:
        // ap.DeviceFileSource(widget.source),
        );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}

class CustomSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  CustomSlider({required this.value, required this.onChanged});

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  static const int _barCount = 14;
  static const double _barWidth = 3;
  static const double _sliderWidth = 80;
  static const double _sliderHight = 36;

  double _position = 0.5;

  @override
  void initState() {
    super.initState();
    _position = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _position = widget.value;
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final newValue = _position + dx / _sliderWidth;
    if (newValue < 0) {
      _position = 0;
    } else if (newValue > 1) {
      _position = 1;
    } else {
      _position = newValue;
    }
    widget.onChanged?.call(_position);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      child: CustomPaint(
        painter: _SliderPainter(
          barCount: _barCount,
          barWidth: _barWidth,
          sliderHight: _sliderHight,
          sliderWidth: _sliderWidth,
          position: _position,
        ),
        size: Size(_sliderWidth, _sliderHight),
      ),
    );
  }
}

class _SliderPainter extends CustomPainter {
  final int barCount;
  final double barWidth;
  final double sliderHight;
  final double sliderWidth;
  final double position;

  _SliderPainter({
    required this.barCount,
    required this.barWidth,
    required this.sliderHight,
    required this.sliderWidth,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = barWidth;
    final paintBlack = Paint()
      ..color = Color.fromARGB(255, 0, 0, 0)
      ..strokeWidth = barWidth;
    final sliderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = barWidth;

    final barHeight = (sliderWidth - barWidth * (barCount - 1)) / barCount;
    final startX = (barHeight + barWidth) * 0.5;
    for (int i = 0; i < barCount; i++) {
      final x = startX + i * (barHeight + barWidth) * 0.9;
      final barHight = list[i] * 1.8;
      canvas.drawLine(
        Offset(x, 18 - barHight),
        Offset(x, 18 + barHight),
        (position * sliderWidth < x) ? paint : paintBlack,
      );
    }

    // final sliderX = position * (sliderWidth - barWidth) + startX;
    // canvas.drawLine(
    //   Offset(sliderX, 0),
    //   Offset(sliderX, sliderHight),
    //   sliderPaint,
    // );
  }

  @override
  bool shouldRepaint(_SliderPainter oldDelegate) {
    return oldDelegate.position != position;
  }

  static const List<double> list = [
    3,
    6,
    4,
    3,
    8,
    4,
    7,
    9,
    10,
    3,
    5,
    7,
    5,
    4,
    8,
    4,
    9
  ];
}
