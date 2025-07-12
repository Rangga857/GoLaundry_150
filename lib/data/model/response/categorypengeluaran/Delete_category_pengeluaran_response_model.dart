import 'dart:convert';

class DeleteCategoryPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final dynamic data;

    DeleteCategoryPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    DeleteCategoryPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        dynamic data,
    }) => 
        DeleteCategoryPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory DeleteCategoryPengeluaranResponseModel.fromRawJson(String str) => DeleteCategoryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeleteCategoryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => DeleteCategoryPengeluaranResponseModel(
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
