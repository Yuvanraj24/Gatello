import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/pops_model/interactions_model.dart';



// import '../../../core/models/pops_model/interactions_model.dart';

class Inter_Actions extends StatefulWidget {
  const Inter_Actions({Key? key}) : super(key: key);

  @override
  State<Inter_Actions> createState() => _Inter_ActionsState();
}

class _Inter_ActionsState extends State<Inter_Actions> {
  String? imageurl;
  String? name;
  String? notifications;
  String?  timing;

  List<InteractionsModel> dataModel=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataModel=interactiondata();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(12, 16, 29, 1),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interactions',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                        color: Color.fromRGBO(12, 16, 29, 1))),
              ),
              Text(
                'Likes & Comments',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: Color.fromRGBO(109, 109, 109, 1))),
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 15),
                child: Text(
                  'Today',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ),
              SizedBox(height: 14.h,),
              Expanded(
                child: ListView.builder(
                  itemCount:2,
                  itemBuilder: (context, index) {
                  return inter_Actions(dataModel[index].imageurl,dataModel[index].name,dataModel[index].notification,dataModel[index].timing);
                },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget inter_Actions (img,name,notifi,time){
  return Column(
    children: [
      Row(
        children: [
          Container(
            height: 70.h,
            width: 10.w,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 163, 255, 1),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    topRight: Radius.circular(4))),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        img),fit: BoxFit.fill)),
          ),
          SizedBox(
            width: 27.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                notifi,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Color.fromRGBO(45, 45, 45, 1))),
              ),
            ],
          ),
          SizedBox(
            width: 105.w,
          ),
          Text(
            time,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: Color.fromRGBO(161, 161, 161, 1))),
          )
        ],
      ),
      Divider(
        thickness: 2,
        indent:12 ,
        endIndent: 12,
        color: Color.fromRGBO(244, 244, 244, 1),
      ),
      SizedBox(
        height:15.h,
      ),
    ],
  );
}