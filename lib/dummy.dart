// import 'package:flutter/material.dart';

// void main(List<String> args) {
//   runApp(MaterialApp(home: MyHomePage()));
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<int> _selectedItems = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: ListView.builder(
//             itemCount: 10,
//             itemBuilder: (context, index) {
//               return Container(
//                 color: (_selectedItems.contains(index))
//                     ? Colors.blue.withOpacity(0.5)
//                     : Colors.transparent,
//                 child: ListTile(
//                   title: Text('$index'),
//                   onLongPress: () {
//                  if (!_selectedItems.contains(index)) {
//                       setState(() {
//                         _selectedItems.add(index);
//                       });
//                     }
//                   },
//                   onTap: () {
//                     if (_selectedItems.contains(index)) {
//                       setState(() {
//                         _selectedItems.removeWhere((val) => val == index);
//                       });
//                     }
//                   },
//                 ),
//               );
//             }));
//   }
// }

// import 'package:flutter/material.dart';

// void main(List<String> args) {
//   runApp(MaterialApp(home: MyHomePage()));
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<int> _selectedItems = [];
//   var isSelected=false;
//  var mycolor=Colors.white;
//  var border= BoxDecoration(border: new Border.all(
//   color: Colors.white));
//   @override
//   Widget build(BuildContext context) {
//  return new Card(
//       color: mycolor,
//       child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  
//            new ListTile(
//               selected: isSelected,
//               leading: const Icon(Icons.info),
//               title: new Text("Test"),
//               subtitle: new Text("Test Desc"),
//               trailing: new Text("3"),
//               onLongPress: toggleSelection // what should I put here,
//               ),
      
//       ]),
//     );
//   }
//   void toggleSelection() {
//     setState(() {
//       if (isSelected) {
//         border=new BoxDecoration(border: new Border.all(color: Colors.white));
//         mycolor = Colors.blue;
//         isSelected = false;
//       } else {
//         border=new BoxDecoration(border: new Border.all(color: Colors.grey));
//         mycolor = Colors.pink;
//         isSelected = true;
//       }
//     });
//   }
//   }




// import 'package:flutter/material.dart';

// void main() {
// runApp(const MyApp());
// }

// // Class
// class MyApp extends StatelessWidget {
// const MyApp({Key? key}) : super(key: key);

// // This widget is
// //the root of your application.
// @override
// Widget build(BuildContext context) {
// 	return MaterialApp(
// 	title: 'ListTile',
// 	theme: ThemeData(
// 		primarySwatch: Colors.blue,
// 	),
// 	home: const MyHomePage(),
// 	debugShowCheckedModeBanner: false,
// 	);
// }
// }

// // Class
// class MyHomePage extends StatefulWidget {
// const MyHomePage({Key? key}) : super(key: key);

// @override
// // ignore: library_private_types_in_public_api
// _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
// String txt = '';

// @override
// Widget build(BuildContext context) {
// 	return Scaffold(
// 	appBar: AppBar(
// 		title: const Text('GeeksforGeeks'),
// 		backgroundColor: Colors.green,
// 	),
// 	backgroundColor: Colors.grey[100],
// 	body: Column(
// 		children: <Widget>[
// 		Padding(
// 			padding: const EdgeInsets.all(8.0),
// 			child: Container(
// 			color: Colors.blue[50],
// 			child: ListTile(
// 				leading: const Icon(Icons.add),
// 				title: const Text(
// 				'GFG title',
// 				textScaleFactor: 1.5,
// 				),
// 				trailing: const Icon(Icons.done),
// 				subtitle: const Text('This is subtitle'),
// 				selected: true,
// 				onTap: () {
// 				setState(() {
// 					txt = 'List Tile pressed';
// 				});
// 				},
// 			),
// 			),
// 		),
// 		Text(
// 			txt,
// 			textScaleFactor: 2,
// 		)
// 		],
// 	),
// 	);
// }
// }


import 'package:flutter/material.dart';



class WorkerDetails {
  
  late String name;
  late String role;
  bool isSelected;
WorkerDetails({required this.name,required this.role,required this.isSelected});

  }

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      double width=MediaQuery.of(context).size.width;
    List officeDetails = [
      WorkerDetails( name: 'Dhina', role: 'Developer',isSelected: false),
      WorkerDetails( name: 'Lotus', role: 'Data Entry',isSelected: false),
      WorkerDetails( name: 'Rajesh', role: 'Typist',isSelected: false),
      WorkerDetails( name: 'Abdul', role: 'Team Leader',isSelected: false),
      WorkerDetails( name: 'Ayesha', role: 'Manager',isSelected: false),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text('Workers Details',
        style: TextStyle(fontSize:20,
            fontWeight: FontWeight.w400 )),
      ),
      body: ListView.builder(
          itemCount: 5, itemBuilder: (context, index) => Card(

           color: (officeDetails.contains(String))?Colors.green
            :Colors.red,
            child: Container(
          
          
              child: ListTile(

               
               onTap: (){

                if(!officeDetails.contains(index)){
                
                }
               },
              leading: CircleAvatar(child: Text(officeDetails[index].name[0]),),
                title: Text(officeDetails[index].name,
                 style: TextStyle(fontSize:width*0.07,
                fontWeight: FontWeight.w400 )),
                // trailing: Text(officeDetails[index].role,
                //  style: TextStyle(fontSize:width*0.06,
                // fontWeight: FontWeight.w400 ))
//trailing:isSelected==false ?Icon(Icons.abc_sharp):Icon(Icons.alarm,

              ),
            ),
          )),
    );
  }
}