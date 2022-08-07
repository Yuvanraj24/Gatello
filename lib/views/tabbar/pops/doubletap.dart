import 'package:flutter/material.dart';



class Double_tap extends StatefulWidget {
  const Double_tap({Key? key}) : super(key: key);

  @override
  State<Double_tap> createState() => _Double_tapState();
}
class _Double_tapState extends State<Double_tap> {
  bool isLiked = false;
  bool isLikedAnimating =false;


  @override
  Widget build(BuildContext context) => buildImage();
   Widget buildImage()=>GestureDetector(
     child: Stack(alignment: Alignment.center,
       children: [AspectRatio(aspectRatio: 1,
         child: Image(image:NetworkImage('https://media.istockphoto.com/photos/big-oak-in-the-sunlight-picture-id1186742971?k=20&m=1186742971&s=170667a&w=0&h=BTcCmzMMCMXMRF9aL8rdzb6cqjHwk6_s3x0p8FwAA6U=')
         ),
       ),
         Opacity(opacity:isLikedAnimating? 1:0,
           child: LikedAnimationWidget(isAnimated:isLikedAnimating,
           alwaysAnimate:false,
           duration: Duration(milliseconds:700),
           child: Icon(Icons.favorite,color: Colors.white,size: 100),
           onEnd: ()=>setState(()=> isLikedAnimating=false,)),

         )
     ]),
     onDoubleTap: (){
       setState(() {
         isLikedAnimating=true;
         isLiked=true;
       });
     },
   );
  }


class LikedAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimated;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool alwaysAnimate;

   LikedAnimationWidget({
    Key? key,
   required this.child,
    required this.isAnimated,
    required this.duration,
     this.onEnd, required this.alwaysAnimate,
   }): super(key: key);

  @override
  State<LikedAnimationWidget> createState() => _LikedAnimationWidgetState();
  }

class _LikedAnimationWidgetState extends State<LikedAnimationWidget>
    with SingleTickerProviderStateMixin
{
  late AnimationController controller;
  late Animation<double>scale;
  @override
  void initState(){
    super.initState();
    final halfDuration=widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(vsync: this,
    duration: Duration(microseconds:halfDuration));
    scale=Tween<double>(begin: 1,end:2).animate(controller);
  }
  @override
  void didupdateWidget(LikedAnimationWidget oldwidget){
    super.didUpdateWidget(oldwidget);
    if (widget.isAnimated!=oldwidget.isAnimated){
      doAnimation();
    }
  }
  Future doAnimation() async{

    if (widget.isAnimated){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(microseconds:500));

      if(widget.onEnd!=null){
        widget.onEnd!();
    }
      }
  }
  @override
  void dispose(){
   controller.dispose();
   super.dispose();
  }

  Widget build(BuildContext context) {
    ScaleTransition(scale: scale,);
  return widget.child;
  }
}


