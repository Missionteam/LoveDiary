import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/cloud_storage_model.dart';
import '../../../providers/talkroom_provider.dart';
import '../../util/text.dart';

class AddPicture extends ConsumerWidget {
  const AddPicture({super.key, required this.onTap});
  final void Function(File image, String imagePath) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talkroomId = ref.watch(talkroomIdProvider).value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NotoText(
        //   text: "写真",
        //   fontWeight: FontWeight.w500,
        // ),
        ElevatedButton(
          onPressed: () async {
            final image = await select_icon(context);
            final imageRemotePath =
                '${talkroomId}/${DateFormat('MMddHH:mm:ssSSS').format(Timestamp.now().toDate())}';
            if (image != null) {
              onTap(image, imageRemotePath);
            }
          },
          child: NotoText(
            text: "写真を追加",
            fontSize: 10,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(200, 30),
            shape: const StadiumBorder(),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
