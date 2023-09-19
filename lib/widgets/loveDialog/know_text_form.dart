import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/function/util_functions.dart';

class KnowTextForm extends StatefulWidget {
  KnowTextForm({
    Key? key,
    required this.formKey,
    required this.text,
    required this.hintText,
    required this.initialValue,
    required this.onSaved,
    this.fontSize = 24,
    this.topPadding = 20,
    this.color = Colors.white,
    this.maxline = 3,
  }) : super(key: key);
  String text;
  String hintText;
  String initialValue;
  Color color;
  Key? formKey;
  double fontSize;
  double topPadding;
  int maxline;
  void Function(String?)? onSaved;

  @override
  State<KnowTextForm> createState() => _KnowTextFormState();
}

class _KnowTextFormState extends State<KnowTextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Container(
              padding: EdgeInsets.only(top: widget.topPadding, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: widget.color,
                        size: 14,
                      ),
                      Text(
                        widget.text,
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: widget.color,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Material(
                    color: Color.fromARGB(0, 255, 214, 64),
                    child: Container(
                      width: sWidth(context) * 0.8,
                      child: new TextFormField(
                        enabled: true,
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: widget.maxline,
                        initialValue: widget.initialValue,
                        style: GoogleFonts.nunito(
                            color: widget.color,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(169, 72, 72, 72),
                              fontSize: 12,
                            ),

                            // labelText: '部屋の名前',
                            // labelStyle: TextStyle(
                            //     color: Colors.white, fontSize: 24),
                            filled: true,
                            fillColor: Color.fromARGB(0, 255, 193, 7)),
                        onSaved: widget.onSaved,
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
