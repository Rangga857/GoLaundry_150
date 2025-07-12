import 'dart:convert';

class CategoryPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    CategoryPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    CategoryPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        CategoryPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory CategoryPengeluaranResponseModel.fromRawJson(String str) => CategoryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => CategoryPengeluaranResponseModel(
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
    final String nama;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int pengeluaranCategoryId;

    Data({
        required this.nama,
        required this.updatedAt,
        required this.createdAt,
        required this.pengeluaranCategoryId,
    });

    Data copyWith({
        String? nama,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? pengeluaranCategoryId,
    }) => 
        Data(
            nama: nama ?? this.nama,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        nama: json["nama"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        pengeluaranCategoryId: json["pengeluaran_category_id"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "pengeluaran_category_id": pengeluaranCategoryId,
    };
}
