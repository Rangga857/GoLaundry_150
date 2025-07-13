import 'dart:convert';

class GetByIdJenisPewangiResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    GetByIdJenisPewangiResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetByIdJenisPewangiResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        GetByIdJenisPewangiResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetByIdJenisPewangiResponseModel.fromRawJson(String str) => GetByIdJenisPewangiResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetByIdJenisPewangiResponseModel.fromJson(Map<String, dynamic> json) => GetByIdJenisPewangiResponseModel(
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
    final String nama;
    final String deskripsi;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.nama,
        required this.deskripsi,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? nama,
        String? deskripsi,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            nama: nama ?? this.nama,
            deskripsi: deskripsi ?? this.deskripsi,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
