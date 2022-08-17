import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';

import '../../Others/Routers.dart';
import '../../Others/exception_string.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '/core/models/profile_detail.dart'as profileDetailsModel;
class All_pops extends StatefulWidget {
  const All_pops({Key? key}) : super(key: key);

  @override
  State<All_pops> createState() => _All_popsState();
}

class _All_popsState extends State<All_pops> {
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading),

      "Loading", null));
  Future profileDetailsApiCall() async {
    print('worked');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: profileDetailsUrl,
      requestMethod: 1,
   //   body: {"user_id": (widget.userId != null) ? widget.userId : getUID(), "followee_id": ""},
      body: { "user_id":"s8b6XInslPffQEgz8sVTINsPhcx2","followee_id" : "ftP6vQPaE0eEWrgVzzu48kplEFR2"}
    );
  }

  @override
  void initState() {
    profileDetailsApiCall();
    super.initState();
  }

  @override
  void dispose() {
    profileDetailsValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [Container(color: Colors.white,
          ),
          Positioned(left:12,top: 15,
            child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
              image: DecorationImage(image:
              NetworkImage('https://cdn.bajajauto.com/-/media/Assets/bajajauto/bikes/pulsar-150/Gallery/Images/POPUP-Images/8.ashx'),
                  fit: BoxFit.fill)
            ),),
          ),
            Positioned(left:147,top: 15,
              child: Container(height:87.h,width: 112.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyamin-mellish-186077.jpg&fm=jpg'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(right:12,top: 15,
              child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/101808/pexels-photo-101808.jpeg?auto=compress&cs=tinysrgb&w=400'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(left:12,top:140,
              child: Container(height:104.h,width: 106.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(left:146,top:122,
              child: Container(
                height:101.h,width: 112.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(right:12,top:142,
              child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(left:12,top:265,
              child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(left:146,top:245,
              child: Container(height:120.h,width: 112.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
            Positioned(right:12,top:265,
              child: Container(height:102.h,width: 106.w,decoration: BoxDecoration(
                  image: DecorationImage(image:
                  NetworkImage('https://images.pexels.com/photos/3946661/pexels-photo-3946661.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                      fit: BoxFit.fill)
              ),),
            ),
          ]
        ),
      ),
    );
  }
}
