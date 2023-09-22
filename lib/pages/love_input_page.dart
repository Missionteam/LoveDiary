import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/function/send_love.dart';
import 'package:thanks_diary/widgets/loveDialog/dialog/save_love_content.dart';
import 'package:thanks_diary/widgets/loveDialog/love_item_list.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../function/update_love.dart';
import '../models/cloud_storage_model.dart';
import '../models/love.dart';
import '../models/loveCategory_model.dart';
import '../providers/users_provider.dart';
import '../widgets/thanks_dairy/home/add_picture.dart';
import '../widgets/util/dialog.dart';
import '../widgets/util/text_form.dart';

class LoveInputPage extends ConsumerStatefulWidget {
  LoveInputPage({Key? key, this.love}) : super(key: key);
  Love? love;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InputPageState();
}

class InputPageState extends ConsumerState<LoveInputPage> {
  final formKey = GlobalKey<FormState>();
  LoveReason? selectedItemPath;
  String? memo;
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  void _handleItemTap(LoveReason? loveReason) {
    setState(() {
      selectedItemPath = loveReason;
    });
  }

  @override
  void initState() {
    super.initState();
    this.selectedItemPath = widget.love?.loveReason;
    this.memo = widget.love?.message;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partnerName =
        ref.watch(CurrentAppUserDocProvider).value?.data()?.partnerName ?? "恋人";
    Widget image = (widget.love?.imageUrl != null)
        ? ref.watch(imageOfPostProvider(widget.love!.imageUrl!)).value ??
            SizedBox()
        : SizedBox();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColors.main,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined,
                  color: Color.fromARGB(255, 18, 105, 4), size: 20),
            ),
            backgroundColor: AppColors.appbar,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  SizedBox(height: 10),
                  NotoText(
                    text: partnerName + "の好きなところを記入しよう",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 26),
                  LoveItemList(
                    onItemTap: _handleItemTap,
                    selectedReason: selectedItemPath,
                  ),
                  SizedBox(height: 26),
                  TextForm(
                      formKey: formKey,
                      text: "ひとこと",
                      hintText: "（例）レンタカー予約してくれた、最高）",
                      initialValue: widget.love?.message ?? "",
                      color: Color.fromARGB(255, 28, 28, 28),
                      fontSize: 12,
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
                  SizedBox(height: 20),
                  (imageFile != null)
                      ? SizedBox(height: 200, child: Image.file(imageFile!))
                      : SizedBox(),
                  image,
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                      if (selectedItemPath == null) {
                      } else if (widget.love == null) {
                        sendLove(
                          ref,
                          selectedItemPath!,
                          messege: memo,
                          imageCloudPath: imageCloudPath,
                          imageFile: imageFile,
                        );
                      } else {
                        updateLove(
                            ref, widget.love!.reference, selectedItemPath!,
                            messege: memo,
                            imageCloudPath: widget.love?.imageUrl);
                      }

                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => BaseDialog(
                                onButtonPressd: () {},
                                buttonExist: false,
                                color: Colors.white,
                                closeIconExist: true,
                                children: [
                                  SaveLoveContent(
                                      text: this.memo ?? "好きなとこ書いてみた！")
                                ],
                              ));
                    },
                    child: Text("保存"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(260, 40),
                      shape: const StadiumBorder(),
                    ),
                  ),
                  SizedBox(height: 40)
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