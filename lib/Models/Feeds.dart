// To parse this JSON data, do
//
//     final feeds = feedsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Feeds feedsFromJson(String str) => Feeds.fromJson(json.decode(str));

String feedsToJson(Feeds data) => json.encode(data.toJson());

class Feeds {
  Feeds({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  List<Result> result;
  Error error;

  factory Feeds.fromJson(Map<String, dynamic> json) => Feeds(
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
    required this.id,
    required this.userId,
    required this.username,
    required this.profileUrl,
    required this.description,
    required this.posts,
    required this.likesCount,
    required this.commentsCount,
    required this.currentPage,
    required this.likesStatus,
  });

  Id id;
  String userId;
  String username;
  String profileUrl;
  String description;
  List<String> posts;
  int likesCount;
  int commentsCount;
  int currentPage;
  bool likesStatus;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: Id.fromJson(json["_id"]),
    userId: json["user_id"],
    username: json["username"],
    profileUrl: json["profile_url"],
    description: json["description"],
    posts: List<String>.from(json["posts"].map((x) => x)),
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    currentPage: json["current_page"],
    likesStatus: json["likes_status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id.toJson(),
    "user_id": userId,
    "username": username,
    "profile_url": profileUrl,
    "description": description,
    "posts": List<dynamic>.from(posts.map((x) => x)),
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "current_page": currentPage,
    "likes_status": likesStatus,
  };
}

class Id {
  Id({
    required this.oid,
  });

  String oid;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    oid: json["\u0024oid"],
  );

  Map<String, dynamic> toJson() => {
    "\u0024oid": oid,
  };
}