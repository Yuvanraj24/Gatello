import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../Helpers/DateTimeHelper.dart';
import '../Others/Structure.dart';
import '../Style/Colors.dart';
import '../Style/Text.dart';
import '../main.dart';

class PlayAudio extends StatefulWidget {
  final String url;
  final String? profilePic;
  //0=audio 1=voice
  final int type;
  //0=user 1=peer
  final int? state;
  const PlayAudio({Key? key, required this.url, this.profilePic, required this.type, this.state}) : super(key: key);

  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> with TickerProviderStateMixin {
  //for audio files
  AnimationController? _animationIconController1;
  AudioCache? audioCache;
  AudioPlayer? audioPlayer;
  Duration _duration =  Duration();
  Duration _position =  Duration();
  Duration _slider =  Duration(seconds: 0);
  double? durationValue;
  bool isSongPlaying = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    //for audio inside initState
    _position = _slider;
    _animationIconController1 = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 750),
      reverseDuration: new Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    audioPlayer!.onDurationChanged.listen((Duration d) {
      if (!mounted) return;
      setState(() {
        _duration = d;
        durationValue = d.inSeconds.toDouble();
      });
    });

    audioPlayer!.onAudioPositionChanged.listen((Duration p) {
      if (!mounted) return;
      setState(() {
        _position = p;
        if (_position.inSeconds == _duration.inSeconds) {
          _position = _slider;
          isPlaying = false;
          isSongPlaying = false;
          _animationIconController1!.reverse();
        }
      });
    });
    print('audio widget: ' + widget.url);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer!.dispose();
  }

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer!.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          (widget.type == 0)
              ? ClipOval(
            child: Material(
              color: Color(accent),
              child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Icon(Icons.headphones, color: (themedata.value.index == 0) ? Color(white) : Color(black)),
                  )),
            ),
          )
              : Container(),
          (widget.type == 1 && widget.state == 0)
              ? Stack(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    // peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                    // peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                    child: (widget.profilePic != null)
                    // ? Image.network(
                    //     chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                    //     fit: BoxFit.cover,
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null
                    //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    //               : null,
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                    //   )
                        ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      imageUrl: widget.profilePic!,
                      errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                    )
                        : Image.asset("assets/profile_page/profile_pic_logo.png", fit: BoxFit.cover),
                  )),
              Positioned(bottom: 0, right: 0, child: Icon(Icons.mic, color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white)))
            ],
          )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                if (!mounted) return;

                setState(() {
                  isPlaying ? _animationIconController1!.reverse() : _animationIconController1!.forward();
                  isPlaying = !isPlaying;
                });
                if (!isSongPlaying) {
                  audioPlayer!.play('${widget.url}');
                  if (!mounted) return;

                  setState(() {
                    isSongPlaying = true;
                  });
                } else {
                  audioPlayer!.pause();
                  if (!mounted) return;

                  setState(() {
                    isSongPlaying = false;
                  });
                }
              },
              child: ClipOval(
                child: Container(
                  color: Color(yellow),
                  // color: themedata.value.index == 0 ? Color(black) : Color(white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      size: 14,
                      progress: _animationIconController1!,
                      color: themedata.value.index == 0 ? Color(white) : Color(black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: (!kIsWeb)
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Slider(
                    activeColor: Color(grey),
                    inactiveColor: Color(lightGrey),
                    thumbColor: Color(yellow),
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (double value) {
                      seekToSeconds(value.toInt());
                      _position = value as Duration;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    formatDuration(_position),
                    style: textStyle(fontSize: 10),
                  ),
                ),
              ],
            )
                : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(formatDuration(_position)),
            ),
          ),
          (widget.type == 0)
              ? Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () async {
                await downloadFile(widget.url, widget.url.split("?").first.split("%2F").last, Theme.of(context).platform);
              },
              child: ClipOval(
                child: Container(
                  color: Color(yellow),
                  // color: themedata.value.index == 0 ? Color(black) : Color(white),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.download,
                        size: 13,
                        color: themedata.value.index == 0 ? Color(white) : Color(black),
                      )),
                ),
              ),
            ),
          )
              : Container(),
          (widget.type == 1 && widget.state == 1)
              ? Stack(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    // peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                    // peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                    child: (widget.profilePic != null)
                    // ? Image.network(
                    //     chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                    //     fit: BoxFit.cover,
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null
                    //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    //               : null,
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                    //   )
                        ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      imageUrl: widget.profilePic!,
                      errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                    )
                        : Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                  )),
              Positioned(bottom: 0, right: 0, child: Icon(Icons.mic, color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white)))
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}
// Text(widget.url.split("/").last)
