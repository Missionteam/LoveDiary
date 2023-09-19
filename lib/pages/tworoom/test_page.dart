import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/record/player/player.dart';

class TestPage extends ConsumerStatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TestPageState();
}

class TestPageState extends ConsumerState<TestPage> {
  double _sliderValue = 0.5;
  double _timerValue = 0.5; // タイマーの値

  void _updateTimerValue(double newValue) {
    setState(() {
      _timerValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomSlider(
        value: _timerValue,
        onChanged: (value) {
          setState(() {
            _sliderValue = value;
          });
        },
      ),
    );
  }
}

List<int> bars = [];

class SliderSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<SliderSample> {
  static const barWidth = 5.0;
  double bar1Position = 60.0;
  double bar2Position = 180.0;

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: bars.map((int height) {
                Color color =
                    i >= bar1Position / barWidth && i <= bar2Position / barWidth
                        ? Colors.deepPurple
                        : Colors.blueGrey;
                i++;

                return Container(
                  color: color,
                  height: height.toDouble(),
                  width: 5.0,
                );
              }).toList(),
            ),
            Bar(
              position: bar2Position,
              callback: (DragUpdateDetails details) {
                setState(() {
                  bar2Position += details.delta.dx;
                });
              },
            ),
            Bar(
              position: bar1Position,
              callback: (DragUpdateDetails details) {
                setState(() {
                  bar1Position += details.delta.dx;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final double position;
  final GestureDragUpdateCallback callback;

  Bar({required this.position, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: position >= 0.0 ? position : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        child: Container(
          color: Colors.red,
          height: 200.0,
          width: 5.0,
        ),
      ),
    );
  }
}
