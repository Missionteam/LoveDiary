import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class CircleRecordButton extends StatelessWidget {
  const CircleRecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color.fromARGB(255, 48, 185, 53)
          // color: Color.fromARGB(255, 25, 197, 227),
          ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Icon(
          Icons.mic,
          size: 60,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}

class CircleRecordingButton extends StatelessWidget {
  const CircleRecordingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleAnimation(
      color: Color.fromARGB(255, 32, 191, 93),
      repeat: true,
      minRadius: 200,
      ripplesCount: 3,
      duration: Duration(milliseconds: 2500),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromARGB(255, 37, 123, 40)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Icon(
            Icons.mic,
            size: 60,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
