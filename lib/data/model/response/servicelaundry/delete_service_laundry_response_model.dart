import 'dart:convert';

class DeleteServiceLaundryResponseModel {
    final String message;
    final int statusCode;
    final dynamic data;

    DeleteServiceLaundryResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    DeleteServiceLaundryResponseModel copyWith({
        String? message,
        int? statusCode,
        dynamic data,
    }) => 
        DeleteServiceLaundryResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory DeleteServiceLaundryResponseModel.fromRawJson(String str) => DeleteServiceLaundryResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeleteServiceLaundryResponseModel.fromJson(Map<String, dynamic> json) => DeleteServiceLaundryResponseModel(
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
