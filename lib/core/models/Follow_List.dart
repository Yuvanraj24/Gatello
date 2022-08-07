// To parse this JSON data, do
//
//     final followList = followListFromJson(jsonString);

import 'dart:convert';

FollowList followListFromJson(String str) => FollowList.fromJson(json.decode(str));

String followListToJson(FollowList data) => json.encode(data.toJson());

class FollowList {
  FollowList({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  List<Result> result;
  Error error;

  factory FollowList.fromJson(Map<String, dynamic> json) => FollowList(
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
    required this.name,
    required this.profilePic,
  });

  String userId;
  String name;
  String? profilePic;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    userId: json["user_id"],
    name: json["name"],
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "profile_pic": profilePic == null ? null : profilePic,
  };
}
