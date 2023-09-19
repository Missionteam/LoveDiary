import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';

import '../../models/cloud_storage_model.dart';

class ImageWidget extends ConsumerWidget {
  ImageWidget(this.remotePath,
      {double width = 300, double height = 300, super.key});
  String remotePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget image =
        ref.watch(imageOfPostProvider(this.remotePath)).value ?? SizedBox();

    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return ImageDialog(
                  image: image,
                  remotePath: this.remotePath,
                );
              });
        },
        child: image);
  }
}

class ImageDialog extends StatefulWidget {
  const ImageDialog({
    Key? key,
    required this.image,
    required this.remotePath,
  }) : super(key: key);
  final String remotePath;

  final Widget image;

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  bool? isFocus;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFocus == null) {
            isFocus = true;
          } else {
            isFocus = !isFocus!;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              (isFocus != true)
                  ? SizedBox(
                      height: 36,
                      child: Material(
                        color: AppColors.noColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _getHttp(widget.remotePath);
                              },
                              icon: Icon(
                                Icons.file_download_outlined,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(height: 36),
              Expanded(child: widget.image),
            ],
          )),
    );
  }

  _getHttp(String remotePath) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('images').child(remotePath);
    final imageUrl = await storageRef.getDownloadURL();
    var response = await Dio()
        .get(imageUrl, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "hello");
    print(result);
    _toastInfo("$result");
    // try {
    //   const oneMegabyte = 600 * 600;
    //   final Uint8List? data = await storageRef.getData(oneMegabyte);
    //   if (data == null) {
    //     return Fluttertoast.showToast(msg: '保存に失敗しました');
    //   }
    //   final result = await ImageGallerySaver.saveImage(data, quality: 100);
    //   print(result);
    //   _toastInfo("$result");
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: '保存しました', toastLength: Toast.LENGTH_LONG);
  }
}
