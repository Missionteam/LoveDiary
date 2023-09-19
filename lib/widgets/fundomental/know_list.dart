import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/pages/know_input_page.dart';
import 'package:thanks_diary/widgets/util/text.dart';

import '../../models/cloud_storage_model.dart';
import '../../providers/know_provider.dart';

class KnowList extends ConsumerWidget {
  const KnowList({Key? key, required this.isMine}) : super(key: key);
  final bool isMine;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thanksListAsync = ref.watch(knowListProvider(isMine));

    return thanksListAsync.when(
      data: (thanksList) {
        final groupedKnow = ref.watch(groupedKnowByDateProvider(thanksList));
        final thanksNumber = thanksList.length;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: groupedKnow.keys.length,
          itemBuilder: (context, index) {
            final date = groupedKnow.keys.elementAt(index);
            final knowForDate = groupedKnow[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...knowForDate.map((know) {
                  Widget image = (know.imageUrl != null)
                      ? ref.watch(imageOfPostProvider(know.imageUrl!)).value ??
                          SizedBox()
                      : SizedBox();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return KnowInputPage(know: know);
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(2, 4), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                NotoText(
                                    text: DateFormat('d日(E)', 'ja_JP')
                                        .format(date),
                                    fontSize: 20),
                                Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromARGB(
                                            255, 52, 52, 52), // 下線の色を指定
                                        width: 1.0, // 下線の幅を指定
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, bottom: 26.0, right: 8.0),
                                    child: NotoText(
                                        textAlign: TextAlign.center,
                                        text: know.talk),
                                  ),
                                ),
                                image
                              ],
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                width: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: AppColors.buttonGreen),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }), // その日の感謝のメッセージリスト
              ],
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('エラー: $err'),
    );
  }
}
