import 'dart:convert';

class EditCategoryPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    EditCategoryPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    EditCategoryPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        EditCategoryPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory EditCategoryPengeluaranResponseModel.fromRawJson(String str) => EditCategoryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EditCategoryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => EditCategoryPengeluaranResponseModel(
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
    final int pengeluaranCategoryId;
    final String nama;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.pengeluaranCategoryId,
        required this.nama,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? pengeluaranCategoryId,
        String? nama,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
            nama: nama ?? this.nama,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
