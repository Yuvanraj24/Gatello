import 'dart:convert';


OwnStatus statusDataFromJson(String str) =>
    OwnStatus.fromJson(json.decode(str));

String statusDataToJson(OwnStatus data) =>
    json.encode(data.toJson());

class OwnStatus{
  String status;
  String message;
  Result data;
  Error error;
  OwnStatus({
    required this.status,
    required this.message,
    required this.data,
    required this.error,
  });

  factory OwnStatus.fromJson(Map<String,
      dynamic> json) => OwnStatus(
    status: json["status"],
    message: json["message"],
    data: Result.fromJson(json["data"]),
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
    "error": error.toJson(),
  };
}
//---------------------------------------------
class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}

//-----------------------------------------------------------
class Result {
  Result({
    required this.id,
    required this.userId,
    required this.statusText,
    required this.createAt,
    required this.viewdetails,
    required this.fontStyle,
    required this.bgColor,


  });


  String id;
  String userId;
  String statusText;
  String createAt;
  List<String> viewdetails;
  String fontStyle;
  String bgColor;


  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    userId: json["user_id"],
    statusText: json["status_text"],
    createAt:json["createAt"],
    viewdetails:List<String>.from(json["view_details"].map((x) => x)),
      bgColor:json["background_color"],
      fontStyle:json["font_style"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "status_text": statusText,
    "createAt":createAt,
    "view_details":List<dynamic>.from(viewdetails.map((x) => x)),
    "background_color":bgColor,
    "font_style":fontStyle

  };
}

//--------------------------------------------------------
// class OwnStatusId{
//   OwnStatusId({
//     required this.,
//   });
//   String userId;
//   String statusPicUrl;
//   String statusId;
//   OwnStatusClass({
//     required this.userId,
//     required this.statusPicUrl,
//     required this.statusId,
//   });
//
//   factory OwnStatusClass.fromJson(Map<String, dynamic> json) => OwnStatusClass(
//     statusId: json["_id"],
//     userId: json["user_id"],
//     statusPicUrl: json["status_post"] == null ? null : json["status_post"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": statusId,
//     "user_id": userId,
//     "status_post": statusPicUrl,
//
//   };
// }