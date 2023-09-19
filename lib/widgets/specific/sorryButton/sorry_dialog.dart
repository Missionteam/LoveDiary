import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/gage_model.dart';
import '../../util/grid_view_dialog.dart';

class SorryGirdDialog extends ConsumerStatefulWidget {
  const SorryGirdDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SorryGirdDialogState();
}

class _SorryGirdDialogState extends ConsumerState<SorryGirdDialog> {
  @override
  Widget build(BuildContext context) {
    return GridViewDialog(
      children: [
        TextButton(
          onPressed: () {
            ref.watch(GageProvider.notifier).IncrementGage();
            // ref.invalidate(GageProvider);
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.grey[100],
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'ごめんねを\n伝える。',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 90, 90, 90),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            '返信できる\n時間を伝える。',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
        Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            '今何してるを\n伝える。',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
        Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            'ごめんねを\n行動で伝える。',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
      ],
    );
  }
}
