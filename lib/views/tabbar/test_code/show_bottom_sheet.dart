import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowBottomSheet extends StatefulWidget {
  const ShowBottomSheet({Key? key}) : super(key: key);

  @override
  State<ShowBottomSheet> createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Sheet"),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            //my function--------------------------------------------------------
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 270,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: Color.fromRGBO(246, 207, 70, 1))),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      margin: EdgeInsets.all(30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/document_icon_container.png",
                                    "Document"),
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/camera_icon_container.png",
                                    "Camera"),
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/gallery_icon_container.png",
                                    "Gallery")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/audio_icon_container.png",
                                    "Audio"),
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/location_icon_container.png",
                                    "Location"),
                                iconCreation(
                                    "assets/tabbar_icons/chats_image/attachment_icon_container/contact_icon_container.png",
                                    "Contact")
                              ],
                            )
                          ]),
                    ),
                  );
                });
          },
          child: Text("show"),
        ),
      ),
    );
  }
  Widget iconCreation(String iconContainer, String text) {
  return Column(
    children: [
      // ElevatedButton(onPressed: (){

      // },
      // style: ElevatedButton.styleFrom(
      //   shape: CircleBorder(),
      //   side: BorderSide(
      //     color: Colors.red
      //   )
      // ),
      // child: Icon(Icons.abc)),
      //---------------------------------------------

      // Container(
      //   width: 60,
      //   height: 60,
      //   decoration: BoxDecoration(
      //     color: color,
      //     shape: BoxShape.rectangle
      //   ),
      //   child: Icon(icon),
      // ),
      //---------------------------------------------

      Image(
        image: AssetImage(iconContainer),
        width: 52.w,
        height: 47.h,
      ),
      SizedBox(height: 9.h),
      Text(text,
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400))),
    ],
  );
}

}
