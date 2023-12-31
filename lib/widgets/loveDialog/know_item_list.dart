import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/models/loveCategory_model.dart';
import 'package:thanks_diary/widgets/util/text.dart';

class KnowItemList extends ConsumerWidget {
  const KnowItemList(
      {super.key,
      required this.onItemTap,
      this.selectedReason,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.text5,
      required this.text6});
  final Function(LoveReason?) onItemTap;
  final LoveReason? selectedReason;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: SizedBox(
              width: sWidth(context) * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LoveItem(
                    imgPath: "time.png",
                    text: "優しい",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.kindness,
                  ),
                  LoveItem(
                    imgPath: "word.png",
                    text: "面白い",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.entertaining,
                  ),
                  LoveItem(
                    imgPath: "houseWork.png",
                    text: "落ち着く",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.calm,
                  ),
                  LoveItem(
                    imgPath: "present.png",
                    text: "仕事できる",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.work,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: sWidth(context) * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoveItem(
                    imgPath: "myTime.png",
                    text: "かっこいい",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.cool,
                  ),
                  LoveItem(
                    imgPath: "goOut.png",
                    text: "かわいい",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.cute,
                  ),
                  LoveItem(
                    imgPath: "skinsip.png",
                    text: "聞き上手",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.hear,
                  ),
                  LoveItem(
                    imgPath: "others.png",
                    text: "その他",
                    onTap: onItemTap,
                    selectedReason: selectedReason,
                    loveReason: LoveReason.other,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoveItem extends StatefulWidget {
  const LoveItem({
    Key? key,
    required this.imgPath,
    required this.text,
    required this.onTap,
    required this.selectedReason,
    required this.loveReason,
  }) : super(key: key);
  final String imgPath;
  final String text;
  final Function(LoveReason?) onTap;
  final LoveReason? selectedReason;
  final LoveReason loveReason;

  @override
  State<LoveItem> createState() => _LoveItemState();
}

class _LoveItemState extends State<LoveItem> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.loveReason == widget.selectedReason;

    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            if (value == true) {
              widget.onTap(widget.loveReason);
            } else {
              widget.onTap(null);
            }
          },
          activeColor: widget.loveReason.color,
          side: BorderSide(color: widget.loveReason.color, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        NotoText(text: widget.loveReason.reason)
      ],
    );
  }
}
