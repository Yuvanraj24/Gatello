import 'dart:io';
import 'dart:typed_data';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerContainer extends StatefulWidget {
  VideoPlayerContainer({
    this.videoAsset,
    this.videoUrl,
  });

  final String? videoAsset;

  final String? videoUrl;

  @override
  _VideoPlayerContainerState createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  late FlickManager flickManager;
  late VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {
            print("loop 1");
            _controller.setLooping(false);
            initialized = true;
          });
        });
      // _controller = VideoPlayerController.network(widget.videoUrl!)
      //   ..addListener(() => setState(() {}))
      //   ..setLooping(true)
      //   ..initialize().then((_) => _controller.play());
    } else {
      // _controller = VideoPlayerController.file(widget.videoAsset!)
      //   ..addListener(() => setState(() {}))
      //   ..setLooping(true)
      //   ..initialize().then((_) => _controller.play());
      _controller = VideoPlayerController.asset(widget.videoAsset!)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {
            print("loop 2");
            _controller.setLooping(false);
            initialized = true;
          });
        });
    }
    flickManager = FlickManager(
      videoPlayerController: _controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.currentPageIndex != null && widget.pageIndex != null) {
    //   if (widget.pageIndex == widget.currentPageIndex && initialized) {
    //     _controller.play();
    //   } else {
    //     _controller.pause();
    //   }
    // }

    return Container(
        alignment: Alignment.center,
        child: _controller.value.isInitialized
            ? VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && this.mounted) {
                flickManager.flickControlManager?.pause();
              } else if (visibility.visibleFraction == 1) {
                flickManager.flickControlManager?.play();
              }
              // if (visibility.visibleFraction != 1) {
              //   flickManager.flickControlManager?.pause();
              // } else{
              //   flickManager.flickControlManager?.play();
              // }
            },
            child: FlickVideoPlayer(flickManager: flickManager))
        // ? AspectRatio(
        //     aspectRatio: _controller.value.aspectRatio,
        //     child: VideoPlayer(_controller),
        //   )
            : Center(
          child: CircularProgressIndicator(),
        ));
  }
}
