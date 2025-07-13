import 'dart:convert';

class PutPemasukanResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    PutPemasukanResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    PutPemasukanResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        PutPemasukanResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory PutPemasukanResponseModel.fromRawJson(String str) => PutPemasukanResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PutPemasukanResponseModel.fromJson(Map<String, dynamic> json) => PutPemasukanResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
    };
}

class Data {
    final int id;
    final int amount;
    final String description;
    final DateTime transactionDate;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.amount,
        required this.description,
        required this.transactionDate,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        int? amount,
        String? description,
        DateTime? transactionDate,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            amount: amount ?? this.amount,
            description: description ?? this.description,
            transactionDate: transactionDate ?? this.transactionDate,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        amount: json["amount"],
        description: json["description"],
        transactionDate: DateTime.parse(json["transaction_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "description": description,
        "transaction_date": transactionDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
