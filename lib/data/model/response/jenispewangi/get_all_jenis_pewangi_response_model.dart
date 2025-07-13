import 'dart:convert';

class GetAllJenisPewangiResponseModel {
    final String message;
    final int statusCode;
    final List<DatumPewangi> data;

    GetAllJenisPewangiResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllJenisPewangiResponseModel copyWith({
        String? message,
        int? statusCode,
        List<DatumPewangi>? data,
    }) => 
        GetAllJenisPewangiResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllJenisPewangiResponseModel.fromRawJson(String str) => GetAllJenisPewangiResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllJenisPewangiResponseModel.fromJson(Map<String, dynamic> json) => GetAllJenisPewangiResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<DatumPewangi>.from(json["data"].map((x) => DatumPewangi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumPewangi {
    final int id;
    final String nama;
    final String deskripsi;
    final DateTime createdAt;
    final DateTime updatedAt;

    DatumPewangi({
        required this.id,
        required this.nama,
        required this.deskripsi,
        required this.createdAt,
        required this.updatedAt,
    });

    DatumPewangi copyWith({
        int? id,
        String? nama,
        String? deskripsi,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        DatumPewangi(
            id: id ?? this.id,
            nama: nama ?? this.nama,
            deskripsi: deskripsi ?? this.deskripsi,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory DatumPewangi.fromRawJson(String str) => DatumPewangi.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumPewangi.fromJson(Map<String, dynamic> json) => DatumPewangi(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "deskripsi": deskripsi,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
