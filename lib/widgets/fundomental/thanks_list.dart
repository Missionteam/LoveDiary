import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/function/util_functions.dart';
import 'package:thanks_diary/widgets/fundomental/thanks_menu_dialog.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../models/cloud_storage_model.dart';
import '../../providers/thanks_provider.dart';

class ThanksList extends ConsumerWidget {
  const ThanksList({Key? key, required this.isMine}) : super(key: key);
  final bool isMine;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thanksListAsync = ref.watch(thanksListProvider(isMine));

    return Expanded(
      child: thanksListAsync.when(
        data: (thanksList) {
          final groupedThanks =
              ref.watch(groupedThanksByDateProvider(thanksList));
          final thanksNumber = thanksList.length;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: groupedThanks.keys.length,
            itemBuilder: (context, index) {
              final date = groupedThanks.keys.elementAt(index);
              final thanksForDate = groupedThanks[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: sWidth(context) * 0.5 - 10),
                      NotoText(
                        text: thanksNumber.toString(),
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                      SizedBox(width: 10),
                      NotoText(
                        text: "ありがとう",
                        fontSize: 10,
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Text(DateFormat('MM/dd').format(date)), // 日付の表示
                  ...thanksForDate.map((thanks) {
                    Widget image = (thanks.imageUrl != null)
                        ? ref
                                .watch(imageOfPostProvider(thanks.imageUrl!))
                                .value ??
                            SizedBox()
                        : SizedBox();
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return MenuThanksDialog(thanks: thanks);
                                },
                              );
                            },
                            onDoubleTap: () {
                              thanks.reference.update({'stamps': '❤️'});
                            },
                            child: Stack(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: SizedBox(
                                      width: 300,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                                "images/thanksItem/${thanks.category}",
                                                width: 30),
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                bottom: 16.0,
                                                right: 8.0),
                                            child:
                                                NotoText(text: thanks.message!),
                                          ))
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    right: 5,
                                    bottom: 5,
                                    child: (thanks.stamps != null)
                                        ? Text(thanks.stamps!)
                                        : SizedBox())
                              ],
                            ),
                          ),
                        ),
                        image
                      ],
                    );
                  }), // その日の感謝のメッセージリスト
                ],
              );
            },
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => Text('エラー: $err'),
      ),
    );
  }
}
