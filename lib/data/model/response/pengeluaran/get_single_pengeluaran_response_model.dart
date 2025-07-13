import 'dart:convert';

class GetSinglePengeluaranResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    GetSinglePengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetSinglePengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        GetSinglePengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetSinglePengeluaranResponseModel.fromRawJson(String str) => GetSinglePengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetSinglePengeluaranResponseModel.fromJson(Map<String, dynamic> json) => GetSinglePengeluaranResponseModel(
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
    final int pengeluaranCategoryId;
    final String nama;
    final int jumlahPengeluaran;
    final String deskripsiPengeluaran;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.pengeluaranCategoryId,
        required this.nama,
        required this.jumlahPengeluaran,
        required this.deskripsiPengeluaran,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        int? pengeluaranCategoryId,
        String? nama,
        int? jumlahPengeluaran,
        String? deskripsiPengeluaran,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
            nama: nama ?? this.nama,
            jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
            deskripsiPengeluaran: deskripsiPengeluaran ?? this.deskripsiPengeluaran,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        pengeluaranCategoryId: json["pengeluaran_category_id"],
        nama: json["nama"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pengeluaran_category_id": pengeluaranCategoryId,
        "nama": nama,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
