import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/util/text.dart';

class KnowCheckBoxList extends ConsumerWidget {
  const KnowCheckBoxList({
    super.key,
    required this.onItemTap,
    this.selectedItemText,
    required this.text,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,
  });
  final Function(String?) onItemTap;
  final String? selectedItemText;
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
                    CheckBox_Text(
                      text: text1,
                      onTap: onItemTap,
                      selectedItemText: selectedItemText,
                    ),
                    CheckBox_Text(
                      text: text2,
                      onTap: onItemTap,
                      selectedItemText: selectedItemText,
                    ),
                    CheckBox_Text(
                      text: text3,
                      onTap: onItemTap,
                      selectedItemText: selectedItemText,
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
                      CheckBox_Text(
                        text: text4,
                        onTap: onItemTap,
                        selectedItemText: selectedItemText,
                      ),
                      CheckBox_Text(
                        text: text5,
                        onTap: onItemTap,
                        selectedItemText: selectedItemText,
                      ),
                      CheckBox_Text(
                        text: text6,
                        onTap: onItemTap,
                        selectedItemText: selectedItemText,
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

class CheckBox_Text extends StatefulWidget {
  const CheckBox_Text({
    Key? key,
    required this.text,
    required this.onTap,
    required this.selectedItemText,
  }) : super(key: key);
  final String text;
  final Function(String?) onTap;
  final String? selectedItemText;

  @override
  State<CheckBox_Text> createState() => _CheckBox_TextState();
}

class _CheckBox_TextState extends State<CheckBox_Text> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.text == widget.selectedItemText;

    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            if (value == true) {
              widget.onTap(widget.text);
            } else {
              widget.onTap(null);
            }
          },
        ),
        NotoText(text: widget.text)
      ],
    );
  }
}
