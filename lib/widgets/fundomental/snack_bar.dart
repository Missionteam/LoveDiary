import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar(
  BuildContext context, {
  required String text,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Color.fromARGB(255, 212, 212, 212),
  ));
}










// ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar(
//     BuildContext context,
//     {required String text,
//     double paddingSWidthParcent = 0.1,
//     double bottomPadding = 20}) {
//   return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     margin: EdgeInsetsDirectional.only(
//         bottom: bottomPadding,
//         start: sWidth(context) * paddingSWidthParcent,
//         end: sWidth(context) * paddingSWidthParcent),
//     content: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black),
//         )),
//     behavior: SnackBarBehavior.floating,
//     onVisible: () {
//       print('snackbar was shown');
//     },
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(60),
//     ),
//     backgroundColor: Color.fromARGB(197, 192, 192, 192),
//     clipBehavior: Clip.hardEdge,
//     dismissDirection: DismissDirection.horizontal,
//     elevation: 0,
//   ));
// }
