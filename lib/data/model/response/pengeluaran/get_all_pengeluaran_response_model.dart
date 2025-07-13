import 'dart:convert';

class GetAllPengeluaranResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    GetAllPengeluaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllPengeluaranResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        GetAllPengeluaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllPengeluaranResponseModel.fromRawJson(String str) => GetAllPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => GetAllPengeluaranResponseModel(
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
    final int pengeluaranCategoryId;
    final String nama;
    final int jumlahPengeluaran;
    final String deskripsiPengeluaran;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.id,
        required this.pengeluaranCategoryId,
        required this.nama,
        required this.jumlahPengeluaran,
        required this.deskripsiPengeluaran,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        int? pengeluaranCategoryId,
        String? nama,
        int? jumlahPengeluaran,
        String? deskripsiPengeluaran,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            pengeluaranCategoryId: pengeluaranCategoryId ?? this.pengeluaranCategoryId,
            nama: nama ?? this.nama,
            jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
            deskripsiPengeluaran: deskripsiPengeluaran ?? this.deskripsiPengeluaran,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
