import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/widgets/fundomental/know_view_item.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../providers/users_provider.dart';

class KnowViewPage extends ConsumerStatefulWidget {
  KnowViewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageContentState();
}

class HomePageContentState extends ConsumerState<KnowViewPage> {
  final formKey = GlobalKey<FormState>();
  bool isMine = false;

  @override
  Widget build(BuildContext context) {
    final currentUserDoc = ref.watch(CurrentAppUserDocProvider).value;
    final partnerUserDoc = ref.watch(partnerUserDocProvider).value;
    final String currentUserName = currentUserDoc?.get('displayName') ?? '未登録';
    final String partnerUserName = partnerUserDoc?.get('displayName') ?? '未登録';
    return Scaffold(
      backgroundColor: AppColors.main,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        elevation: 3,
        centerTitle: true,
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              NotoText(
                text: "2023年 9月",
                fontSize: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.expand_more),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: KnowViewItem(),
      ),
    );
  }
}

// final memoFormKeyProvider = Provider((ref) {
//   final formKey = GlobalKey<FormState>();
//   return formKey;
// });