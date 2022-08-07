// To parse this JSON data, do
//
//     final postDetail = postDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PostDetail postDetailFromJson(String str) => PostDetail.fromJson(json.decode(str));

String postDetailToJson(PostDetail data) => json.encode(data.toJson());

class PostDetail {
  PostDetail({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  Result result;
  Error error;

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
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
  });

  String id;
  String userId;
  String username;
  String? profileUrl;
  String description;
  List<String> posts;
  int likesCount;
  int commentsCount;
  int currentPage;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    userId: json["user_id"],
    username: json["username"],
    profileUrl: json["profile_url"] == null ? null : json["profile_url"],
    description: json["description"],
    posts: List<String>.from(json["posts"].map((x) => x)),
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    currentPage: json["current_page"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "username": username,
    "profile_url": profileUrl == null ? null : profileUrl,
    "description": description,
    "posts": List<dynamic>.from(posts.map((x) => x)),
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "current_page": currentPage,
  };
}
