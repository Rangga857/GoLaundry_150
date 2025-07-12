import 'dart:convert';
import 'dart:io';

class ProfilePelangganRequestModel {
  final String? name;
  final String? phoneNumber;
  final File? profilePicture; 

  ProfilePelangganRequestModel({
    this.name,
    this.phoneNumber,
    this.profilePicture,
  });

  ProfilePelangganRequestModel copyWith({
    String? name,
    String? phoneNumber,
    File? profilePicture,
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
        profilePicture: null, 
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
      };
}
