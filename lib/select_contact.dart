import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/group_info_screen/group_info.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List tileData = [];
  @override
  void initState() {
    super.initState();
    tileData = selectInfoListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 18.w, bottom: 19.h, top: 24.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: Image(
                  image: AssetImage(
                    'assets/per_chat_icons/back_icon.png',
                  ),
                  width: 16.w,
                ),
                onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Group_Info()));
                },
              ),
            ],
          ),
        ),
        centerTitle: false,
        titleSpacing: -3.5.w,
        title: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Select contact',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
              SizedBox(height: 5.h),
              Text(
                '260 Participants',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 17.h, bottom: 15.h),
            child: Row(
              children: [
                Image.asset('assets/group_info/search.png'),
                SizedBox(
                  width: 18.w,
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Expanded(
          child: ListView.builder(
              itemCount: tileData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                AssetImage('assets/dp_image/dp_icon_male.png'),
                            fit: BoxFit.cover)),
                  ),
                  title: Text(
                    tileData[index].name,
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                  subtitle: Text(
                    tileData[index].account,
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 5))),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class SelectInfoListModel {
  String dp;
  String name;
  String account;
  bool isSelected;
  SelectInfoListModel(
      {required this.dp,
      required this.isSelected,
      required this.name,
      required this.account});
}

 selectInfoListData() {
  List< SelectInfoListModel> selectlistDetails = [];

   SelectInfoListModel tileData =
       SelectInfoListModel(name: '', account: '', dp: '', isSelected: false);

  tileData =  SelectInfoListModel(
      dp: 'assets/group_info/add participants.png',
      isSelected: false,
      name: 'New group',
      account: '');
   selectlistDetails.add(tileData);

//1
  tileData =  SelectInfoListModel(
      dp: 'assets/group_info/invite link.png',
      isSelected: false,
      name: 'New contact',
      account: '');
   selectlistDetails.add(tileData);
//2
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Invite friends',
      account: 'Business account');
   selectlistDetails.add(tileData);
//3
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Elumalai',
      account: 'Business account');
  selectlistDetails.add(tileData);

  //4
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Ragu',
      account: 'Business account');
   selectlistDetails.add(tileData);
  //5
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Yuvan',
      account: 'Business account');
   selectlistDetails.add(tileData);
  //6
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Elumalai',
      account: 'Business account');
  selectlistDetails.add(tileData);

  //7
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Ragu',
      account: 'Business account');
   selectlistDetails.add(tileData);
  //8
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Yuvan',
      account: 'Business account');
  selectlistDetails.add(tileData);

  //9
  tileData =  SelectInfoListModel(
      dp: 'assets/dp_image/dp_icon_male.png',
      isSelected: false,
      name: 'Elumalai',
      account: 'Business account');
 selectlistDetails.add(tileData);
  //10
  return  selectlistDetails;
}
