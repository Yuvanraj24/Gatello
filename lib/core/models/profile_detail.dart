
import 'dart:convert';

ProfileDetails profileDetailsFromJson(String str) =>
    ProfileDetails.fromJson(json.decode(str));

String profileDetailsToJson(ProfileDetails data) =>
    json.encode(data.toJson());

class ProfileDetails {
  ProfileDetails({
    required this.status,
    required this.message,
    required this.result,
    required this.error,
  });
  String status;
  String message;
  Result result;
  Error error;
  factory ProfileDetails.fromJson(Map<String,
      dynamic> json) => ProfileDetails(
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
    required this.profileDetails,
    required this.isFollowing,
  });

  ProfileDetailsClass profileDetails;
  bool isFollowing;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    profileDetails: ProfileDetailsClass.fromJson
      (json["profile_details"]),
    isFollowing: json["isFollowing"],
  );
  Map<String, dynamic> toJson() => {
    "profile_details": profileDetails.toJson(),
    "isFollowing": isFollowing,
  };
}

class ProfileDetailsClass {
  ProfileDetailsClass(
      {
        required this.id,
        required this.userId,
        required this.name,
        this.profileUrl,
        this.coverUrl,
        required this.phone,
        this.dob,
        required this.email,
        required this.username,
        required this.password,
        required this.isLoggedIn,
        required this.myFeeds,
        required this.followingCount,
        required this.followersCount,
        required this.postsCount,
        this.about,
        this.city,
        this.college,
        this.company,
        this.designation,
        this.highSchool,
        this.interest,
        this.job,
        required this.member,
        this.relationshipStatus,
        this.notificationToken,
        this.gender,
        //   required this.languageKnown,
        required this.website,
        required this.skills,
        //   required this.workExperience,


      });

  String id;
  String userId;
  String name;
  String? profileUrl;
  String? coverUrl;
  String phone;
  String? dob;
  String email;
  String username;
  String password;
  bool isLoggedIn;
  List<dynamic> myFeeds;
  int followingCount;
  int followersCount;
  int postsCount;
  String? about;
  String? city;
  String? college;
  String? company;
  String? designation;
  String? highSchool;
  String? interest;
  String? job;
  String member;
  String? relationshipStatus;
  String? notificationToken;
  String? gender;
  // List<dynamic> languageKnown;
  List<dynamic> website;
  List<dynamic> skills;
  // List<dynamic> workExperience;

  factory ProfileDetailsClass.fromJson(Map<String, dynamic> json) => ProfileDetailsClass(
    id: json["_id"],
    userId: json["user_id"],
    name: json["name"],
    profileUrl: json["profile_url"] == null ? null : json["profile_url"],
    coverUrl: json["cover_url"] == null ? null : json["cover_url"],
    phone: json["phone"],
    dob: json["dob"] == null ? null : json["dob"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    isLoggedIn: json["is_Logged_in"],
    myFeeds: List<dynamic>.from(json["my_feeds"].map((x) => x)),
    followingCount: json["following_count"],
    followersCount: json["followers_count"],
    postsCount: json["posts_count"],
    about: json["about"] == null ? null : json["about"],
    city: json["city"] == null ? null : json["city"],
    college: json["college"] == null ? null : json["college"],
    company: json["company"] == null ? null : json["company"],
    designation: json["designation"] == null ? null : json["designation"],
    highSchool: json["high_school"] == null ? null : json["high_school"],
    interest: json["interest"] == null ? null : json["interest"],
    job: json["job"] == null ? null : json["job"],
    member: json["member"],
    relationshipStatus: json["relationship_status"] == null ? null : json["relationship_status"],
    notificationToken: json["notification_token"] == null ? null : json["notification_token"],
    gender: json["gender"],
    //  languageKnown: List<dynamic>.from(json["languageKnown"].map((x) => x)),
    website: List<dynamic>.from(json["website"].map((x) => x)),
    skills: List<dynamic>.from(json["skills"].map((x) => x)),
    //  workExperience: List<dynamic>.from(json["workExperience"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "name": name,
    "profile_url": profileUrl,
    "cover_url":coverUrl,
    "phone": phone,
    "dob": dob,
    "email": email,
    "username": username,
    "password": password,
    "is_Logged_in": isLoggedIn,
    "my_feeds": List<dynamic>.from(myFeeds.map((x) => x)),
    "following_count": followingCount,
    "followers_count": followersCount,
    "posts_count": postsCount,
    "about": about,
    "city": city,
    "college": college,
    "company": company,
    "designation": designation,
    "high_school": highSchool,
    "interest": interest,
    "job": job,
    "member": member,
    "relationship_status": relationshipStatus,
    "notification_token": notificationToken,
    "gender":gender,
    //  "languageKnown":languageKnown,
    "website":website,
    "skills":skills,
    //  "workExperience":workExperience
  };
}