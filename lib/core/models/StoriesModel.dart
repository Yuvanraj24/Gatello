// To parse this JSON data, do
//
//     final myFeeds = storiesFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// Stories storiesFromJson(String str) => Stories.fromJson(json.decode(str));
//
// String storiesToJson(Stories data) => json.encode(data.toJson());
//
// class Stories {
//   Stories({
//     required this.status,
//     required this.message,
//     required this.result,
//     required this.error,
//   });
//
//   String status;
//   String message;
//   List<Result> result;
//   String error;
//
//   factory Stories.fromJson(Map<String, dynamic> json) => Stories(
//     status: json["status"],
//     message: json["message"],
//     result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
//     // error: Error.fromJson(json["error"]),
//     error: json["error"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "result": List<dynamic>.from(result.map((x) => x.toJson())),
//     "error": error,
//   };
// }
//
// class Error {
//   Error();
//
//   factory Error.fromJson(Map<String, dynamic> json) => Error();
//
//   Map<String, dynamic> toJson() => {};
// }
//
// class Result {
//   Result({
//     required this.id,
//     required this.userId,
//     required this.viewDetails,
//     required this.createdAt,
//     required this.status_post,
//
//   });
//
//   String id;
//   String userId;
//   List<String> viewDetails;
//   String createdAt;
//   String status_post;
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     id: json["_id"],
//     userId: json["user_id"],
//     viewDetails: List<String>.from(json["view_details"].map((x) => x)),
//     createdAt: json["createdAt"],
//     status_post: json["status_post"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user_id": userId,
//     "view_details": List<dynamic>.from(viewDetails.map((x) => x)),
//     "createdAt": createdAt,
//     "status_post": status_post,
//   };
// }
//
// class Id {
//   Id({
//     required this.oid,
//   });
//
//   String oid;
//
//   factory Id.fromJson(Map<String, dynamic> json) => Id(
//     oid: json["\u0024oid"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "\u0024oid": oid,
//   };
// }
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
Stories storiesFromJson(String str) => Stories.fromJson(json.decode(str));
String storiesToJson(Stories data) => json.encode(data.toJson());
class Stories {
  Stories({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  List<Result> result;
  String error;

  factory Stories.fromJson(Map<String, dynamic> json) => Stories(
    status: json["status"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "error": error,
  };
}
class Result {
  Result({
   required this.id,
    required this.userId,
    required this.viewDetails,
    required  this.createdAt,
    required this.statusPost,
    required this.v,
  });
  String id;
  String userId;
  List<ViewDetail> viewDetails;
  DateTime createdAt;
  String statusPost;
  int v;
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    userId: json["user_id"],
    viewDetails: List<ViewDetail>.from(json["view_details"].map((x) => ViewDetail.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    statusPost: json["status_post"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "view_details": List<dynamic>.from(viewDetails.map((x) => x.toJson())),
    "createdAt": createdAt.toIso8601String(),
    "status_post": statusPost,
    "__v": v,
  };
}
class ViewDetail {
  ViewDetail({
    required this.viewedBy,
    required this.viewedTime,
    required this.id,
  });
  String viewedBy;
  DateTime viewedTime;
  String id;
  factory ViewDetail.fromJson(Map<String, dynamic> json) => ViewDetail(
    viewedBy: json["viewed_by"],
    viewedTime: DateTime.parse(json["viewed_time"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "viewed_by": viewedBy,
    "viewed_time": viewedTime.toIso8601String(),
    "_id": id,
  };
}
