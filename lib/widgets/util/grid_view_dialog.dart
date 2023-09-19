import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridViewDialog extends ConsumerStatefulWidget {
  GridViewDialog(
      {Key? key,
      this.Screenpadding =
          const EdgeInsets.only(bottom: 190, left: 20, right: 20, top: 140),
      required this.children})
      : super(key: key);
  EdgeInsetsGeometry Screenpadding;
  List<Widget> children;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GridViewDialogState();
}

class _GridViewDialogState extends ConsumerState<GridViewDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: widget.Screenpadding,
        child: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 50),
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
