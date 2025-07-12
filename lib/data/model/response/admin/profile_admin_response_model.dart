import 'dart:convert';

class ProfileAdminResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    ProfileAdminResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    ProfileAdminResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        ProfileAdminResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory ProfileAdminResponseModel.fromRawJson(String str) => ProfileAdminResponseModel.fromJson(json.decode(str));
    String toRawJson() => json.encode(toJson());
    factory ProfileAdminResponseModel.fromJson(Map<String, dynamic> json) => ProfileAdminResponseModel(
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
    final int? laundryId;
    final String? name;
    final String? address;
    final double? latitude;
    final double? longitude;

    Data({
        this.laundryId,
        this.name,
        this.address,
        this.latitude,
        this.longitude,
    });

    Data copyWith({
        int? laundryId,
        String? name,
        String? address,
        String? profilePicture,
        double? latitude,
        double? longitude,
    }) => 
        Data(
            laundryId: laundryId ?? this.laundryId,
            name: name ?? this.name,
            address: address ?? this.address,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        laundryId: json["laundry_id"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "laundry_id": laundryId,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
    };
}
