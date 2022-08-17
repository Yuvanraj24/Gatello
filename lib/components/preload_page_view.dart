
import 'package:flutter/material.dart';
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
  final SizingInformation sizingInformation;
  final int index;

  const PreloadPageViewWidget(
      {Key? key,
        required this.valueNotifier,
        required this.index,
        required this.sizingInformation})
      : super(key: key);

  @override
  _PreloadPageViewWidgetState createState() => _PreloadPageViewWidgetState();
}

class _PreloadPageViewWidgetState extends State<PreloadPageViewWidget> {
  late PreloadPageController preloadPageController;
  @override
  void initState() {
    preloadPageController = PreloadPageController(
        initialPage:
        widget.valueNotifier.value.item2.result[widget.index].currentPage);
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
          height: (widget.sizingInformation.deviceScreenType ==
              DeviceScreenType.desktop)
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.height / 1.5,
          child: PreloadPageView.builder(
              controller: preloadPageController,
              physics: BouncingScrollPhysics(),
              preloadPagesCount: 3,
              itemCount: widget
                  .valueNotifier.value.item2.result[widget.index].posts.length,
              onPageChanged: (page) {
                if (!mounted) return;
                setState(() {
                  widget.valueNotifier.value.item2.result[widget.index]
                      .currentPage = page;
                });
              },
              itemBuilder: (context, pageindex) {
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
                // ? FutureBuilder(
                //     future: getThumb(widget.valueNotifier.value.item2.result[widget.index].posts[pagewidget.index]),
                //     builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                //         return GestureDetector( behavior: HitTestBehavior.opaque,
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         VideoPlayerPage(stringList: widget.valueNotifier.value.item2.result[widget.index].posts)));
                //           },
                //           child: Stack(
                //             fit: StackFit.expand,
                //             children: [
                //               Image.memory(
                //                 snapshot.data!,
                //                 fit: BoxFit.cover,
                //               ),
                //               Center(
                //                   child: Icon(
                //                 Icons.play_arrow_rounded,
                //                 size: 75,
                //                 color: Color(white),
                //               ))
                //             ],
                //           ),
                //         );
                //       } else if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Center(
                //           child: Container(
                //             width: 20.0,
                //             height: 20.0,
                //             child: CircularProgressIndicator(),
                //           ),
                //         );
                //       } else {
                //         return Image.asset("assets/errorImage.jpg", fit: BoxFit.cover);
                //       }
                //     })
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
                      fit: BoxFit.cover,
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
                              fit: BoxFit.cover),
                    )
                  // child: CachedNetworkImage(
                  //   fadeInDuration: const Duration(milliseconds: 400),
                  //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                  //     child: Container(
                  //       width: 20.0,
                  //       height: 20.0,
                  //       child: CircularProgressIndicator(value: downloadProgress.progress),
                  //     ),
                  //   ),
                  //   imageUrl: widget.valueNotifier.value.item2.result[widget.index].posts[pagewidget.index],
                  //   fit: BoxFit.cover,
                  //   errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                  // ),
                );
              }),
        ),
        (widget.valueNotifier.value.item2.result[widget.index].posts.length !=
            0 &&
            widget.valueNotifier.value.item2.result[widget.index].posts
                .length !=
                1)
            ? Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.all(20),
                    shape: CircleBorder(),
                    color: (themedata.value.index == 0)
                        ? Color(white)
                        : Color(materialBlack),
                    onPressed: () {
                      preloadPageController.previousPage(
                          duration: kDuration, curve: kCurve);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white),
                    )),
                MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.all(20),
                    shape: CircleBorder(),
                    color: (themedata.value.index == 0)
                        ? Color(white)
                        : Color(materialBlack),
                    onPressed: () {
                      preloadPageController.nextPage(
                          duration: kDuration, curve: kCurve);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white),
                    )),
              ],
            ),
          ),
        )
            : Container(),
        Positioned(
            top: 10,
            right: 10,
            child: Chip(
              backgroundColor: (themedata.value.index == 0)
                  ? Color(lightGrey)
                  : Color(materialBlack),
              label: Text(
                "${widget.valueNotifier.value.item2.result[widget.index].currentPage + 1}" +
                    "/" +
                    "${widget.valueNotifier.value.item2.result[widget.index].posts.length}",
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
