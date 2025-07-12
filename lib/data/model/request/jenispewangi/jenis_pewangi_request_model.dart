import 'dart:convert';

class JenisPewangiRequestModel {
    final String? nama;
    final String? deskripsi;

    JenisPewangiRequestModel({
        this.nama,
        this.deskripsi,
    });

    JenisPewangiRequestModel copyWith({
        String? nama,
        String? deskripsi,
    }) => 
        JenisPewangiRequestModel(
            nama: nama ?? this.nama,
            deskripsi: deskripsi ?? this.deskripsi,
        );

    factory JenisPewangiRequestModel.fromRawJson(String str) => JenisPewangiRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JenisPewangiRequestModel.fromJson(Map<String, dynamic> json) => JenisPewangiRequestModel(
        nama: json["nama"],
        deskripsi: json["deskripsi"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
        "deskripsi": deskripsi,
    };
}
