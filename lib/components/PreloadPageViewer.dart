import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tuple/tuple.dart';

import '../Others/Structure.dart';
import '../Style/Colors.dart';
import '../Style/Text.dart';
import '../main.dart';
import 'AssetPageView.dart';

class PreloadPageViewWidget extends StatefulWidget {
  final ValueNotifier<Tuple4> valueNotifier;
  //final SizingInformation sizingInformation;
  final int index;

  const PreloadPageViewWidget({Key? key, required this.valueNotifier, required this.index}) : super(key: key);

  @override
  _PreloadPageViewWidgetState createState() => _PreloadPageViewWidgetState();
}

class _PreloadPageViewWidgetState extends State<PreloadPageViewWidget> {
  late PreloadPageController preloadPageController;
  @override
  void initState() {
    preloadPageController = PreloadPageController(initialPage: widget.valueNotifier.value.item2.result[widget.index].
    currentPage);
    super.initState();
  }

  @override
  void dispose() {
    preloadPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(

         // color: Colors.pink.shade50,
                          height: 259.h,
                          width: MediaQuery.of(context).size.width,

child: CarouselSlider.builder(itemCount:  widget.valueNotifier.value.item2.result[widget.index].posts.length,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              aspectRatio: 16/9,
              viewportFraction: 2,
            ),
    itemBuilder: (context,itemIndex, pageindex){

      return (widget.valueNotifier.value.item2.result[widget.index]
          .posts[pageindex]
          .toString()
          .contains("mp4") ||
          widget.valueNotifier.value.item2.result[widget.index]
              .posts[pageindex]
              .toString()
              .contains("mpeg4"))
          ? GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AssetPageView(
                      stringList: widget.valueNotifier.value
                          .item2.result[widget.index].posts)));
        },
        child: Stack(
          children: [
            Container(
              color: Color(materialBlack),
            ),
            Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 75,
                  color: Color(white),
                ))
          ],
        ),
      )
          : GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AssetPageView(
                        stringList: widget.valueNotifier.value
                            .item2.result[widget.index].posts)));
          },
          child: Image.network(

            widget.valueNotifier.value.item2.result[widget.index]
                .posts[pageindex],

            fit: BoxFit.fitHeight,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes !=
                      null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                Image.asset("assets/noProfile.jpg",
                    fit: BoxFit.fill
                ),
          )

      );
    }),

        ),

        Positioned(
            top: 10,
            right: 10,
            child: Chip(
              backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
              label: Text(
                "${widget.valueNotifier.value.item2.result[widget.index].currentPage + 1}" +
                    "/" + "${widget.valueNotifier.value.item2.result[widget.index].posts.length}",
                style: GoogleFonts.poppins(
                    textStyle: textStyle(
                      fontSize: 10,
                    )),
              ),
            ))
      ],
    );
  }
}
