import 'dart:convert';

class GetByIdServiceLaundryResponseModel {
  final String message;
  final int? statusCode; 
  final DataService data; 

  GetByIdServiceLaundryResponseModel({
    required this.message,
    this.statusCode,
    required this.data,
  });

  GetByIdServiceLaundryResponseModel copyWith({
    String? message,
    int? statusCode,
    DataService? data,
  }) =>
      GetByIdServiceLaundryResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory GetByIdServiceLaundryResponseModel.fromRawJson(String str) =>
      GetByIdServiceLaundryResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetByIdServiceLaundryResponseModel.fromJson(Map<String, dynamic> json) =>
      GetByIdServiceLaundryResponseModel(
        message: json["message"],
        statusCode: json["status_code"], 
        data: DataService.fromJson(json["data"]), 
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

class DataService { 
  final int id;
  final String title;
  final String subTitle;
  final int pricePerKg; 
  final DateTime createdAt;
  final DateTime updatedAt;

  DataService({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.pricePerKg, 
    required this.createdAt,
    required this.updatedAt,
  });

  DataService copyWith({
    int? id,
    String? title,
    String? subTitle,
    int? pricePerKg, 
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DataService(
        id: id ?? this.id,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        pricePerKg: pricePerKg ?? this.pricePerKg,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory DataService.fromRawJson(String str) => DataService.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataService.fromJson(Map<String, dynamic> json) => DataService(
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
