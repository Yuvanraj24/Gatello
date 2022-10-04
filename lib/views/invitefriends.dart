import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:gatello/views/tabbar/tabbar_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteFriends extends StatefulWidget {
  ///* 0-> invite ; 1-> share
  final int state;

  const InviteFriends({Key? key, required this.state}) : super(key: key);

  @override
  State<InviteFriends> createState() => _ContactListState();
}

class _ContactListState extends State<InviteFriends> {
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
        String contactName = contact.displayName!.toLowerCase();
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

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return SafeArea(
        child: ResponsiveBuilder(
            builder: (context, sizingInformation) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child:Center(
                      child: Text('     Back',style:GoogleFonts.inter(
                          textStyle:TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600,color:Colors.black)
                      )),
                    )),
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
                        return Container(padding:EdgeInsets.only(left:12.w,right:12.w,top:20.h,bottom:35.h),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(height:48.h,width:48.w,decoration:BoxDecoration(color:
                                  Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle,border:Border.all(
                                      color:Colors.black
                                  )),child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/invite_friends/invitefriends.svg',
                                          height:28.h,width: 28.w),
                                    ],
                                  ),),
                                  Text("Invite Your Friends",
                                      style: GoogleFonts.fredoka(
                                        textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>Tabbar()),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                          primary: Color.fromRGBO(0, 0, 0, 0.44)),
                                      child: Text("Skip",
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )))
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
                                                  fixedSize: Size(75.w, 26.h),
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
                                              child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset('assets/invite_friends/add_icon.svg',
                                                    height:28.h,width: 28.w,),
                                                ],
                                              ))
                                              : (selectedContactsId.contains(snapshot.data![index].id))
                                              ? Icon(Icons.done)
                                              : null,
                                        ),
                                        Divider(color:Color.fromRGBO(0, 0, 0, 0.14),thickness:0.8.h,indent:12.w,)
                                      ]
                                      );
                                    }
                                  }),
                            ),
                            // ElevatedButton(style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                            //     fixedSize:Size(234.w,53.h),shape:RoundedRectangleBorder(borderRadius:
                            //     BorderRadius.circular(26))),
                            //     onPressed: () {
                            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //         return LoginScreen();
                            //       },));
                            //     }, child:Text('Get started',style:GoogleFonts.inter(textStyle:TextStyle(
                            //         fontWeight:FontWeight.w600,fontSize:14.sp,color:Colors.black
                            //     )),))
                          ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else if (snapshot.connectionState == ConnectionState.none) {
                      return Container();
                    } else {
                      return Container();
                    }
                  }),
            )));
  }


}