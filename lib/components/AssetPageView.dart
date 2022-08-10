// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Others/Structure.dart';
import '../Style/Colors.dart';
import '../Style/Text.dart';
import '../main.dart';
import 'VideoPlayerContainer.dart';

class AssetPageView extends StatefulWidget {
  final List<PlatformFile>? fileList;
  final List<String>? stringList;
  final bool showIndex;
  final void Function()? onPressed;
  const AssetPageView({Key? key, this.stringList, this.fileList, this.showIndex = true, this.onPressed}) : super(key: key);

  @override
  _AssetPageViewState createState() => _AssetPageViewState();
}

class _AssetPageViewState extends State<AssetPageView> {
  PageController pageController = PageController();
  int currentPageIndex = 0;
  List assetList = [];

  @override
  void initState() {
    assetList = widget.fileList ?? widget.stringList ?? [];
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(black),
        body: Stack(
          children: [
            PageView.builder(
                controller: pageController,
                physics: BouncingScrollPhysics(),
                itemCount: assetList.length,
                onPageChanged: (page) {
                  if (!mounted) return;
                  setState(() {
                    currentPageIndex = page;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  if (widget.fileList != null) {
                    return (assetList[pageIndex].extension!.contains("mp4") || assetList[pageIndex].extension!.contains("mpeg4"))
                        ? VideoPlayerContainer(
                      videoUrl: assetList[pageIndex].path!,
                    )
                    // : Image.network(
                    //     assetList[pageIndex],
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                    //   );
                        : Image.memory(
                      assetList[pageIndex].bytes!,
                      fit: BoxFit.contain,
                    );
                  } else {
                    return (assetList[pageIndex].toString().contains("mp4") || assetList[pageIndex].toString().contains("mpeg4"))
                        ? VideoPlayerContainer(
                      videoUrl: assetList[pageIndex],
                    )
                    // : Image.network(
                    //     assetList[pageIndex],
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                    //   );
                        : CachedNetworkImage(
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 400),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      imageUrl: assetList[pageIndex],
                      errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                    );
                  }
                }),
            (assetList.length != 0 && assetList.length != 1)
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
                        color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                        onPressed: () {
                          pageController.previousPage(duration: kDuration, curve: kCurve);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: (themedata.value.index == 0) ? Color(black) : Color(white),
                        )),
                    MaterialButton(
                        elevation: 0,
                        padding: EdgeInsets.all(20),
                        shape: CircleBorder(),
                        color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                        onPressed: () {
                          pageController.nextPage(duration: kDuration, curve: kCurve);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: (themedata.value.index == 0) ? Color(black) : Color(white),
                        )),
                  ],
                ),
              ),
            )
                : Container(),
            (widget.showIndex)
                ? Positioned(
                top: 10,
                right: 10,
                child: Chip(
                  backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                  label: Text(
                    "${currentPageIndex + 1}" + "/" + "${assetList.length}",
                    style: GoogleFonts.poppins(
                        textStyle: textStyle(
                          fontSize: 10,
                        )),
                  ),
                ))
                : Container(),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.chevron_left,
                  color: Color(white),
                  size: 40,
                ),
              ),
            ),
            (widget.stringList != null)
                ? Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () async =>
                await downloadFile(assetList[currentPageIndex], assetList[currentPageIndex].split("?").first.split("%2F").last, Theme.of(context).platform),
                icon: Icon(
                  Icons.download,
                  color: Color(white),
                  size: 40,
                ),
              ),
            )
                : Container(),
            (widget.onPressed != null)
                ? Positioned(
              bottom: 10,
              right: 10,
              child: MaterialButton(
                  elevation: 0,
                  padding: EdgeInsets.all(20),
                  shape: CircleBorder(),
                  color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                  onPressed: widget.onPressed,
                  child: Icon(
                    Icons.done,
                    color: Color(accent),
                  )),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
