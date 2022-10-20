import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Assets/GatelloIcon.dart';
import '../Others/components/LottieComposition.dart';
import '../Others/lottie_strings.dart';
import '../Style/Text.dart';
import '../components/SnackBar.dart';
import '../components/flatButton.dart';

class ContactList extends StatefulWidget {
  ///* 0-> invite ; 1-> share
  final int state;

  const ContactList({Key? key, required this.state}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  List<String> selectedContactsId = [];
  List<Contact> selectedContacts = [];
  late Future<List<Contact>> _contacts;
  List<Contact> contacts = [];
  TextEditingController searchController = TextEditingController();
  bool searchBar = false ;
  String nameSearch='';

  @override
  void initState() {
    _contacts = getContacts();
    super.initState();
  }

  Future<List<Contact>> getContacts() async {
    PermissionStatus contactpermission = await Permission.contacts.request();
    List<Contact> contactList = [];
    if (contactpermission.isGranted || contactpermission.isLimited) {
      contacts = await FastContacts.allContacts;

    } else {
      final snackBar = snackbar(content: "Please enable contact permission");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return contacts;
    // return contactList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ResponsiveBuilder(
            builder: (context, sizingInformation) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: searchBar==false? AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
                          width:35.w,),
                      ],
                    )),
                title: Text(
                  (selectedContactsId.isEmpty) ? 'Contact List' : '${selectedContacts.length}/${contacts.length} Selected',
                  style: GoogleFonts.inter(textStyle: textStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,color:Colors.black)),
                ),
                actions: [  GestureDetector(onTap: () {
                  setState(() {
                    searchBar = true;
                  });
                },
                  child: SvgPicture.asset(
                    'assets/tabbar_icons/Tabbar_search.svg',height:21.h,width:21.w,
                  ),
                ),
                  SizedBox(width:28.w,)],
              ):AppBar(automaticallyImplyLeading: false, title: searchBox()),
              floatingActionButton: (widget.state == 0) ? null : (contacts.isNotEmpty)
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
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var name = snapshot.data![index].displayName;
                              if(nameSearch.isEmpty){
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: ListTile(
                                    title: SubstringHighlight(
                                      caseSensitive: false,
                                      text:name,
                                      textStyle: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontWeight: FontWeight.w700)),
                                      term: searchController.text,
                                    ),
                                    subtitle: Text(snapshot.data![index].phones[0],style:GoogleFonts.inter(
                                        textStyle:TextStyle( fontSize: 12.sp,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.w500)
                                    ),),
                                    trailing: (widget.state == 0)
                                        ? Icon(DeejosIcon.chat_2_outline)
                                        : (selectedContactsId.contains(snapshot.data![index].id))
                                        ? Icon(Icons.done)
                                        : null,
                                    onTap: (widget.state == 0)
                                        ? () async {
                                      String uri =
                                          'sms:${snapshot.data![index].phones[0]}?body=${Uri.encodeComponent('''Hi ${snapshot.data![index].displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                      if (await canLaunch(uri)) {
                                        await launch(uri);
                                      } else {
                                        throw 'Could not launch $uri';
                                      }
                                    }
                                        : () async {
                                      if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.add(snapshot.data![index].id);
                                          selectedContacts.add(snapshot.data![index]);
                                        });
                                      } else {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.remove(snapshot.data![index].id);
                                          selectedContacts.remove(snapshot.data![index]);
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                              if(name.toString().toLowerCase().contains(nameSearch.toLowerCase())){
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: ListTile(
                                    title: SubstringHighlight(
                                      caseSensitive: false,
                                      text:name,
                                      textStyle: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontWeight: FontWeight.w700)),
                                      term: searchController.text,
                                    ),
                                    subtitle: Text(snapshot.data![index].phones[0],style:GoogleFonts.inter(
                                        textStyle:TextStyle( fontSize: 12.sp,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.w500)
                                    ),),
                                    trailing: (widget.state == 0)
                                        ? Icon(DeejosIcon.chat_2_outline)
                                        : (selectedContactsId.contains(snapshot.data![index].id))
                                        ? Icon(Icons.done)
                                        : null,
                                    onTap: (widget.state == 0)
                                        ? () async {
                                      String uri =
                                          'sms:${snapshot.data![index].phones[0]}?body=${Uri.encodeComponent('''Hi ${snapshot.data![index].displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                      if (await canLaunch(uri)) {
                                        await launch(uri);
                                      } else {
                                        throw 'Could not launch $uri';
                                      }
                                    }
                                        : () async {
                                      if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.add(snapshot.data![index].id);
                                          selectedContacts.add(snapshot.data![index]);
                                        });
                                      } else {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.remove(snapshot.data![index].id);
                                          selectedContacts.remove(snapshot.data![index]);
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                              else{Scaffold(
                                body:Center(child:Text("No Contacts"),),
                              );}
                              return Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: ListTile(
                                  title: SubstringHighlight(
                                    caseSensitive: false,
                                    text:name,
                                    textStyle: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.w700)),
                                    term: searchController.text,
                                  ),
                                  subtitle: Text(snapshot.data![index].phones[0],style:GoogleFonts.inter(
                                      textStyle:TextStyle( fontSize: 12.sp,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w500)
                                  ),),
                                  trailing: (widget.state == 0)
                                      ? Icon(DeejosIcon.chat_2_outline)
                                      : (selectedContactsId.contains(snapshot.data![index].id))
                                      ? Icon(Icons.done)
                                      : null,
                                  onTap: (widget.state == 0)
                                      ? () async {
                                    String uri =
                                        'sms:${snapshot.data![index].phones[0]}?body=${Uri.encodeComponent('''Hi ${snapshot.data![index].displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                    if (await canLaunch(uri)) {
                                      await launch(uri);
                                    } else {
                                      throw 'Could not launch $uri';
                                    }
                                  }
                                      : () async {
                                    if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                      if (!mounted) return;
                                      setState(() {
                                        selectedContactsId.add(snapshot.data![index].id);
                                        selectedContacts.add(snapshot.data![index]);
                                      });
                                    } else {
                                      if (!mounted) return;
                                      setState(() {
                                        selectedContactsId.remove(snapshot.data![index].id);
                                        selectedContacts.remove(snapshot.data![index]);
                                      });
                                    }
                                  },
                                ),
                              );
                            });
                      } else {
                        return Container(
                            child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lottieAnimation(invalidLottie),
                                      Text("No Contacts Found"),
                                      flatButton(
                                          onPressed: () async {
                                            _contacts = getContacts();
                                          },
                                          child: Text("Retry"))
                                    ],
                                  ),
                                )));
                      }
                    } else if (snapshot.connectionState == ConnectionState.none) {
                      return Container(
                          child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    lottieAnimation(invalidLottie),
                                    Text("No Contacts Found"),
                                    flatButton(
                                        onPressed: () async {
                                          _contacts = getContacts();
                                        },
                                        child: Text("Retry"))
                                  ],
                                ),
                              )));
                    } else {
                      return Container(
                          child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [lottieAnimation(loadingLottie, repeat: true), Text("Loading")],
                                ),
                              )));
                    }
                  }),
            )));
  }

  Widget searchBox(){
    bool folded=false;
    return Center(
      child: AnimatedContainer(duration:Duration(milliseconds:100),
        height:40.h,width:folded==true?10.w:300.w,
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(15),color:Colors.white),
        child:   TextField(
          onChanged: (value){
            setState(() {
              nameSearch=value;
            });
          },
          autofocus:true,
          cursorColor:Colors.black,cursorHeight:20.h,
          controller:searchController,
          decoration:InputDecoration(hintText:'Search...',contentPadding:EdgeInsets.only(
              top:10.h
          ),
              hintStyle:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w500,
                  fontSize:14.sp,color:Colors.black)),
              suffixIcon:GestureDetector(onTap:() {
                setState(() {
                  searchBar = false;
                });
              },
                  child: Icon(Icons.close,color:Colors.black,)),
              prefixIcon:Column(mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/tabbar_icons/Tabbar_search.svg'
                  ),
                ],
              ),
              focusedBorder:OutlineInputBorder(
                  borderSide:BorderSide(color:Colors.transparent)
              ),
              enabledBorder:OutlineInputBorder(
                  borderSide:BorderSide(color:Colors.transparent)
              )),
        ),
      ),
    );
  }
}