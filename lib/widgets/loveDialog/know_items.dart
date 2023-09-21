import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/models/loveCategory_model.dart';
import 'package:thanks_diary/widgets/util/text.dart';

class KnowItemList extends ConsumerWidget {
  const KnowItemList({
    super.key,
    required this.onItemTap,
    this.selectedReason,
    required this.text,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,
  });
  final Function(LoveReason?) onItemTap;
  final LoveReason? selectedReason;
  final String text;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 14,
              ),
              Text(
                text,
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: sWidth(context) * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LoveItem(
                      imgPath: "time.png",
                      text: text1,
                      onTap: onItemTap,
                      selectedReason: selectedReason,
                      loveReason: LoveReason.kindness,
                    ),
                    LoveItem(
                      imgPath: "word.png",
                      text: text2,
                      onTap: onItemTap,
                      selectedReason: selectedReason,
                      loveReason: LoveReason.entertaining,
                    ),
                    LoveItem(
                      imgPath: "houseWork.png",
                      text: text3,
                      onTap: onItemTap,
                      selectedReason: selectedReason,
                      loveReason: LoveReason.calm,
                    ),
                  ],
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
                        text: text4,
                        onTap: onItemTap,
                        selectedReason: selectedReason,
                        loveReason: LoveReason.cool,
                      ),
                      LoveItem(
                        imgPath: "goOut.png",
                        text: text5,
                        onTap: onItemTap,
                        selectedReason: selectedReason,
                        loveReason: LoveReason.cute,
                      ),
                      LoveItem(
                        imgPath: "skinsip.png",
                        text: text6,
                        onTap: onItemTap,
                        selectedReason: selectedReason,
                        loveReason: LoveReason.hear,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
          side: BorderSide(color: Colors.black, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        NotoText(text: widget.text)
      ],
    );
  }
}
