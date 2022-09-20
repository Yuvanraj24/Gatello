// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gatello/views/tabbar/tabbar_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// class InviteFriends extends StatefulWidget {
//   const InviteFriends({Key? key}) : super(key: key);
//
//   @override
//   State<InviteFriends> createState() => _InviteFriendsState();
// }
//
// class _InviteFriendsState extends State<InviteFriends> {
//   TextEditingController searchContacts =TextEditingController();
//   List <Contact> contacts=[];
//   List <Contact> filteredContacts=[];
//   @override
//   void initState(){
//     super.initState();
//     getAllContacts();
//     searchContacts.addListener(() {
//       filterContacts();
//     });
//   }
//   //
//   getAllContacts()async{
//     List<Contact> _contacts = (await ContactsService.getContacts()).toList();
//     setState(() {
//       contacts=_contacts;
//     });
//   }
//   filterContacts(){
//     List<Contact> _contact=[];
//     _contact.addAll(contacts);
//     if ( searchContacts.text.isNotEmpty){
//     _contact.retainWhere( (contact){
//       String searchTerm = searchContacts.text.toLowerCase();
//       String contactName = contact.displayName!.toLowerCase();
//       return contactName.contains(searchTerm);
//     });
//     setState(() {
//     filteredContacts=_contact;
//     });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isSearching =searchContacts.text.isNotEmpty;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Center(
//               child: TextButton(
//             onPressed: () {Navigator.pop(context);},
//             child: Text('Back', style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w600),),
//           )),
//         ),
//         body: Container(
//           padding:
//               EdgeInsets.only(left: 12.h, right: 12.h, top: 17.h, bottom: 35),
//           child: Column(
//             children: [
//               Container(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                     Container(height:48.h,width:48.w,decoration:BoxDecoration(color:
//                     Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle,border:Border.all(
//                       color:Colors.black
//                     )),child:Column(crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset('assets/invite_friends/invitefriends.svg',
//                             height:28.h,width: 28.w),
//                       ],
//                     ),),
//                       Text("Invite Your Friends",
//                           style: GoogleFonts.fredoka(
//                             textStyle: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Color.fromRGBO(0, 0, 0, 1),
//                             ),
//                           )),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => Tabbar(),));
//                           },
//                           style: TextButton.styleFrom(
//                               primary: Color.fromRGBO(0, 0, 0, 0.44)),
//                           child: Text("Skip",
//                               style: GoogleFonts.inter(
//                                 textStyle: TextStyle(
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )))
//                     ]),
//               ),
//               SizedBox(height: 13.h),
//               Container(
//                 height: 36.h,
//                 width: 337.w,
//                 child: TextFormField(
//                   controller:searchContacts,
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(top:4,right:10),
//                     border: OutlineInputBorder(
//                         //   borderSide: BorderSide(),
//                         borderRadius: BorderRadius.circular(40)),
//                            focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black, width: 1.w),
//                          // borderRadius: BorderRadius.circular(5.w)
//                      borderRadius: BorderRadius.circular(40)
//                         ),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black, width: 1.w),
//                            //  borderRadius: BorderRadius.circular(5.w)
//                         borderRadius: BorderRadius.circular(40)
//                       ),
//                     prefixIcon: Icon(Icons.search),
//                     //  labelStyle: TextStyle(fontSize: 12
//                     //),
//                     hintText: "Search",
//                     hintStyle: GoogleFonts.inter(
//                         textStyle: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w300,
//                             color: HexColor('#0C101D'))),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 21.h,),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount:isSearching==true ?
//                   filteredContacts.length:contacts.length,
//                   itemBuilder: (context,index) {
//                     Contact contact= isSearching==true? filteredContacts[index]:contacts[index];
//                     return Column(
//                       children: [
//                         Column(
//                           children: [
//                             ListTile(
//                                 contentPadding: EdgeInsets.all(0),
//                                 subtitle:
//                                 Text(contact.phones!.elementAt(index).value.toString()),
//                                 leading:Container(height:48.h,width:48.w,child:
//                                   SvgPicture.asset('assets/invite_friends/profilepicture.svg')),
//                                 title:Text(contact.displayName.toString()),
//                                 trailing: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         shape: new RoundedRectangleBorder(
//                                           borderRadius:
//                                               new BorderRadius.circular(5),
//                                         ),
//                                     fixedSize: Size(90.w, 18.h),
//                                         primary:
//                                             Color.fromRGBO(248, 206, 97, 1)),
//                                     onPressed: () {},
//                                     child:Column(crossAxisAlignment: CrossAxisAlignment.center,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         SvgPicture.asset('assets/invite_friends/add_icon.svg',
//                                           height:28.h,width: 28.w,),
//                                       ],
//                                     ))
//                                     ),
//                             Divider(
//                               thickness: 1.w,
//                               // height: 1.h,
//                               indent: 5.w,
//                               endIndent: 5.w,
//                             )
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Tabbar()));
//                 },
//                 child: Text(
//                   'Get started',
//                   style: GoogleFonts.inter(
//                       textStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black)),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                     elevation: 3,
//                     onPrimary: Colors.black,
//                     minimumSize: Size(234.w, 48.h),
//                     primary: Color.fromRGBO(248, 206, 97, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(35),
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
