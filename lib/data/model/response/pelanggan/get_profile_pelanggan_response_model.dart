import 'dart:convert';

class GetProfilePelangganResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  GetProfilePelangganResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  GetProfilePelangganResponseModel copyWith({
    String? message,
    int? statusCode,
    Data? data,
  }) =>
      GetProfilePelangganResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory GetProfilePelangganResponseModel.fromRawJson(String str) =>
      GetProfilePelangganResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetProfilePelangganResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfilePelangganResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

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

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idProfile: json["id_profile"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        profilePicture: json["profile_picture"], 
      );

  Map<String, dynamic> toJson() => {
        "id_profile": idProfile,
        "name": name,
        "phone_number": phoneNumber,
        "profile_picture": profilePicture,
      };
}
