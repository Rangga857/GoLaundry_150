import 'dart:convert';

class GetAllCategoryPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    GetAllCategoryPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllCategoryPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        GetAllCategoryPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllCategoryPengeluaranResponseModel.fromRawJson(String str) => GetAllCategoryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllCategoryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => GetAllCategoryPengeluaranResponseModel(
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
    final int pengeluaranCategoryId;
    final String nama;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.pengeluaranCategoryId,
        required this.nama,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? pengeluaranCategoryId,
        String? nama,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
            nama: nama ?? this.nama,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        pengeluaranCategoryId: json["pengeluaran_category_id"],
        nama: json["nama"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "pengeluaran_category_id": pengeluaranCategoryId,
        "nama": nama,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
