import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StampView extends ConsumerStatefulWidget {
  StampView({
    Key? key,
    required this.stampName,
  }) : super(key: key);
  final String stampName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StampViewState();
}

class _StampViewState extends ConsumerState<StampView>
    with TickerProviderStateMixin {
  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(milliseconds: 300),
  //   vsync: this,
  // )..repeat(reverse: true);
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.easeIn,
  // );

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1200), () {
      Navigator.of(context).pop();
    });
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 250, left: 70, right: 70, top: 200),
        child: Container(
          color: Colors.white,
          child: FadeTransition(
            opacity: _animation,
            child: MaterialButton(
                elevation: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/${widget.stampName}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ),
    );
  }
}
