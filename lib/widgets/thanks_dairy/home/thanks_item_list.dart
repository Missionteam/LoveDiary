import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/widgets/util/text.dart';

class ThanksItemList extends ConsumerWidget {
  const ThanksItemList(
      {super.key, required this.onItemTap, this.selectedItemPath});
  final Function(String) onItemTap;
  final String? selectedItemPath;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 3,
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: <Widget>[
          ThanksItem(
            imgPath: "time.png",
            text: "ふたり時間",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "word.png",
            text: "プラスの言葉",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "houseWork.png",
            text: "家事",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "present.png",
            text: "プレゼント",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "myTime.png",
            text: "ひとりじかん",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "goOut.png",
            text: "おでかけ",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "skinsip.png",
            text: "スキンシップ",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
          ThanksItem(
            imgPath: "others.png",
            text: "その他",
            onTap: onItemTap,
            selectedPath: selectedItemPath,
          ),
        ],
      ),
    );
  }
}

class ThanksItem extends StatefulWidget {
  const ThanksItem({
    Key? key,
    required this.imgPath,
    required this.text,
    required this.onTap,
    required this.selectedPath,
  }) : super(key: key);
  final String imgPath;
  final String text;
  final Function(String) onTap;
  final String? selectedPath;

  @override
  State<ThanksItem> createState() => _ThanksItemState();
}

class _ThanksItemState extends State<ThanksItem> {
  @override
  Widget build(BuildContext context) {
    const imgPrePath = "images/thanksItem/";
    final isSelected = widget.imgPath == widget.selectedPath;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            widget.onTap(widget.imgPath);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Color.fromARGB(255, 70, 118, 82), width: 1.5), // 外枠
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 111, 111, 111).withOpacity(0.5),
                  spreadRadius: 1.3,
                  blurRadius: 3,
                  offset: Offset(4, 3), // 右下の影
                ),
              ],
              color:
                  isSelected ? Color.fromARGB(131, 69, 255, 112) : Colors.white,
            ),
            child: Center(
              child: Image.asset(
                "${imgPrePath}${widget.imgPath}",
                width: 30,
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        NotoText(
          text: widget.text,
          fontSize: 12,
        )
      ],
    );
  }
}
