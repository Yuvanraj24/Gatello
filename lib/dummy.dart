// import 'package:flutter/material.dart';


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


// import 'package:flutter/material.dart';


// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class WorkerDetails {
  
//   late String name;
//   late String role;
//   bool isSelected;
// WorkerDetails({required this.name,required this.role,required this.isSelected});

//   }

// class ListScreen extends StatelessWidget {
//   const ListScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//       double width=MediaQuery.of(context).size.width;
//     List officeDetails = [
//       WorkerDetails( name: 'Dhina', role: 'Developer',isSelected: false),
//       WorkerDetails( name: 'Lotus', role: 'Data Entry',isSelected: false),
//       WorkerDetails( name: 'Rajesh', role: 'Typist',isSelected: false),
//       WorkerDetails( name: 'Abdul', role: 'Team Leader',isSelected: false),
//       WorkerDetails( name: 'Ayesha', role: 'Manager',isSelected: false),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 40,
//         centerTitle: true,
//         title: const Text('Workers Details',
//         style: TextStyle(fontSize:20,
//             fontWeight: FontWeight.w400 )),
//       ),
//       body: ListView.builder(
//           itemCount: 5, itemBuilder: (context, index) => Card(

//            color: (officeDetails.contains(String))?Colors.green
//             :Colors.red,
//             child: Container(
          
          
//               child: ListTile(

               
//                onTap: (){

//                 if(!officeDetails.contains(index)){
                
//                 }
//                },
//               leading: CircleAvatar(child: Text(officeDetails[index].name[0]),),
//                 title: Text(officeDetails[index].name,
//                  style: TextStyle(fontSize:width*0.07,
//                 fontWeight: FontWeight.w400 )),
//                 // trailing: Text(officeDetails[index].role,
//                 //  style: TextStyle(fontSize:width*0.06,
//                 // fontWeight: FontWeight.w400 ))
// //trailing:isSelected==false ?Icon(Icons.abc_sharp):Icon(Icons.alarm,

//               ),
//             ),
//           )),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:gatello/views/splash_screen4.dart';

// class Dummy extends StatefulWidget {
//   const Dummy({Key? key}) : super(key: key);

//   @override
//   State<Dummy> createState() => _DummyState();
// }

// class _DummyState extends State<Dummy> {

//     final _formkey = GlobalKey<FormState>();
//   TextEditingController username = TextEditingController();
//   TextEditingController password = TextEditingController();
  
//   bool checkboxvalue = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         resizeToAvoidBottomInset: false,
//         body: Form(
//           key: _formkey,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   "Login Page",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//                 ),
//                 SizedBox(
//                   width: 100,
//                 ),
//                 Container(
//                   width: 300,
//                   color: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: TextFormField(
//                     controller: username,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter your username';
//                       }
//                       if (value.length >= 10) {
//                         return 'Name too long';
//                       } else if (value.length <= 5) {
//                         return 'Name too short';
//                       }
//                       return null;
//                     },
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold),
//                     decoration: InputDecoration(
//                       icon: Icon(
//                         Icons.person_rounded,
//                         size: 25,
//                         color: Colors.white,
//                       ),
//                       hintText: 'ENTER USERNAME',
//                       hintStyle: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white, width: 2),
//                           borderRadius: BorderRadius.circular(
//                             5,
//                           )),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 300,
//                   color: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: TextFormField(
//                     controller: password,
//                     obscureText: !checkboxvalue,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'please enter the password';
//                       } else if (value.length >= 10) {
//                         return 'name too long';
//                       } else if (value.length <= 5) {
//                         return 'name too short';
//                       }
//                       return null;
//                     },
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold),
//                     decoration: InputDecoration(
//                       icon: Icon(
//                         Icons.lock,
//                         size: 25,
//                         color: Colors.white,
//                       ),
//                       hintText: 'ENTER PASSWORD',
//                       hintStyle: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white, width: 2),
//                           borderRadius: BorderRadius.circular(
//                             5,
//                           )),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Checkbox(
//                       value: checkboxvalue,
//                       focusColor: Colors.pink,
//                       hoverColor: Colors.pink,
//                       fillColor: MaterialStateColor.resolveWith(
//                         (states) {
//                           if (states.contains(MaterialState.selected)) {
//                             return Colors
//                                 .pink; // the color when checkbox is selected;
//                           }
//                           return Colors
//                               .blue; //the color when checkbox is unselected;
//                         },
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           checkboxvalue = value!;
//                         });
//                       },
//                       checkColor: Colors.blue,
//                     ),
//                     Text(
//                       "Show Password",
//                       style: TextStyle(
//                         color: Colors.pink,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//                 OutlinedButton(
//                     onPressed: () {
//                       if (_formkey.currentState!.validate()) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Splash4())
//                                 );
//                       } else {
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 child: Text("Login Failed"),
//                               );
//                             });
//                       }
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(color: Colors.blue, fontSize: 20),
//                     )),
//               ],
//             ),
//           ),
//         ));
//   }
// }





// String? defaultValidator({required String? value, required String type, String? message}) {
//   if (value == null || value.trim() == "" || value.isEmpty || value.length < 1) {
//     if (message != null) {
//       return message;
//     } else {
//       return '$type should contain atleast 1 characters or above';
//     }
//   }
//   return null;
// }

// String? usernameValidator(String? value) {
//   String userPattern = r'(^[a-zA-Z0-9]{4,20}$)';
//   if (value == null || regex(pattern: userPattern, input: value) == false) {
//     return 'Username should contain 4 to 20 characters';
//   }
//   return null;
// }

// String? emailValidator(String? value) {
//   String emailPattern = r"^[a-zA-Z0-9.!#$%&'+=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$";
//   if (value == null || regex(pattern: emailPattern, input: value) == false) {
//     return 'Enter the correct email id';
//   }
//   return null;
// }

// String? passwordValidator({required String? value, String? message}) {
//   String passwordPattern = r'(^(?=.[a-z])(?=.\d)(?=.*[@#%-])[A-Za-z\d@#%-]{6,}$)';
//   if (value == null || regex(pattern: passwordPattern, input: value) == false) {
//     if (message != null) {
//       return message;
//     } else {
//       return 'Password should contain 8 and above characters, at least one uppercase letter, one lowercase letter, one number and one symbol';
//     }
//   }
//   return null;
// }

// String? phoneValidator(String? value) {
//   String phonePattern = r'(^(\+\d{1,3}[- ]?)?\d{10}$)';
//   // r'((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';
//   if (value == null || regex(pattern: phonePattern, input: value) == false) {
//     return 'Enter the correct phone number';
//   }
//   return null;
// }

// String? otpValidator(String? value) {
//   String otpPattern = r'(^[0-9]{6}$)';
//   if (value == null || regex(pattern: otpPattern, input: value) == false) {
//     return 'Enter the correct OTP';
//   }
//   return null;
// }

// String? intValidator(String? value, String type) {
//   if (value == null || (int.tryParse(value) == null && int.tryParse(value).toString().length < 1)) {
//     return '$type must be numeric(integer) and should contain more than 1 digits!';
//   }
//   return null;
// }


// String validateEmail(String value) {
//     Pattern pattern =
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?)*$";
//     RegExp regex = new RegExp(pattern);
//     if (!regex.hasMatch(value) || value == null)
//       return 'Enter a valid email address';
//     else
//       return null;
//   }

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _code="";
  String signature = "{{ app signature }}";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PhoneFieldHint(),
              Spacer(),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                ),
                currentCode: _code,
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  if (code!.length == 6) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
              Spacer(),
              TextFieldPinAutoFill(
                currentCode: _code,
              ),
              Spacer(),
              ElevatedButton(
                child: Text('Listen for sms code'),
                onPressed: () async {
                  await SmsAutoFill().listenForCode;
                },
              ),
              ElevatedButton(
                child: Text('Set code to 123456'),
                onPressed: () async {
                  setState(() {
                    _code = '123456';
                  });
                },
              ),
              SizedBox(height: 8.0),
              Divider(height: 1.0),
              SizedBox(height: 4.0),
              Text("App Signature : $signature"),
              SizedBox(height: 4.0),
              ElevatedButton(
                child: Text('Get app signature'),
                onPressed: () async {
                  signature = await SmsAutoFill().getAppSignature;
                  setState(() {});
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CodeAutoFillTestPage()));
                },
                child: Text("Test CodeAutoFill mixin"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CodeAutoFillTestPage extends StatefulWidget {
  @override
  _CodeAutoFillTestPageState createState() => _CodeAutoFillTestPageState();
}

class _CodeAutoFillTestPageState extends State<CodeAutoFillTestPage> with CodeAutoFill {
  String? appSignature;
  String? otpCode;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: Text("Listening for code"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: Text(
              "This is the current app signature: $appSignature",
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Builder(
              builder: (_) {
                if (otpCode == null) {
                  return Text("Listening for code...", style: textStyle);
                }
                return Text("Code Received: $otpCode", style: textStyle);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}