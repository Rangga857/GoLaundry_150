import 'dart:convert';

class ProfilePelangganResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  ProfilePelangganResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  ProfilePelangganResponseModel copyWith({
    String? message,
    int? statusCode,
    Data? data,
  }) =>
      ProfilePelangganResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory ProfilePelangganResponseModel.fromRawJson(String str) =>
      ProfilePelangganResponseModel.fromJson(json.decode(str));

  factory ProfilePelangganResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfilePelangganResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]), 
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toJson(),
      };
}

class Data {
  final int? idProfile;
  final String? name;
  final String? phoneNumber;
  final String? profilePicture;

  Data({
    this.idProfile,
    this.name,
    this.phoneNumber,
    this.profilePicture,
  });

  Data copyWith({
    int? idProfile,
    String? name,
    String? phoneNumber,
    String? profilePicture,
  }) =>
      Data(
        idProfile: idProfile ?? this.idProfile,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idProfile: json["id_profile"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        profilePicture: json["profile_picture"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_profile": idProfile,
        "name": name,
        "phone_number": phoneNumber,
        "profile_picture": profilePicture,
      };
}