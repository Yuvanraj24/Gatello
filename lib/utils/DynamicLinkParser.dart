
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';


class ShareableLink {
  final String baseUrl = "https://gatello.page.link/";
  late DynamicLinkParameters parameters;

  ShareableLink(String title, String description, String link, String? imageUrl) {
    parameters = DynamicLinkParameters(
      uriPrefix: baseUrl,
      link: Uri.parse(link),
      androidParameters: AndroidParameters(
        packageName: 'com.deejos.gatello',
        minimumVersion: 1,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: iosBundleId,
      //   minimumVersion: '2',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(title: title, description: description, imageUrl: (imageUrl != null) ? Uri.parse(imageUrl) : null),
    );
  }

  Future<Uri> createDynamicLink({bool short = false}) async {
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }
    return url;
  }
}

class DynamicLinkHandler {
  handleDynamicLink(BuildContext context) async {
    // final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    // if (data == null) return;
    // _handleDeepLink(data, context);
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      _handleDeepLink(event, context);
    });
  }

  _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
    final Uri deepLink = data.link;
    print(deepLink);
    print("Inside handle deep link $deepLink");
    //Navigate to particular page
    if (deepLink.toString().contains("/details/post")) {
      // UrlParser url = UrlParser(deepLink.toString(), postDetailsUrl);
      // var postId = url.getQueryParameter("post_id");
      if (ModalRoute.of(context)?.settings.name == '/postDetails') {
        //return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostDetails(postId: deepLink.toString().split("post_id=").last)));
      } else {
        //return Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetails(postId: deepLink.toString().split("post_id=").last)));
      }
    }
  }

  Future shareLink(String title, String description, String link, String? imageUrl, {bool shortLink = true}) async {
    ShareableLink _shareableLink = ShareableLink(title, description, link, imageUrl);
    Uri _link = await _shareableLink.createDynamicLink(short: shortLink);

  }
}

/* Future<void> share(
    String title, String text, String url, String chooserTitle) async {
  await FlutterShare.share(
      title: title, text: text, linkUrl: url, chooserTitle: chooserTitle);
} */