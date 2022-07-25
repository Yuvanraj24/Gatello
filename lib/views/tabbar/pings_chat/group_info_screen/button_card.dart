// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'package:google_fonts/google_fonts.dart';
//
// import 'group_info_list_model.dart';
// class ButtonCard1 extends StatelessWidget {
//   const ButtonCard1({Key?  key,required this.contacts}) : super(key: key);
//
// final GroupContactModel contacts;
//   @override
//   Widget build(BuildContext context) {
//     return
//                  Padding(
//                           padding: EdgeInsets.all(6),
//                    child: ListTile(
//                     leading: Container(
//                       height: 44.h,
//                       width: 44.w,
//
//
//                       child: SvgPicture.asset( contacts.dp),
//                     ),
//                     title: Text(
//                    contacts.name,
//                       style: GoogleFonts.inter(
//                           textStyle: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Color.fromRGBO(0, 0, 0, 1))),
//                     ),
//
//                                  ),
//                  );
//   }
// }

//
//
// import 'package:flutter/material.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
// //Step 3
//   _HomeScreenState() {
//     _filter.addListener(() {
//       if (_filter.text.isEmpty) {
//         setState(() {
//           _searchText = "";
//           filteredNames = names;
//         });
//       } else {
//         setState(() {
//           _searchText = _filter.text;
//         });
//       }
//     });
//   }
//
// //Step 1
//   final TextEditingController _filter = new TextEditingController();
//   final dio = new Dio(); // for http requests
//   String _searchText = "";
//   List names = new List(); // names we get from API
//   List filteredNames = new List(); // names filtered by search text
//   Icon _searchIcon = new Icon(Icons.search);
//   Widget _appBarTitle = new Text('Search Example');
//
//   //step 2.1
//   void _getNames() async {
//     final response =
//     await dio.get('https://jsonplaceholder.typicode.com/users');
//     print(response.data);
//     List tempList = new List();
//     for (int i = 0; i < response.data.length; i++) {
//       tempList.add(response.data[i]);
//     }
//     setState(() {
//       names = tempList;
//       filteredNames = names;
//     });
//   }
//
// //Step 2.2
//   void _searchPressed() {
//     setState(() {
//       if (this._searchIcon.icon == Icons.search) {
//         this._searchIcon = new Icon(Icons.close);
//         this._appBarTitle = new TextField(
//           controller: _filter,
//           decoration: new InputDecoration(
//               prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
//         );
//       } else {
//         this._searchIcon = new Icon(Icons.search);
//         this._appBarTitle = new Text('Search Example');
//         filteredNames = names;
//         _filter.clear();
//       }
//     });
//   }
//
//   //Step 4
//   Widget _buildList() {
//     if (!(_searchText.isEmpty)) {
//       List tempList = new List();
//       for (int i = 0; i < filteredNames.length; i++) {
//         if (filteredNames[i]['name']
//             .toLowerCase()
//             .contains(_searchText.toLowerCase())) {
//           tempList.add(filteredNames[i]);
//         }
//       }
//       filteredNames = tempList;
//     }
//     return ListView.builder(
//       itemCount: names == null ? 0 : filteredNames.length,
//       itemBuilder: (BuildContext context, int index) {
//         return new ListTile(
//           title: Text(filteredNames[index]['name']),
//           onTap: () => print(filteredNames[index]['name']),
//         );
//       },
//     );
//   }
//
//   //STep6
//   Widget _buildBar(BuildContext context) {
//     return new AppBar(
//       centerTitle: true,
//       title: _appBarTitle,
//       leading: new IconButton(
//         icon: _searchIcon,
//         onPressed: _searchPressed,
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     _getNames();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildBar(context),
//       body: Container(
//         child: _buildList(),
//       ),
//      // resizeToAvoidBottomPadding: false,
// //      floatingActionButton: FloatingActionButton(
// //        onPressed: _postName,
// //        child: Icon(Icons.add),
// //      ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'group_info_list_model.dart';
class ButtonCard1 extends StatelessWidget {
  const ButtonCard1({Key?  key,required this.contacts}) : super(key: key);

  final GroupContactModel contacts;
  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.all(6),
        child: ListTile(
          leading: Container(
            height: 44.h,
            width: 44.w,


            child: SvgPicture.asset( contacts.dp),
          ),
          title: Text(
            contacts.name,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 0, 0, 1))),
          ),

        ),
      );
  }
}

