import 'dart:convert';

class PengeluaranResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    PengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    PengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        PengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory PengeluaranResponseModel.fromRawJson(String str) => PengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PengeluaranResponseModel.fromJson(Map<String, dynamic> json) => PengeluaranResponseModel(
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
    final int jumlahPengeluaran;
    final String deskripsiPengeluaran;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    Data({
        required this.pengeluaranCategoryId,
        required this.jumlahPengeluaran,
        required this.deskripsiPengeluaran,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    Data copyWith({
        int? pengeluaranCategoryId,
        int? jumlahPengeluaran,
        String? deskripsiPengeluaran,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
            jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
            deskripsiPengeluaran: deskripsiPengeluaran ?? this.deskripsiPengeluaran,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pengeluaranCategoryId: json["pengeluaran_category_id"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "pengeluaran_category_id": pengeluaranCategoryId,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
