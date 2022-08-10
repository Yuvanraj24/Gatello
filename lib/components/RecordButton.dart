import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../Others/components/LottieComposition.dart';
import '../Others/lottie_strings.dart';
import '../Style/Colors.dart';
import '../main.dart';
import 'FlowShader.dart';


class RecordButton extends StatefulWidget {
  const RecordButton({Key? key, required this.controller, required this.valueNotifier, required this.function}) : super(key: key);

  final AnimationController controller;
  final ValueNotifier<String> valueNotifier;
  final Function() function;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 65;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  Record record = Record();

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth = MediaQuery.of(context).size.width - 2 * 8 - 4;
    timerAnimation = Tween<double>(begin: timerWidth + 8, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation = Tween<double>(begin: lockerHeight + 8, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    record.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value - 2,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: (themedata.value.index == 0) ? Color(white) : Color(lightBlack),
        ),
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(FontAwesome.lock, size: 20),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FlowShader(
                direction: Axis.vertical,
                flowColors: [(themedata.value.index == 0) ? Color(black) : Color(white), Color(grey)],
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(lightGrey),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(lightGrey),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(lightGrey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value - 10,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: (themedata.value.index == 0) ? Color(white) : Color(lightBlack),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLottie
                  ? Container(
                child: lottieAnimation(dustbinGrey),
                height: 40,
                width: 40,
              )
                  : Text(recordDuration),
              const SizedBox(width: size),
              FlowShader(
                child: Row(
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Color(lightGrey),
                    ),
                    Text("Slide to cancel", style: TextStyle(color: Color(lightGrey))),
                  ],
                ),
                duration: Duration(seconds: 3),
                flowColors: [(themedata.value.index == 0) ? Color(black) : Color(white), Color(grey)],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: 0 - 10,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: (themedata.value.index == 0) ? Color(white) : Color(lightBlack),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              HapticFeedback.mediumImpact();
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";
              var filePath = await Record().stop();
              widget.valueNotifier.value = filePath!;
              widget.function();
              debugPrint(filePath);
              if (!mounted) return;
              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(recordDuration),
                FlowShader(
                  child: Text("Tap lock to stop", style: TextStyle(color: Color(lightGrey))),
                  duration: Duration(seconds: 3),
                  flowColors: [(themedata.value.index == 0) ? Color(black) : Color(white), Color(grey)],
                ),
                Center(
                  child: Icon(
                    FontAwesome.lock,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          child: Icon(
            Icons.mic,
            color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
          ),
          height: size,
          width: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(accent),
          ),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        widget.controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");

        if (isCancelled(details.localPosition, context)) {
          HapticFeedback.mediumImpact();
          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";
          if (!mounted) return;
          setState(() {
            showLottie = true;
          });
          Timer(const Duration(milliseconds: 1440), () async {
            widget.controller.reverse();
            debugPrint("Cancelled recording");
            var filePath = await record.stop();
            debugPrint(filePath);
            File(filePath!).delete();
            debugPrint("Deleted $filePath");
            showLottie = false;
          });
        } else if (checkIsLocked(details.localPosition)) {
          widget.controller.reverse();

          HapticFeedback.heavyImpact();
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          if (!mounted) return;
          setState(() {
            isLocked = true;
          });
        } else {
          widget.controller.reverse();
          HapticFeedback.mediumImpact();
          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          var filePath = await Record().stop();
          widget.valueNotifier.value = filePath!;
          widget.function();
          debugPrint(filePath);
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        widget.controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        HapticFeedback.mediumImpact();
        if (await Record().hasPermission()) {
          record = Record();
          await record.start(
            path: (await getApplicationDocumentsDirectory()).path + "/" + "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
            encoder: AudioEncoder.AAC,
            bitRate: 128000,
            samplingRate: 44100,
          );
          startTime = DateTime.now();
          timer = Timer.periodic(const Duration(seconds: 1), (_) {
            final minDur = DateTime.now().difference(startTime!).inMinutes;
            final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
            String min = minDur < 10 ? "0$minDur" : minDur.toString();
            String sec = secDur < 10 ? "0$secDur" : secDur.toString();
            if (!mounted) return;

            setState(() {
              recordDuration = "$min:$sec";
            });
          });
        }
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
