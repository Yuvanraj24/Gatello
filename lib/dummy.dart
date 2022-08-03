// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class DeleteWidget extends StatefulWidget {
//   @override
//   _DeleteWidgetState createState() => _DeleteWidgetState();
// }
//
// class _DeleteWidgetState extends State<DeleteWidget> {
// //  var currentSection;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//             //  showConfirmationDialog(context);
//               CustomDialog();
//             },
//             child: Text("data"),
//           ),
//         ),
//       ),
//     );
//   }
//
//   showConfirmationDialog(BuildContext context) {
//     showDialog(
//       // barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialog();
//       },
//     );
//   }
// }
//
// class CustomDialog extends StatefulWidget {
//   @override
//   _CustomDialogState createState() => _CustomDialogState();
// }
//
// class _CustomDialogState extends State<CustomDialog> {
//   var _result;
//   int _value = 1;
//   List<bool> _isChecked = [false, false, false];
//
//   bool isChecked = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       insetPadding: EdgeInsets.only(left: 12, right: 12),
//       titlePadding: EdgeInsets.all(0),
//       // title: Text(
//       //   'Mute notifications for...',
//       //   style: GoogleFonts.inter(
//       //       textStyle: TextStyle(
//       //           fontSize: 16.sp,
//       //           fontWeight: FontWeight.w700,
//       //           color: Color.fromRGBO(0, 0, 0, 1))),
//       // ),
//       title: Container(
// //color: Colors.blue,
//         height: 270.h,
//         width: 300.w,
//         padding: EdgeInsets.only(left: 12, top: 12, bottom: 5),
//         // width: MediaQuery.of(context).size.width,
//         // height: MediaQuery.of(context).size.height,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Mute notifications for...',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color.fromRGBO(0, 0, 0, 1))),
//                 ),
//               ],
//             ),
// //
//             SizedBox(
//               height: 38.h,
//               child: RadioListTile(
//                   //  contentPadding: EdgeInsets.all(5),
//                   title: Text(
//                     '1 Hour',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(158, 158, 158, 1))),
//                   ),
//                   value: 1,
//                   groupValue: _result,
//                   onChanged: (value) {
//                     setState(() {
//                       _result = value;
//                     });
//                   }),
//             ),
//             SizedBox(
//               height: 38.h,
//               child: RadioListTile(
//                   title: Text(
//                     '1 Week',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(158, 158, 158, 1))),
//                   ),
//                   value: 2,
//                   groupValue: _result,
//                   onChanged: (value) {
//                     setState(() {
//                       _result = value;
//                     });
//                   }),
//             ),
//             SizedBox(
//               height: 38.h,
//               child: RadioListTile(
//                   title: Text(
//                     'Always',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(158, 158, 158, 1))),
//                   ),
//                   value: 3,
//                   groupValue: _result,
//                   onChanged: (value) {
//                     setState(() {
//                       _result = value;
//                     });
//                   }),
//             ),
//
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 22.w,
//                 ),
//                 Checkbox(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4)),
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       // This is where we update the state when the checkbox is tapped
//                       setState(() {
//                         isChecked = value!;
//                       });
//                     }),
//                 SizedBox(
//                   width: 23.w,
//                 ),
//                 Text(
//                   'Show notification ',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Color.fromRGBO(157, 157, 157, 1))),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(0, 163, 255, 1))),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     'OK',
//                     style: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(255, 0, 0, 1))),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
