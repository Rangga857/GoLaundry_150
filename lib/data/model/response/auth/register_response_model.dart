import 'dart:convert';

class RegisterResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    RegisterResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory RegisterResponseModel.fromJson(String str) => RegisterResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterResponseModel.fromMap(Map<String, dynamic> json) => RegisterResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final String? email;
    final int? roleId;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? userId;

    Data({
        this.email,
        this.roleId,
        this.updatedAt,
        this.createdAt,
        this.userId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        email: json["email"],
        roleId: json["role_id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        userId: json["user_id"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "role_id": roleId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "user_id": userId,
    };
}
