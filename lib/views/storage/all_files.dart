import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/storage/details_share.dart';
import 'package:google_fonts/google_fonts.dart';

class Allstorage extends StatefulWidget {
  const Allstorage({Key? key}) : super(key: key);
  @override
  State<Allstorage> createState() => _AllstorageState();
}
class _AllstorageState extends State<Allstorage> {

  List name=[];
  List fileName=["Create New Folder","Family","Album"];

  TextEditingController allshare=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:name.isEmpty
            ?GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset('assets/storage_assets/back-icon.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ):GestureDetector(onTap: (){
          setState(() {
            name.clear();
          });
        },
            child: Icon(Icons.close,color:Colors.black,size:26)),
        title: Text(name.isEmpty?'Storage':'${name.length} Item', style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 1)))),
        actions: [PopupMenuButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              iconSize:30,icon:Icon(Icons.more_vert,color: Colors.black,),
              itemBuilder: (context) => [
                PopupMenuItem(child: Center(child: Text('Settings',style: GoogleFonts.inter(textStyle:
                TextStyle(fontWeight: FontWeight.w400,fontSize:14, color: Color.fromRGBO(0,0,0,1))
                  ))))])],
      ),
      body:Container(padding:EdgeInsets.fromLTRB(12.w,24.h,12.w,0.h),
          child:Column(children: [
            Row(children: [
            Text('All files',style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w500,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
            SizedBox(width:5.w),
            Text('( 200 )',style:GoogleFonts.inter(textStyle:TextStyle(
                fontWeight:FontWeight.w500,color:Color.fromRGBO(108, 108, 108, 1),fontSize:12.sp)))]),
            SizedBox(height:15.h),
            Container(height:37.h,width:350.w, decoration: BoxDecoration(
               borderRadius:BorderRadius.circular(4),border:Border.all(color:
            Color.fromRGBO(200, 200, 200, 1),width:1.w)),
              child: Row(children: [
                SizedBox(width:18.w),
                Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                  children: [SvgPicture.asset('assets/pops_asset/searchicon.svg',height:18.h,width:18.w)]),
                Container(padding: EdgeInsets.fromLTRB(18.w,18.h,0.w,0.h),height:35.h,width:200.w,
                  child: TextField(controller:allshare,cursorColor:Colors.black,
                    decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.w,
                                color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
                        hintText:'Search...',hintStyle:GoogleFonts.inter(textStyle:TextStyle(fontWeight:
                        FontWeight.w400,fontSize: 14.sp, color: Color.fromRGBO(158, 148, 148, 1))))))
              ],)),
            SizedBox(height:21.h),
            Expanded(
              child: GridView.builder(itemCount:fileName.length,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3),
                 shrinkWrap:true,itemBuilder: (context,index){
                return fileManager(index);}),
            )
          
          
          ])),
    );
  }


  Widget fileManager(int index){
    return AbsorbPointer(absorbing:index==0?true:false,
      child: GestureDetector(onLongPress:(){
       setState(() {
         if(name.contains(fileName[index])){
           name.remove(fileName[index]);
         }
         else{
           name.add(fileName[index]);
         };
       });
        showModalBottomSheet(
          barrierColor: Colors.transparent,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                    context: context,builder: (context) {
               return selectedMenu();
          });},
        child: Container(height:115.h,width:113.w,decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(7),
          color:name.contains(fileName[index])?Color.fromRGBO(0, 163, 255, 0.22):
              Colors.transparent
        ),
          child: Column(
              children: [SvgPicture.asset(fileName[index]=="Create New Folder"?
              "assets/storage_assets/create_folder.svg":
              'assets/storage_assets/filemanager_icon.svg'),
                SizedBox(height:17.h),
                Text(fileName[index],textAlign:TextAlign.center,style:GoogleFonts.inter(textStyle:TextStyle(
                    fontWeight:FontWeight.w400,color:Color.fromRGBO(0,0,0,1),fontSize:14.sp))),
              ]),
        ),
      ),
    );}

  Widget selectedMenu(){
    return Container(height:440.h,
      padding:EdgeInsets.fromLTRB(12.w,30.h,12.w,0.h),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
        Divider(thickness:2,indent:150.w,endIndent:150.w,color:Colors.black),
        GestureDetector(onTap:(){Navigator.push(context, MaterialPageRoute(builder:
        (context) =>Share()));},
          child: Text('Share',style:GoogleFonts.inter(textStyle:TextStyle(
      fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        ),
        SizedBox(height:28.h),
        Text('Rename',style:GoogleFonts.inter(textStyle:TextStyle(
            fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        SizedBox(height:22.h),
        Divider(thickness:1,color:Color.fromRGBO(235, 235, 235, 1)),
        SizedBox(height:18.h),
        Text('Copy link ',style:GoogleFonts.inter(textStyle:TextStyle(
            fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        SizedBox(height:24.h),
        Divider(thickness:1,color:Color.fromRGBO(235, 235, 235, 1)),
        SizedBox(height:24.h),
        Text('Move',style:GoogleFonts.inter(textStyle:TextStyle(
            fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        SizedBox(height:28.h),
        GestureDetector(onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:
              (context) =>Details()));
        },
          child: Text('Details',style:GoogleFonts.inter(textStyle:TextStyle(
              fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        ),
        SizedBox(height:28.h),
        GestureDetector(
          onTap:() {
             showDialog(context: context, builder: (context) {
              return AlertDialog(shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20)
              ),
                title:Text('Are you sure you want remove this...',style:TextStyle(
                    fontSize:20.sp,color:Color.fromRGBO(0,0,0,1))),
                content:Text('If you remove once, the file will be stored in trash.',style:
                  TextStyle(color:Color.fromRGBO(156, 156, 156, 1),fontSize:14.sp)),
                actions: [
                  ElevatedButton(
                      onPressed: () {Navigator.pop(context);},style:ElevatedButton.styleFrom(primary:Colors.white,
                      elevation:0,shape:CircleBorder()),
                      child: Text('Cancel',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                          color:Color.fromRGBO(0, 0, 0, 1)))),
                  ElevatedButton(
                      onPressed: () {Navigator.pop(context);},style:ElevatedButton.styleFrom(primary:Colors.white,
                      elevation:0,shape:CircleBorder()),

                      child: Text('OK',style:TextStyle(fontWeight:FontWeight.w700,fontSize:14.sp,
                          color:Color.fromRGBO(0, 0, 0, 1))))
                ],
              );
            },);
          },
          child: Text('Remove',style:GoogleFonts.inter(textStyle:TextStyle(
              fontWeight:FontWeight.w700,color:Color.fromRGBO(0,0,0,1),fontSize:20.sp))),
        ),


      ]),
    );
  }
}


