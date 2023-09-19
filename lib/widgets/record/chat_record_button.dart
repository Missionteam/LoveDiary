import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';

// class ChatRecordingButton extends StatelessWidget {
//   const ChatRecordingButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: 140,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30.0),
//         color: AppColors.red,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(
//               Icons.mic,
//               color: Color.fromARGB(255, 37, 151, 245),
//             ),
//             Text(
//               '         録音中',
//               style: GoogleFonts.nunito(
//                   // color: Color.fromARGB(255, 243, 243, 243)),
//                   color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChatRecordingButton extends StatelessWidget {
  const ChatRecordingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleAnimation(
      color: Color.fromARGB(255, 216, 171, 171),
      repeat: true,
      minRadius: 100,
      ripplesCount: 3,
      duration: Duration(milliseconds: 2500),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromARGB(255, 221, 183, 183),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
          child: Icon(
            Icons.mic,
            size: 30,
            color: Color.fromARGB(255, 21, 37, 41),
          ),
        ),
      ),
    );
  }
}

class ChatRecordButton extends StatelessWidget {
  const ChatRecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: AppColors.main,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
        child: Icon(
          Icons.mic,
          size: 30,
          color: Color.fromARGB(255, 21, 37, 41),
        ),
      ),
    );
  }
}
