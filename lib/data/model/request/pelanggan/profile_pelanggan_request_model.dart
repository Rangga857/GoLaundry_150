import 'dart:convert';

class ProfilePelangganRequestModel {
  final String? name;
  final String? phoneNumber;
  final String? profilePicture;

  ProfilePelangganRequestModel({
    this.name,
    this.phoneNumber,
    this.profilePicture,
  });

  ProfilePelangganRequestModel copyWith({
    String? name,
    String? phoneNumber,
    String? profilePicture,
  }) =>
      ProfilePelangganRequestModel(
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory ProfilePelangganRequestModel.fromRawJson(String str) =>
      ProfilePelangganRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfilePelangganRequestModel.fromJson(Map<String, dynamic> json) =>
      ProfilePelangganRequestModel(
        name: json["name"],
        phoneNumber: json["phone_number"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "profile_picture": profilePicture,
      };
}
