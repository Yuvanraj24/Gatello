// import 'package:flutter/material.dart';
// import 'package:wp_search_bar/wp_search_bar.dart';
//
// class Testing extends StatefulWidget {
//   //const Testing({Key? key}) : super(key: key);
//
//   @override
//   State<Testing> createState() => _TestingState();
// }
//
// class _TestingState extends State<Testing> {
//   List<Map<String, String>> data = [
//     {'name': "Mohammad", 'message': "message from mhammad"},
//     {'name': "Kamel", 'message': "message from kamel"},
//     {'name': "Nadine", 'message': "how are you ?"},
//     {'name': "Joseph", 'message': "hello...!"},
//     {'name': "71966691", 'message': "Hi"},
//     {'name': "03405609", 'message': "hiiii...."},
//     {'name': "Mohammad", 'message': "message from mhammad"},
//     {'name': "Kamel", 'message': "message from kamel"},
//     {'name': "Nadine", 'message': "how are you ?"},
//     {'name': "Joseph", 'message': "hello...!"},
//     {'name': "71966691", 'message': "Hi"},
//     {'name': "03405609", 'message': "hiiii...."},
//   ];
//   var buttonFilters = {
//     'name': {
//       'name': 'name',
//       'selected': false,
//       'title': 'Name',
//       'operation': 'CONTAINS',
//       'icon': Icons.photo_size_select_actual_outlined,
//
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },
//     'message': {
//       'name': 'message',
//       'selected': false,
//       'title': 'Message',
//       'operation': 'CONTAINS',
//       'icon': Icons.videocam,
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },
//     'date': {
//       'name': 'Date',
//       'selected': false,
//       'title': 'Date',
//       'operation': 'CONTAINS','icon': Icons.link,
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },
//     'other': {
//       'name': 'other',
//       'selected': false,
//       'title': 'Other',
//       'operation': 'CONTAINS',
//       'icon': Icons.gif_outlined,
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },
//     'other': {
//       'name': 'other',
//       'selected': false,
//       'title': 'Other',
//       'operation': 'CONTAINS',
//       'icon': Icons.headphones_outlined,
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },    'other': {
//       'name': 'other',
//       'selected': false,
//       'title': 'Other',
//       'operation': 'CONTAINS',
//       'icon': Icons.file_copy_sharp,
//       'image':'assets/per_chat_icons/dp_image.svg'
//     },
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: WPSearchBar(
//         listOfFilters: buttonFilters,
//         materialDesign: const {
//           'title': {'text': 'WhatsApp'},
//         },
//         onSearch: (filter, value, operation) {},
//
//         // body: Container(
//         //   decoration: const BoxDecoration(color: Color(0xff121b22)),
//         //   child: ListView.builder(
//         //       itemCount: data.length,
//         //       itemBuilder: (context, index) {
//         //         var item = data[index];
//         //         return ListTile(
//         //           title: Text(
//         //             item['name'].toString(),
//         //             style: const TextStyle(
//         //                 color: Colors.white, fontWeight: FontWeight.bold),
//         //           ),
//         //         );
//         //       }),
//         // ),
//       ),
//     );
//   }
// }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold();
// //   }
// // }
