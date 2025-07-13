import 'dart:convert';

class JenisPewangiResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    JenisPewangiResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    JenisPewangiResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        JenisPewangiResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory JenisPewangiResponseModel.fromRawJson(String str) => JenisPewangiResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JenisPewangiResponseModel.fromJson(Map<String, dynamic> json) => JenisPewangiResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toJson(),
    };
}

class Data {
    final int? id;
    final String? nama;
    final String? deskripsi;

    Data({
        this.id,
        this.nama,
        this.deskripsi,
    });

    Data copyWith({
        int? id,
        String? nama,
        String? deskripsi,
    }) => 
        Data(
            id: id ?? this.id,
            nama: nama ?? this.nama,
            deskripsi: deskripsi ?? this.deskripsi,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "deskripsi": deskripsi,
    };
}
