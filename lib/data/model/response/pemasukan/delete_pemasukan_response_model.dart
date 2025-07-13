import 'dart:convert';

class DeletePemasukanResponseModel {
    final String message;
    final int statusCode;
    final dynamic data;

    DeletePemasukanResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    DeletePemasukanResponseModel copyWith({
        String? message,
        int? statusCode,
        dynamic data,
    }) => 
        DeletePemasukanResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory DeletePemasukanResponseModel.fromRawJson(String str) => DeletePemasukanResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeletePemasukanResponseModel.fromJson(Map<String, dynamic> json) => DeletePemasukanResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data,
    };
}
