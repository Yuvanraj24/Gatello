// To parse this JSON data, do
//
//     final default = defaultFromJson(jsonString);

import 'dart:convert';

Default defaultFromJson(String str) => Default.fromJson(json.decode(str));

String defaultToJson(Default data) => json.encode(data.toJson());

class Default {
  Default({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
