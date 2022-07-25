import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact_model.dart';
import 'package:google_fonts/google_fonts.dart';
class ContactCard extends StatelessWidget {
  const ContactCard({Key?  key,required this.contacts}) : super(key: key);
  final SelectContactModel contacts;

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
          subtitle: Text(
            contacts.account,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(134, 134, 134, 1))),
          ),
        ),
      );
  }
}
