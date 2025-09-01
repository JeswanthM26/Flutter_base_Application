// // lib/ui/components/native_dialogs.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// void showNativeDialog(
//   BuildContext context,
//   String title,
//   String message,
//   String cancelText,
//   String okText,
// ) {
//   if (Theme.of(context).platform == TargetPlatform.iOS) {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             CupertinoDialogAction(
//               child: Text(cancelText),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             CupertinoDialogAction(
//               child: Text(okText),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Navigate to dashboard
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: Text(cancelText),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: Text(okText),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Navigate to dashboard
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
