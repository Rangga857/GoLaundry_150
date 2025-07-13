import 'dart:convert';

class GetAllServiceLaundryResponseModel {
    final String message;
    final int statusCode;
    final List<DatumService> data;

    GetAllServiceLaundryResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllServiceLaundryResponseModel copyWith({
        String? message,
        int? statusCode,
        List<DatumService>? data,
    }) => 
        GetAllServiceLaundryResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllServiceLaundryResponseModel.fromRawJson(String str) => GetAllServiceLaundryResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllServiceLaundryResponseModel.fromJson(Map<String, dynamic> json) => GetAllServiceLaundryResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<DatumService>.from(json["data"].map((x) => DatumService.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumService {
    final int id;
    final String title;
    final String subTitle;
    final int pricePerKg;
    final DateTime createdAt;
    final DateTime updatedAt;

    DatumService({
        required this.id,
        required this.title,
        required this.subTitle,
        required this.pricePerKg,
        required this.createdAt,
        required this.updatedAt,
    });

    DatumService copyWith({
        int? id,
        String? title,
        String? subTitle,
        int? pricePerKg,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        DatumService(
            id: id ?? this.id,
            title: title ?? this.title,
            subTitle: subTitle ?? this.subTitle,
            pricePerKg: pricePerKg ?? this.pricePerKg,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory DatumService.fromRawJson(String str) => DatumService.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumService.fromJson(Map<String, dynamic> json) => DatumService(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        pricePerKg: json["price_per_kg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "price_per_kg": pricePerKg,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
