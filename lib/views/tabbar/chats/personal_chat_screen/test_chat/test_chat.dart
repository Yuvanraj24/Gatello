

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class Privacy extends StatefulWidget {
//   const Privacy({Key? key}) : super(key: key);
//
//   @override
//   State<Privacy> createState() => _PrivacyState();
// }
//
// class _PrivacyState extends State<Privacy> {
//   bool isSwitched = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: (){
//             Navigator.pop(context);
//           },
//           child:  Column(
//             mainAxisAlignment: MainAxisAlignment
//                 .center,
//             crossAxisAlignment: CrossAxisAlignment
//                 .center,
//             children: [
//               SvgPicture.asset(
//                 'assets/pops_asset/back_button.svg',
//                 height: 30.h,
//                 width: 30.w,),
//             ],
//           ),
//         ),
//         title: Text(
//           'Privacy',
//           style: GoogleFonts.inter(
//               textStyle: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w400,
//                   color: Color.fromRGBO(12, 16, 29, 1)
//               )),
//         ),
//
//       //   actions: [PopupMenuButton( itemBuilder: (
//       // BuildContext context) =>[],
//       //
//       //   color: Color.fromRGBO(12, 16, 29, 1),)],
//       ),
//       body: Container(
//         padding: EdgeInsets.only(left: 12.w,right: 23.w,top: 20.h),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Ping privacy',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color.fromRGBO(0, 163, 255, 1)
//                       )),
//                 ),
//               ],
//             ),
//             Row(
//
//               children: [
//                 Text(
//                   'Show online status',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color.fromRGBO(0, 0,0,1)
//                       )),
//                 ),
//                 Spacer(),
//                  Switch(
//                   value: isSwitched,
//                   onChanged: (value) {
//                     setState(() {
//                       isSwitched = value;
//                       print(isSwitched);
//                     });
//                   },
//                    inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
//                      inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
//                   activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
//                   activeColor: Color.fromRGBO(0, 163, 255, 1),
//                 ),
//               ],
//             ),
//             Row(
//
//               children: [
//                 Text(
//                   'Read receipts',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color.fromRGBO(0, 0,0,1)
//                       )),
//                 ),
//                 Spacer(),
//                 Switch(
//                   value: isSwitched,
//                   onChanged: (value) {
//                     setState(() {
//                       isSwitched = value;
//                       print(isSwitched);
//                     });
//                   },
//                   inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
//                   inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
//                   activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
//                   activeColor: Color.fromRGBO(0, 163, 255, 1),
//                 ),
//               ],
//             ),
//             Row(
//
//               children: [
//                 Text(
//                   'Show online status',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color.fromRGBO(0, 0,0,1)
//                       )),
//                 ),
//                 Spacer(),
//                 Switch(
//                   value: isSwitched,
//                   onChanged: (value) {
//                     setState(() {
//                       isSwitched = value;
//                       print(isSwitched);
//                     });
//                   },
//                   inactiveThumbColor:Color.fromRGBO(67, 67, 67, 1) ,
//                   inactiveTrackColor:Color.fromRGBO(217, 217, 217, 1),
//                   activeTrackColor: Color.fromRGBO(0, 163, 255, 0.3),
//                   activeColor: Color.fromRGBO(0, 163, 255, 1),
//                 ),
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:flutter/material.dart';
// class mainApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: chat(),
//     );
//   }
// }
//
// class chat extends StatefulWidget {
//   const chat({Key? key}) : super(key: key);
//
//   @override
//   _chatState createState() => _chatState();
// }
//
// class _chatState extends State<chat> {
//   bool changeClass = false;
//   String? text;
//   changeClassValue(String? newText) {
//     setState(() {
//       changeClass = !changeClass;
//       text = newText;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: changeClass
//           ? container(
//         text: text ?? "",
//       )
//           : textField(
//         changeClassValue: changeClassValue,
//       ),
//     );
//   }
// }
//
// class textField extends StatefulWidget {
//   textField({Key? key, required this.changeClassValue}) : super(key: key);
//
//   ValueChanged<String> changeClassValue;
//
//   @override
//   _textFieldState createState() => _textFieldState();
// }
//
// class _textFieldState extends State<textField> {
//   final textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         children: [
//           Container(
//             width: 300.0,
//             height: 60.0,
//             color: Colors.red,
//             child: TextField(
//               controller: textController,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               widget.changeClassValue(textController.text);
//             },
//             child: Icon(Icons.send),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class container extends StatefulWidget {
//   container({Key? key, required this.text}) : super(key: key);
//
//   String text;
//
//   @override
//   _containerState createState() => _containerState();
// }
//
// class _containerState extends State<container> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 60.0,
//         color: Colors.grey,
//         child: Text(widget.text),
//       ),
//     );
//   }
// }


//
// import 'dart:io';
//
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// /// Example for EmojiPickerFlutter
// class Test extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<Test> {
//   final TextEditingController _controller = TextEditingController();
//   bool emojiShowing = false;
//
//   _onEmojiSelected(Emoji emoji) {
//     print('_onEmojiSelected: ${emoji.emoji}');
//   }
//
//   _onBackspacePressed() {
//     print('_onBackspacePressed');
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('Emoji Picker Example App'),
//         ),
//         body: Column(
//           children: [
//             Expanded(child: Container()),
//             Container(
//                 height: 66.0,
//                 color: Colors.blue,
//                 child: Row(
//                   children: [
//                     Material(
//                       color: Colors.transparent,
//                       child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             emojiShowing = !emojiShowing;
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.emoji_emotions,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: TextFormField(
//                             controller: _controller,
//                             style: const TextStyle(
//                                 fontSize: 20.0, color: Colors.black87),
//                             decoration: InputDecoration(
//                               hintText: 'Type a message',
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.only(
//                                   left: 16.0,
//                                   bottom: 8.0,
//                                   top: 8.0,
//                                   right: 16.0),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(50.0),
//                               ),
//                             )),
//                       ),
//                     ),
//                     Material(
//                       color: Colors.transparent,
//                       child: IconButton(
//                           onPressed: () {
//                             // send message
//                           },
//                           icon: const Icon(
//                             Icons.send,
//                             color: Colors.white,
//                           )),
//                     )
//                   ],
//                 )),
//             Offstage(
//               offstage: !emojiShowing,
//               child: SizedBox(
//                 height: 250,
//                 child: EmojiPicker(
//                     textEditingController: _controller,
//                     onEmojiSelected: (Category category, Emoji emoji) {
//                       _onEmojiSelected(emoji);
//                     },
//                     onBackspacePressed: _onBackspacePressed,
//                     config: Config(
//                         columns: 7,
//                         // Issue: https://github.com/flutter/flutter/issues/28894
//                         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
//                         verticalSpacing: 0,
//                         horizontalSpacing: 0,
//                         gridPadding: EdgeInsets.zero,
//                         initCategory: Category.RECENT,
//                         bgColor: const Color(0xFFF2F2F2),
//                         indicatorColor: Colors.blue,
//                         iconColor: Colors.grey,
//                         iconColorSelected: Colors.blue,
//                         progressIndicatorColor: Colors.blue,
//                         backspaceColor: Colors.blue,
//                         skinToneDialogBgColor: Colors.white,
//                         skinToneIndicatorColor: Colors.grey,
//                         enableSkinTones: true,
//                         showRecentsTab: true,
//                         recentsLimit: 28,
//                         replaceEmojiOnLimitExceed: false,
//                         noRecents: const Text(
//                           'No Recents',
//                           style: TextStyle(fontSize: 20, color: Colors.black26),
//                           textAlign: TextAlign.center,
//                         ),
//                         tabIndicatorAnimDuration: kTabScrollDuration,
//                         categoryIcons: const CategoryIcons(),
//                         buttonMode: ButtonMode.MATERIAL)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
