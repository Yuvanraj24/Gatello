// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) =>
    json.encode(data.toJson());

class UserDetails {
  
  UserDetails({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  Result result;
  Error error;

  factory UserDetails.fromJson(Map<String,
      dynamic> json) => UserDetails(
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
    required this.profileUrl,
    required this.username,
  });

  String id;
  String userId;
  String? profileUrl;
  String username;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        userId: json["user_id"],
        profileUrl: json["profile_url"] == null ? null :
        json["profile_url"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "profile_url": profileUrl == null ? null : profileUrl,
        "username": username,
      };
}
