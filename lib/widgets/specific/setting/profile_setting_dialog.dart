import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thanks_diary/providers/auth_provider.dart';

import '../../../models/cloud_storage_model.dart';
import '../../../pages/auth/register.dart';
import '../../../providers/talkroom_provider.dart';
import '../../../providers/users_provider.dart';

class MyProfileSettingPage extends ConsumerStatefulWidget {
  const MyProfileSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyProfileSettingPageState();
}

class _MyProfileSettingPageState extends ConsumerState<MyProfileSettingPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String imageLocalPath = '';
  String imageCloudPath = '';
  File? imageFile;

  RadioValue _gValue = RadioValue.FIRST;
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserDoc = ref.watch(CurrentAppUserDocProvider).value;
    final partnerUseDoc = ref.watch(partnerUserDocProvider).value;
    final uid = ref.watch(uidProvider);
    final String partnerName =
        partnerUseDoc?.get('displayName') ?? '恋人が登録されていません。';
    final String currentUserImageName =
        currentUserDoc?.get('photoUrl') ?? 'Girl';
    final String currentUserName =
        currentUserDoc?.get('displayName') ?? 'お名前を登録してください。';
    final talkroomId = ref.watch(talkroomIdProvider).value;
    final imageUrl = ref.watch(imageUrlProvider(imageCloudPath)).value;

    void _submission() {
      if (this._formKey.currentState!.validate()) {
        this._formKey.currentState!.save();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.chevron_left_outlined,
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
          ],
        ),
        backgroundColor: Color.fromARGB(0, 250, 250, 250),
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          '個人設定',
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 60, right: 60, bottom: 20),
                    child: new TextFormField(
                      enabled: true,
                      maxLength: 20,
                      obscureText: false,
                      initialValue: currentUserName,
                      decoration: const InputDecoration(
                        hintText: 'お名前を教えてください',
                        labelText: '名前 ',
                      ),
                      onSaved: (String? value) {
                        this._name = value ?? '';
                      },
                    ))),
            SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: () {
                  bool isGirl = (_gValue == RadioValue.FIRST) ? true : false;
                  String userimage = (isGirl == true) ? 'Girl' : 'Boy';
                  _submission();
                  ref.watch(currentAppUserDocRefProvider).update({
                    'displayName': this._name,
                    'photoUrl': userimage,
                    'isGirl': isGirl
                  });

                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  fixedSize: Size(150, 40),
                ),
                child: Text(
                  '保存',
                  style: GoogleFonts.nunito(
                      // color: Color.fromARGB(255, 243, 243, 243)),
                      color: Colors.white),
                )),
          ]),
        ),
      ),
    );
  }
}
