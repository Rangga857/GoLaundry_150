import 'dart:convert';

class DeleteCateogryPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final dynamic data;

    DeleteCateogryPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    DeleteCateogryPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        dynamic data,
    }) => 
        DeleteCateogryPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory DeleteCateogryPengeluaranResponseModel.fromRawJson(String str) => DeleteCateogryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeleteCateogryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => DeleteCateogryPengeluaranResponseModel(
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
