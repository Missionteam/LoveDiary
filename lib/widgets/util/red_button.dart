import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../allConstants/color_constants.dart';

class RedButton extends ConsumerWidget {
  RedButton({Key? key, required this.text}) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.red, borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 18),
          child: Text(
            text,
            style: GoogleFonts.nunito(
                // color: Color.fromARGB(255, 243, 243, 243)),
                color: Colors.white),
          ),
        ));
  }
}
