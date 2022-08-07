// To parse this JSON data, do
//
//     final likeList = likeListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LikeList likeListFromJson(String str) => LikeList.fromJson(json.decode(str));

String likeListToJson(LikeList data) => json.encode(data.toJson());

class LikeList {
  LikeList({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  List<Result> result;
  Error error;

  factory LikeList.fromJson(Map<String, dynamic> json) => LikeList(
    status: json["status"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "error": error.toJson(),
  };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}

class Result {
  Result({
    required this.userId,
    required this.username,
    required this.profileUrl,
  });

  String userId;
  String username;
  String? profileUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    userId: json["user_id"],
    username: json["username"],
    profileUrl: json["profile_url"] == null ? null : json["profile_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "profile_url": profileUrl == null ? null : profileUrl,
  };
}
