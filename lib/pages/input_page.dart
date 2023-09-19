import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/send_thanks.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../models/cloud_storage_model.dart';
import '../widgets/thanks_dairy/home/add_picture.dart';
import '../widgets/thanks_dairy/home/thanks_item_list.dart';
import '../widgets/util/text_form.dart';

class InputPage extends ConsumerStatefulWidget {
  InputPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InputPageState();
}

class InputPageState extends ConsumerState<InputPage> {
  final formKey = GlobalKey<FormState>();
  String? _selectedItemPath;
  String? memo;
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  void _handleItemTap(String imgPath) {
    setState(() {
      _selectedItemPath = imgPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        child: Container(
          color: AppColors.main,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconButton(
                          onPressed: () {
                            GoRouter.of(context).push('/Home1');
                          },
                          icon: Icon(Icons.arrow_back_ios_new_outlined,
                              color: Color.fromARGB(255, 18, 105, 4), size: 20),
                        ),
                      )),
                  SizedBox(height: 10),
                  NotoText(
                    text: "なにが嬉しかった？",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 26),
                  ThanksItemList(
                    onItemTap: _handleItemTap,
                    selectedItemPath: _selectedItemPath,
                  ),
                  SizedBox(height: 26),
                  TextForm(
                      formKey: formKey,
                      text: "ひとこと",
                      hintText: "",
                      initialValue: "",
                      color: Color.fromARGB(255, 28, 28, 28),
                      fontSize: 14,
                      onSaved: (String? value) {
                        this.memo = value;
                      }),
                  SizedBox(height: 20),
                  AddPicture(
                      onTap: (File image, String imageRemotePath) => {
                            setState(() {
                              this.imageFile = image;
                              if (imageFile != null) {
                                uploadFile(imageFile!, imageRemotePath);
                                imageCloudPath = imageRemotePath;
                              }
                            })
                          }),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      if (_selectedItemPath != null)
                        sendThanks(
                          ref,
                          _selectedItemPath!,
                          text: memo,
                          imageCloudPath: imageCloudPath,
                          imageFile: imageFile,
                        );
                      GoRouter.of(context).push('/Home1/');
                    },
                    child: Text("保存"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(260, 40),
                      shape: const StadiumBorder(),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });