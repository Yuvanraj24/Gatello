import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import '../../../Others/Routers.dart';
import '../../../Others/exception_string.dart';
import '../../../core/models/exception/pops_exception.dart';
import '../../../handler/Network.dart';
import '/core/models/Likes_List.dart'as likeListModel;
class pop_Likes extends StatefulWidget {
  final String Id;
  const pop_Likes({Key? key,required this.Id}) : super(key: key);

  @override
  State<pop_Likes> createState() => _pop_LikesState();
}
class _pop_LikesState extends State<pop_Likes> {

  bool following=false;
  TextEditingController _controller6 =TextEditingController();
  ValueNotifier<Tuple4> likeListValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  Future likeListApiCall() async {
    return await ApiHandler().apiHandler(
      valueNotifier: likeListValueNotifier,
      jsonModel: likeListModel.likeListFromJson,
      url: likeListUrl,
      requestMethod: 1,
      body: {"post_id": widget.Id},
    );
  }
  _onPressed(){
    setState(() {
      following=!following;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: likeListApiCall(),
      builder: (context,_) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(onTap:(){
              Navigator.pop(context);
            },child: Icon(Icons.arrow_back,color: Color.fromRGBO(12, 16, 29, 1),)),
            title: InkWell(
              onTap: (){
                print('dhina:${likeListValueNotifier.value.item2.result.length}');
              },
              child: Text('Pop Likes',style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,fontSize: 24.sp,color: Color.fromRGBO(0, 0, 0, 1)
                )
              ),),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top:17,left:10,right: 11),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h,),
                        Text('People who likes this pop',style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,fontSize: 20.sp,color: Color.fromRGBO(0, 0, 0, 1)
                            )
                        )),
                         SizedBox(height: 8,),
                        Container(child:Center(
                          child: Text('3.6k',style: GoogleFonts.inter(
                            textStyle: TextStyle(color: Color.fromRGBO(104, 104, 104, 1),fontSize:14,fontWeight: FontWeight.w400)
                          ),),
                        ),
                            height: 20.h,width: 51.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(255, 255, 255, 1),
                          border: Border.all(width: 1,color: Color.fromRGBO(152, 148, 148, 1),),

                        )
                        )
                      ],
                    ),
                   Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right:11),
                      child: Container(height: 54.h,width: 72.h,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            image:DecorationImage(image: NetworkImage('https://wallpaper-house.com/data/out/8/wallpaper2you_216880.jpg'),
                            fit: BoxFit.fill) ),
                      ),
                    )
                  ],
                ),
                SizedBox(height:8.h),
                TextField(
                  controller: _controller6,
                  decoration: InputDecoration(
                    hintText: 'Peter Parker',
                    hintStyle: GoogleFonts.inter(
                      textStyle: TextStyle(color: Color.fromRGBO(118, 118, 118, 1),
                      fontWeight: FontWeight.w400,fontSize:14)
                    ),
                    prefixIcon: Icon(Icons.search_rounded,size: 35,color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(217, 217, 217, 1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(217, 217, 217, 1),width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(217, 217, 217, 1),width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                Expanded(
                  child: ListView.builder(
                    itemCount:  likeListValueNotifier.value.item2.result.length,
                      itemBuilder: (context,index){
                   return ListTile(
                     trailing: ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0),elevation: 0,
                       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       primary: Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(76.w, 32.h),
                     ),
                         onPressed: (){
                       _onPressed();

                         }, child: Text(following? 'Following':'Follow' ,style: GoogleFonts.inter(
                             textStyle: TextStyle(
                                 color:following? Color.fromRGBO(0, 0, 0, 1) :Color.fromRGBO(0, 163, 255, 1),fontSize: 12.sp,fontWeight: FontWeight.w700
                             )
                         ),)),
                     leading: Container(
                       height: 57.h,width: 57.w,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7),
                           image: DecorationImage(image: NetworkImage(likeListValueNotifier.value.item2.result[index].profileUrl),
                               fit: BoxFit.fill)
                       ),
                     ),
                     title: Text(likeListValueNotifier.value.item2.result[index].username,style: GoogleFonts.inter(
                         textStyle: TextStyle(
                             fontSize: 16.sp,fontWeight: FontWeight.w700,
                             color: Color.fromRGBO(0, 0, 0, 1)
                         )
                     ),),
                     subtitle:Text('Peter',style: GoogleFonts.inter(
                         textStyle: TextStyle(fontWeight: FontWeight.w400,
                             color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                         )
                     ),) ,
                   );
                  }),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
