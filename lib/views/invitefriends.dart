import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:gatello/views/tabbar/pops/circle_indicator.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '/Model/SignIn.dart' as signInModel;

import '../Authentication/Authentication.dart';
import '../Others/Routers.dart';
import '../Others/exception_string.dart';
import '../core/models/exception/pops_exception.dart';
import '../handler/Network.dart';
import '../handler/SharedPrefHandler.dart';
class InviteFriends extends StatefulWidget {
  ///* 0-> invite ; 1-> share
  final int state;
  var mobileNo;
  var password;
  var username;
  String Getstarted;

  InviteFriends({
    required this.Getstarted,
    this.mobileNo,
    this.password,
    required this.state,
    this.username

  });

  @override
  State<InviteFriends> createState() => _ContactListState();
}

class _ContactListState extends State<InviteFriends> {

  ValueNotifier<Tuple4> signInValueNotifier =
  ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));

  late SharedPreferences logindata;
  late bool newuser;

  FirebaseFirestore instance = FirebaseFirestore.instance;
  List<String> selectedContactsId = [];
  List selectedContacts = [];
  late Future<List<Contact>> _contacts;
  List<Contact> contacts = [];
  List <Contact> filteredContacts=[];
  var listData;

  TextEditingController searchController= TextEditingController();

  @override

  filterContacts(){
    List<Contact> _contact=[];
    _contact.addAll(contacts);
    if ( searchController.text.isNotEmpty){
      _contact.retainWhere( (contact){
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {

        filteredContacts=_contact;
        for(var i=0; i<filteredContacts.length; i++){
          print(filteredContacts[i].displayName);
          listData = filteredContacts[i].displayName;
        }
      });
    }
  }

  void initState() {
    _contacts = getContacts();
    super.initState();
    searchController.addListener(() {
      filterContacts();
    });
  }

  Future<List<Contact>> getContacts() async {
    PermissionStatus contactpermission = await Permission.contacts.request();
    if (contactpermission.isGranted || contactpermission.isLimited) {
      contacts = await FastContacts.allContacts;

    } else {

    }
    return contacts;// return contactList;
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions:[
          TextButton(
            child: Text(
              'No',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#646363')),

            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              'Yes',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#646363')),

            ),
            onPressed: () => SystemNavigator.pop(),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return SafeArea(
        child:widget.Getstarted.contains("Sign up")? WillPopScope(
            onWillPop:showExitPopup,

            child:  Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  leading:widget.Getstarted.contains("Sign up")?null :
                  GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                        // var body = jsonEncode(<String, dynamic>{
                        //   "credential_1": "+91${widget.mobileNo}",
                        //   "password": widget.password,
                        // });
                        // print("body check: ${body}");
                        // if(signin(body)==null){
                        //   CircularProgressIndicator();
                        // }
                        // signin(body);

                      },
                      child:Center(
                        child: Text('Back',style:GoogleFonts.inter(
                            textStyle:TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600,color:Colors.black)
                        )),
                      ))
              ),
              floatingActionButton: (widget.state == 0)
                  ? null
                  : (contacts.isNotEmpty)
                  ? FloatingActionButton(
                child: Icon(
                  Icons.send,
                ),
                onPressed: () => Navigator.pop(context, selectedContacts),
              )
                  : null,
              body: FutureBuilder<List<Contact>>(
                  future: _contacts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isNotEmpty) {
                        return Container(
                          padding:EdgeInsets.only(left:12.w,right:12.w,top:20.h,bottom:35.h),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(height:48.h,width:48.w,decoration:BoxDecoration(color:
                                  Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle,border:Border.all(
                                      color:Colors.black
                                  ))
                                    ,child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/invite_friends/invitefriends.svg',
                                            height:28.h,width: 28.w),
                                      ],
                                    ),),
                                  SizedBox(width: 62.w,),
                                  Text("Invite Your Friends",
                                      style: GoogleFonts.fredoka(
                                        textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      )),

                                ]),
                            SizedBox(height:17.h),
                            Container(
                              height: 36.h,
                              width: 337.w,
                              child: TextFormField(
                                controller:searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top:4,right:10),
                                  border: OutlineInputBorder(
                                    //   borderSide: BorderSide(),
                                      borderRadius: BorderRadius.circular(40)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1.w),
                                      // borderRadius: BorderRadius.circular(5.w)
                                      borderRadius: BorderRadius.circular(40)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1.w),
                                      //  borderRadius: BorderRadius.circular(5.w)
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  prefixIcon:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/tabbar_icons/Tabbar_search.svg'),
                                    ],
                                  ),
                                  //  labelStyle: TextStyle(fontSize: 12
                                  //),
                                  hintText: "  Search...",
                                  hintStyle: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                            ),
                            SizedBox(height:20.h),
                            Expanded(
                              child: ListView.builder(

                                  itemCount:isSearching == true?filteredContacts.length:contacts.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Contact contact = isSearching==true? filteredContacts[index]:contacts[index];
                                    if (snapshot.data == null) {
                                      return Container();
                                    } else {
                                      return Column(children: [
                                        ListTile(
                                          leading:Container(height:48.h,width:48.w,child:
                                          SvgPicture.asset('assets/invite_friends/profilepicture.svg')),
                                          title: Text(contact.displayName,style:
                                          GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:14.sp)),
                                          subtitle: Text(contact.phones[0],style:
                                          GoogleFonts.inter(fontWeight:FontWeight.w400,fontSize:12.sp,color:
                                          Color.fromRGBO(12, 16, 29, 0.6))),
                                          trailing: (widget.state == 0)
                                              ?  ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: new RoundedRectangleBorder(
                                                    borderRadius:
                                                    new BorderRadius.circular(5),
                                                  ),
                                                  fixedSize: Size(85.w, 26.h),
                                                  primary:
                                                  Color.fromRGBO(248, 206, 97, 1)),
                                              onPressed: (widget.state == 0)?() async{
                                                String uri =
                                                    'sms:${contact.phones[0]}?body=${Uri.encodeComponent('''Hi ${contact.displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                                if (await canLaunchUrl(Uri.parse(uri))) {
                                                  await launchUrl(Uri.parse(uri));
                                                } else {
                                                  throw 'Could not launch $uri';
                                                }
                                              }: () async {
                                                if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    selectedContactsId.add(contact.displayName);
                                                    selectedContacts.add(contact.phones[0]);
                                                  });
                                                } else {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    selectedContactsId.remove(snapshot.data![index].id);
                                                    selectedContacts.remove(snapshot.data![index]);
                                                  });
                                                }
                                              },
                                              child:Container(width:82.w,
                                                child: SvgPicture.asset('assets/invite_friends/add_icon.svg',
                                                  height:28.h,width: 28.w,),
                                              )
                                          )
                                              : (selectedContactsId.contains(snapshot.data![index].id))
                                              ? Icon(Icons.done)
                                              : null,
                                        ),
                                        Divider(
                                            color: Color.fromRGBO(0, 0, 0, 0.14),
                                            thickness:0.8.h,
                                            indent:12.w
                                        )
                                      ]
                                      );
                                    }
                                  }),
                            ),
                            widget.Getstarted.contains("Sign up")?
                            ElevatedButton(style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                                fixedSize:Size(234.w,53.h),shape:RoundedRectangleBorder(borderRadius:
                                BorderRadius.circular(26))),
                                onPressed: () {
                                  print("mobile no ${widget.mobileNo}");
                                  print("password ${widget.password}");
                                  print("username ${widget.username}");
                                  var body = jsonEncode(<String, dynamic>{
                                    "credential_1": "+91${widget.mobileNo}",
                                    "password": widget.password,
                                  });
                                  print("body check: ${body}");
                                  if(signin(body)==null){
                                    CircularProgressIndicator();
                                  }
                                  signin(body);

                                }, child:Text('Get started',style:GoogleFonts.inter(textStyle:TextStyle(
                                    fontWeight:FontWeight.w600,fontSize:14.sp,color:Colors.black
                                )),)):
                            SizedBox()
                          ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    else if (snapshot.connectionState == ConnectionState.waiting) {

                      return CircleIndicator();
                    } else {

                      return CircleIndicator();
                    }
                  }),
            )

        ): Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading:widget.Getstarted.contains("Sign up")?null :
              GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    // var body = jsonEncode(<String, dynamic>{
                    //   "credential_1": "+91${widget.mobileNo}",
                    //   "password": widget.password,
                    // });
                    // print("body check: ${body}");
                    // if(signin(body)==null){
                    //   CircularProgressIndicator();
                    // }
                    // signin(body);

                  },
                  child:Center(
                    child: Text('Back',style:GoogleFonts.inter(
                        textStyle:TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600,color:Colors.black)
                    )),
                  ))
          ),
          floatingActionButton: (widget.state == 0)
              ? null
              : (contacts.isNotEmpty)
              ? FloatingActionButton(
            child: Icon(
              Icons.send,
            ),
            onPressed: () => Navigator.pop(context, selectedContacts),
          )
              : null,
          body: FutureBuilder<List<Contact>>(
              future: _contacts,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isNotEmpty) {
                    return Container(
                      padding:EdgeInsets.only(left:12.w,right:12.w,top:20.h,bottom:35.h),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(height:48.h,width:48.w,decoration:BoxDecoration(color:
                              Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle,border:Border.all(
                                  color:Colors.black
                              ))
                                ,child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/invite_friends/invitefriends.svg',
                                        height:28.h,width: 28.w),
                                  ],
                                ),),
                              SizedBox(width: 62.w,),
                              Text("Invite Your Friends",
                                  style: GoogleFonts.fredoka(
                                    textStyle: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  )),

                            ]),
                        SizedBox(height:17.h),
                        Container(
                          height: 36.h,
                          width: 337.w,
                          child: TextFormField(
                            controller:searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:4,right:10),
                              border: OutlineInputBorder(
                                //   borderSide: BorderSide(),
                                  borderRadius: BorderRadius.circular(40)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.w),
                                  // borderRadius: BorderRadius.circular(5.w)
                                  borderRadius: BorderRadius.circular(40)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.w),
                                  //  borderRadius: BorderRadius.circular(5.w)
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              prefixIcon:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:
                              CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/tabbar_icons/Tabbar_search.svg'),
                                ],
                              ),
                              //  labelStyle: TextStyle(fontSize: 12
                              //),
                              hintText: "  Search...",
                              hintStyle: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                        SizedBox(height:20.h),
                        Expanded(
                          child: ListView.builder(

                              itemCount:isSearching == true?filteredContacts.length:contacts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Contact contact = isSearching==true? filteredContacts[index]:contacts[index];
                                if (snapshot.data == null) {
                                  return Container();
                                } else {
                                  return Column(children: [
                                    ListTile(
                                      leading:Container(height:48.h,width:48.w,child:
                                      SvgPicture.asset('assets/invite_friends/profilepicture.svg')),
                                      title: Text(contact.displayName,style:
                                      GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:14.sp)),
                                      subtitle: Text(contact.phones[0],style:
                                      GoogleFonts.inter(fontWeight:FontWeight.w400,fontSize:12.sp,color:
                                      Color.fromRGBO(12, 16, 29, 0.6))),
                                      trailing: (widget.state == 0)
                                          ?  ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                new BorderRadius.circular(5),
                                              ),
                                              fixedSize: Size(85.w, 26.h),
                                              primary:
                                              Color.fromRGBO(248, 206, 97, 1)),
                                          onPressed: (widget.state == 0)?() async{
                                            String uri =
                                                'sms:${contact.phones[0]}?body=${Uri.encodeComponent('''Hi ${contact.displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                            if (await canLaunchUrl(Uri.parse(uri))) {
                                              await launchUrl(Uri.parse(uri));
                                            } else {
                                              throw 'Could not launch $uri';
                                            }
                                          }: () async {
                                            if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                              if (!mounted) return;
                                              setState(() {
                                                selectedContactsId.add(contact.displayName);
                                                selectedContacts.add(contact.phones[0]);
                                              });
                                            } else {
                                              if (!mounted) return;
                                              setState(() {
                                                selectedContactsId.remove(snapshot.data![index].id);
                                                selectedContacts.remove(snapshot.data![index]);
                                              });
                                            }
                                          },
                                          child:Container(width:82.w,
                                            child: SvgPicture.asset('assets/invite_friends/add_icon.svg',
                                              height:28.h,width: 28.w,),
                                          )
                                      )
                                          : (selectedContactsId.contains(snapshot.data![index].id))
                                          ? Icon(Icons.done)
                                          : null,
                                    ),
                                    Divider(
                                        color: Color.fromRGBO(0, 0, 0, 0.14),
                                        thickness:0.8.h,
                                        indent:12.w
                                    )
                                  ]
                                  );
                                }
                              }),
                        ),
                        widget.Getstarted.contains("Sign up")?
                        ElevatedButton(style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                            fixedSize:Size(234.w,53.h),shape:RoundedRectangleBorder(borderRadius:
                            BorderRadius.circular(26))),
                            onPressed: () {
                              print("mobile no ${widget.mobileNo}");
                              print("password ${widget.password}");
                              print("username ${widget.username}");
                              var body = jsonEncode(<String, dynamic>{
                                "credential_1": "+91${widget.mobileNo}",
                                "password": widget.password,
                              });
                              print("body check: ${body}");
                              if(signin(body)==null){
                                CircularProgressIndicator();
                              }
                              signin(body);

                            }, child:Text('Get started',style:GoogleFonts.inter(textStyle:TextStyle(
                                fontWeight:FontWeight.w600,fontSize:14.sp,color:Colors.black
                            )),)):
                        SizedBox()
                      ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {

                  return CircleIndicator();
                } else {

                  return CircleIndicator();
                }
              }),
        )
    );
  }

  Future signInApiCall(
      {required String uid,
        required String credential,
        required String password}) async {
    // return await getFCMToken().then((value) async {
    return await ApiHandler().apiHandler(
      valueNotifier: signInValueNotifier,
      jsonModel: signInModel.signInFromJson,
      url: loginUrl,
      requestMethod: 1,
      // body: {"credential_1": credential, "password": password, "user_id": uid, "notification_token": value!},
      body: {
        "credential_1": credential,
        "password": password,
        "user_id": uid,
      },
    );
    // });
  }

  Future<void> signin(var body) async {
    print(body.toString());

    try {
      var url = Uri.parse("http://3.108.219.188:5000/login");
      var response = await http.post(url, body: body);


      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        print(response.body.toString());
        Map<String, dynamic>  map = jsonDecode(response.body.toString());
        String status = map['status'];
        print("STATUS:"+status);
        if(status=="OK")
        {
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1);
          final SharedPreferences prefs = await _prefs;
          String resultJson=jsonEncode(map['result']);
          print(jsonEncode(map['result']));
          Map<String, dynamic> map1 = jsonDecode(resultJson);
          print("LOGIN RESPONSE");
          print("this is a uid : ${map1['user_id']}");
          String username = widget.mobileNo;
          logindata = await SharedPreferences.getInstance();
          logindata.setBool('login', false);
          logindata.setString('username', username);
          SharedPrefHandler sharedPrefHandler=new SharedPrefHandler();
          sharedPrefHandler.writeUserInfo(map1['user_id'], map1['email'], map1['root_folder_id']);
          print("this is a uid 2nd check : ${map1['user_id']}");
          await instance.collection("user-detail").doc(map1['user_id']).update({"token": await getFCMToken()});
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => Tabbar(uid: map1['user_id'],)));
        }

      } else {
        print("hello ${response.statusCode}");
      }

    } catch (e) {
      print("hello this is  ${e.toString()}");
    }
  }



}