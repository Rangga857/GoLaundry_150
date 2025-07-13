import 'dart:convert';

class DeleteJenisPewangiResponseModel {
    final String message;
    final int statusCode;
    final dynamic data;

    DeleteJenisPewangiResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    DeleteJenisPewangiResponseModel copyWith({
        String? message,
        int? statusCode,
        dynamic data,
    }) => 
        DeleteJenisPewangiResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory DeleteJenisPewangiResponseModel.fromRawJson(String str) => DeleteJenisPewangiResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeleteJenisPewangiResponseModel.fromJson(Map<String, dynamic> json) => DeleteJenisPewangiResponseModel(
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
