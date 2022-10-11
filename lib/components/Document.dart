
import 'package:flutter/material.dart';

import '../Assets/GatelloIcon.dart';
import '../Others/Structure.dart';
import '../Style/Colors.dart';
import '../main.dart';

class DocumentDownloader extends StatefulWidget {
  final String url;
  const DocumentDownloader({Key? key, required this.url}) : super(key: key);

  @override
  _DocumentDownloaderState createState() => _DocumentDownloaderState();
}

class _DocumentDownloaderState extends State<DocumentDownloader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipOval(
              child: Material(
                color: Color(accent),
                child: Container(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Icon(Icons.folder, color: (themedata.value.index == 0) ? Color(white) : Color(black)),
                    )),
              ),
            ),
          ),
          Flexible(child: Text(widget.url.split("?").first.split("%2F").last)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: Icon(Icons.download),
              onPressed: () async {
                print('ffffffffffff');
                await downloadFile(widget.url, widget.url.split("?").first.split("%2F").last, Theme.of(context).platform);
              },
            ),
          )
        ],
      ),
    );
  }
}
