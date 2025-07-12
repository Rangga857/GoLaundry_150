import 'dart:convert';

class ProfileAdminRequestModel {
    final String? name;
    final String? address;
    final double? latitude;
    final double? longitude;
    ProfileAdminRequestModel({
        this.name,
        this.address,
        this.latitude,
        this.longitude,
    });

    ProfileAdminRequestModel copyWith({
        String? name,
        String? address,
        double? latitude,
        double? longitude,
        String? profilePicture,
    }) => 
        ProfileAdminRequestModel(
            name: name ?? this.name,
            address: address ?? this.address,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
        );

    factory ProfileAdminRequestModel.fromRawJson(String str) => ProfileAdminRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProfileAdminRequestModel.fromJson(Map<String, dynamic> json) => ProfileAdminRequestModel(
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
    };
}
