import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel LoginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String LoginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });

  String status;
  String message;
  Result result;
  Error error;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    required this.userId,
    required this.email,
    required this.rootFolderId,
  });

  String userId;
  String email;
  String rootFolderId;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"],
        email: json["email"],
        rootFolderId: json["root_folder_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "root_folder_id": rootFolderId,
      };
}
