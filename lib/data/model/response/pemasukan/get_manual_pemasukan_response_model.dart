import 'dart:convert';

class GetManualPemasukanResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    GetManualPemasukanResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetManualPemasukanResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        GetManualPemasukanResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetManualPemasukanResponseModel.fromRawJson(String str) => GetManualPemasukanResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetManualPemasukanResponseModel.fromJson(Map<String, dynamic> json) => GetManualPemasukanResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final int id;
    final int amount;
    final String description;
    final DateTime transactionDate;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.id,
        required this.amount,
        required this.description,
        required this.transactionDate,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        int? amount,
        String? description,
        DateTime? transactionDate,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            amount: amount ?? this.amount,
            description: description ?? this.description,
            transactionDate: transactionDate ?? this.transactionDate,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
