import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
// import 'package:deejos/Model/Default.dart';
// import 'package:deejos/Model/Exception.dart';
// import 'package:deejos/Others/ExceptionString.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
// import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:path_provider/path_provider.dart';






import '../Others/exception_string.dart';
import '../Others/logger.dart';
import '../core/models/default.dart';
import '../core/models/exception/pops_exception.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';

void valueResetter(ValueNotifier<Tuple4> valueNotifier) {
  valueNotifier.value = Tuple4(-1, exceptionFromJson(alert), "Null", null);
}

class ApiHandler {
  Map<String, String> _httpHeader({Map<String, String>? headers, String? authToken}) {
    Map<String, String> defaultHeader = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    };
    if (authToken != null) {
      defaultHeader.addAll({'authorisation': 'Bearer $authToken'});
    }
    if (headers != null) {
      defaultHeader.addAll(headers);
    }
    return defaultHeader;
  }

  Future _httpRequest({
    required Uri uri,
    required int requestMethod,
    List<Tuple4<String, Uint8List, String, String>>? formData,
    Map<String, String>? headers,
    Map<String, String>? formBody,
    String? authToken,
    Object? body,
  }) async {
    switch (requestMethod) {
      case 0:
        return await http.get(uri, headers: _httpHeader(headers: headers, authToken: authToken));

      case 1:
        {
          if (formData != null) {
            var request = new http.MultipartRequest("POST", uri);
            request.headers.addAll(_httpHeader(headers: headers, authToken: authToken));
            if (formBody != null) {
              request.fields.addAll(formBody);
            }
            for (Tuple4<String, Uint8List, String, String> tuple in formData) {
              request.files
                  .add(new http.MultipartFile.fromBytes(tuple.item1, tuple.item2, filename: tuple.item1 + ".${tuple.item4}", contentType: new MediaType(tuple.item3, tuple.item4)));
              // request.files.add(new http.MultipartFile(tuple.item1, http.ByteStream(DelegatingStream(tuple.item2.openRead()).cast()), await tuple.item2.size,
              //     filename: tuple.item1 + "_" + tuple.item2.relativePath!, contentType: new MediaType(tuple.item3, tuple.item4)));
            }
            return request.send();
          } else if (formData == null && formBody != null) {
            var request = new http.MultipartRequest("POST", uri);
            request.fields.addAll(formBody);
            return request.send();
          } else {
            if (body != null) {
              return await http.post(uri, headers: _httpHeader(headers: headers, authToken: authToken), body: jsonEncode(body));
            } else {
              return await http.post(uri, headers: _httpHeader(headers: headers, authToken: authToken));
            }
          }
        }

      case 2:
        return await http.delete(uri, headers: _httpHeader(headers: headers, authToken: authToken), body: jsonEncode(body));
    }
  }

//!this is the main handler
//! result index ==> -1->Null,0->loading,1->done,2->error,3->response error
  Future<void> apiHandler(
      {required ValueNotifier<Tuple4> valueNotifier,
      String? testJsonString,
      required Function jsonModel,
      required String url,
      required int requestMethod,
      Map<String, String>? headers,

      ///* key,file, filetype, subtype
      List<Tuple4<String, Uint8List, String, String>>? formData,
      Map<String, String>? formBody,
      String? authToken,
      Object? body,
      int? subscribedConnectivityIndex})
       async {
         ConnectivityResult? connectivityResult;
    if (subscribedConnectivityIndex == null) {
      connectivityResult = await Connectivity().checkConnectivity();
    }
    Uri uri = Uri.parse(url);
    Logger logger = Logger();
    try {
      valueNotifier.value = Tuple4(0, exceptionFromJson(loading), "Api Loading", null);
      if ((subscribedConnectivityIndex ?? connectivityResult?.index) != 4) {
        if (testJsonString == null) {
          logger.i(
            "Url\n" +
                url.toString() +
                "\n" +
                "Header\n" +
                ((headers != null) ? headers.toString() : authToken.toString()) +
                "\n" +
                "Body\n" +
                body.toString() +
                "\n" +
                "FormData\n" +
                formData.toString() +
                "\n" +
                "FormBody\n" +
                formBody.toString(),
          );
          var response = await _httpRequest(uri: uri, requestMethod: requestMethod, headers: headers, authToken: authToken, formData: formData, formBody: formBody, body: body);
          if (formData != null || formBody != null) {
            response = await http.Response.fromStream(response);
          }
          logger.i(
            "Url\n" + url.toString() + "Response\n" + response.body.toString() + "Status\n" + response.statusCode.toString(),
          );
          if (response.statusCode == 200) {
            var jsonResponse = json.decode(response.body);
            inspect(jsonResponse);
            if (jsonResponse["status"].toString() == "OK") {
              valueNotifier.value = Tuple4(1, jsonModel(utf8.decode(Runes(response.body).string.codeUnits)), jsonResponse["message"].toString(), jsonResponse);
            } else if (jsonResponse["statusCode"] == "200") {
              valueNotifier.value = Tuple4(1, jsonModel(utf8.decode(Runes(response.body).string.codeUnits)), jsonResponse["statusMessage"].toString(), jsonResponse);
            } else {
              String? message = jsonResponse["message"] == null ? null : jsonResponse["message"];
              valueNotifier.value =
                  (message != null) ? Tuple4(3, defaultFromJson(response.body), message, jsonResponse) : Tuple4(2, exceptionFromJson(alert), "Something went wrong!", null);
            }
          } else {
            switch (response.statusCode) {
              case 404:
                {
                  valueNotifier.value = Tuple4(2, exceptionFromJson(notFound), response.reasonPhrase!, null);
                }
                break;

              case 500:
                {
                  valueNotifier.value = Tuple4(2, exceptionFromJson(serverError), response.reasonPhrase!, null);
                }
                break;

              default:
                {
                  valueNotifier.value = Tuple4(2, exceptionFromJson(invalid), response.reasonPhrase!, null);
                }
                break;
            }
          }
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            valueNotifier.value = Tuple4(1, jsonModel(testJsonString), "Testing Purposes", json.decode(testJsonString));
          });
        }
      } else {
        valueNotifier.value = Tuple4(2, exceptionFromJson(noNetwork), "No Connectivity", null);
      }
    } catch (e) {
      valueNotifier.value = Tuple4(2, exceptionFromJson(alert), e.toString(), null);
    }
    logger.i(valueNotifier.value.toString());
  }
}

// Future<File> uint8listToFile({required String name, String ext = 'jpg', required Uint8List uint8list}) async {
//   Uint8List imageInUnit8List = uint8list;
//   final tempDir = await getTemporaryDirectory();
//   File file = await File(imageInUnit8List, '${tempDir.path}/$name.$ext');
//   // file.writeAsBytesSync(imageInUnit8List);
//   return file;
// }

// Future<Uint8List> getHtmlFileContent(File blob) async {
//   Uint8List? file;
//   final reader = FileReader();
//   reader.readAsDataUrl(blob.slice(0, blob.size, blob.type));
//   reader.onLoadEnd.listen((event) {
//     Uint8List data = Base64Decoder().convert(reader.result.toString().split(",").last);
//     file = data;
//   }).onData((data) {
//     file = Base64Decoder().convert(reader.result.toString().split(",").last);
//     // return file;
//   });
//   while (file == null) {
//     await new Future.delayed(const Duration(milliseconds: 1));
//     if (file != null) {
//       break;
//     }
//   }
//   return file!;
// }
// Future<Uint8List?> getThumb(String url) async {
//   return await VideoThumbnail.thumbnailData(
//     video: url,
//     imageFormat: ImageFormat.JPEG,
//   );
// }
