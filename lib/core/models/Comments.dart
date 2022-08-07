// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

Comment commentsFromJson(String str) => Comment.fromJson(json.decode(str));

String commentsToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  List<Result> result;
  Error error;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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
    required this.postId,
    required this.postedBy,
    required this.content,
    required this.timeStamp,
    required this.isExpanded,
    required this.replies,
  });

  Id id;
  String postId;
  PostedBy postedBy;
  String content;
  String timeStamp;
  bool isExpanded;
  List<Reply> replies;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: Id.fromJson(json["_id"]),
    postId: json["post_id"],
    postedBy: PostedBy.fromJson(json["posted_by"]),
    content: json["content"],
    timeStamp: json["time_stamp"],
    isExpanded: json["is_expanded"],
    replies: List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id.toJson(),
    "post_id": postId,
    "posted_by": postedBy.toJson(),
    "content": content,
    "time_stamp": timeStamp,
    "is_expanded":isExpanded,
    "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
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

class PostedBy {
  PostedBy({
    required this.userId,
    required this.profilePic,
    required this.username,
  });

  String userId;
  String profilePic;
  String username;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    userId: json["user_id"],
    profilePic: json["profile_pic"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "profile_pic": profilePic,
    "username": username,
  };
}

class Reply {
  Reply({
    required this.userId,
    required this.username,
    required this.profilePic,
    required this.content,
  });

  String userId;
  String username;
  String profilePic;
  String content;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    userId: json["user_id"],
    username: json["username"],
    profilePic: json["profile_pic"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "profile_pic": profilePic,
    "content": content,
  };
}
