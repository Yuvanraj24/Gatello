import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';



class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 58.h,
          leading: Center(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
          )),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 12.h, right: 12.h, top: 17.h, bottom: 10),
          child: Column(
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                          "assets/invite_friends/invite_friends_logo.png",width: 52.w,height: 52.h,),

                      Text(
                        "Invite Your Friends",
                        style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        )
                      ),
                      TextButton(
                          onPressed: () {},
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
              ),
              SizedBox(height: 13.h),
              Container(
                height: 36.h, 
                width: 337.w,
                child: TextFormField(
                  decoration: InputDecoration(
           contentPadding: EdgeInsets.only(top:4, right: 10),
                    border: OutlineInputBorder(
                     //   borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(40)),
                    prefixIcon: Icon(Icons.search),
                  //  labelStyle: TextStyle(fontSize: 12
                  //),
                    hintText: "Search",
                    hintStyle: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                       fontWeight: FontWeight.w400,
                            color:HexColor('#0C101D'))),
                  ),
                ),
              ),
              SizedBox(height: 21.h,),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 5,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         child: Column(
              //           children: [
              //             Row(
              //               children: [
              //                 CircleAvatar(
              //                   backgroundImage: NetworkImage(
              //                       "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              //                 ),
              //                 Column(
              //                   children: [
    
              //                   ],
              //                 )
              //               ],
              //             ),
              //             Divider(
              //               color: Color.fromRGBO(0, 0, 0, 0.14),
              //               height: 0,
              //               thickness: 0.5,
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          //contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: 49,
                            backgroundImage: NetworkImage(
 "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                          ),
                          title: Text("Name",style: 
                           GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                       fontWeight: FontWeight.w500,
                            color:Colors.black)),),
                          subtitle: Text("Customer",
                          style:  GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 12.sp,
                       fontWeight: FontWeight.w400,
                            color:HexColor('#0C101D'))),),
                          trailing: GestureDetector(
                            child: Image(
                              image: AssetImage(
                                  "assets/icons_assets/add_friends_button.png"),fit: BoxFit.fill,
                           
                           
                           width: 82.w,height: 26.h,),
                          ),
                        ),
 
                      ],
                    );
                  },
                ),
              ),
             ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => InviteFriends()));
                    },
                    child: Text(
                      'Get started',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        onPrimary: Colors.black,
                        //  padding: EdgeInsets.all(10),
                        minimumSize: Size(234.w, 53.h),
                        primary: Color.fromRGBO(248, 206, 97, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                  ),
             
            ],
          ),
        ),
      ),
    );
  }
}
