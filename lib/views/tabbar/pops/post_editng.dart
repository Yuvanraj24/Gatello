

import 'package:flutter/material.dart';


class Post_Image extends StatefulWidget {
  const Post_Image({Key? key}) : super(key: key);

  @override
  State<Post_Image> createState() => _Post_ImageState();
}
class _Post_ImageState extends State<Post_Image> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.check)),
            Image(image: NetworkImage('assets/splash2_image/splah2 _image.png')
            )
            // CachedNetworkImage(
            //   fit: BoxFit.cover,
            //
            //   fadeInDuration: const Duration(milliseconds: 400),
            //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            //     child: Container(
            //
            //       width: 20.0,
            //       height: 20.0,
            //       child: CircularProgressIndicator(value: downloadProgress.progress),
            //     ),
            //   ),
            //   imageUrl: 'assets/splash2_image/splah2 _image.png',
            //   errorWidget: (context, url, error)
            //   => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
            // )
          ],
        ),
      ),
    );
  }
}
