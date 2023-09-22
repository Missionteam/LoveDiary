import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextForm extends StatefulWidget {
  TextForm({
    Key? key,
    required this.formKey,
    required this.text,
    required this.hintText,
    required this.initialValue,
    required this.onSaved,
    this.controller,
    this.fontSize = 24,
    this.topPadding = 20,
    this.width = 300,
    this.color = Colors.white,
  }) : super(key: key);
  String text;
  String hintText;
  String initialValue;
  Color color;
  Key? formKey;
  double fontSize;
  double width;
  double topPadding;
  void Function(String?)? onSaved;
  final TextEditingController? controller;

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Container(
              padding: EdgeInsets.only(top: widget.topPadding, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: widget.color,
                        fontWeight: FontWeight.w600),
                  ),
                  Material(
                    color: Color.fromARGB(0, 255, 214, 64),
                    child: Container(
                      width: widget.width,
                      child: new TextFormField(
                        enabled: true,
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: widget.controller,
                        initialValue: (widget.controller == null)
                            ? widget.initialValue
                            : null,
                        style: GoogleFonts.nunito(
                            color: widget.color,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(169, 72, 72, 72),
                              fontSize: 14,
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
