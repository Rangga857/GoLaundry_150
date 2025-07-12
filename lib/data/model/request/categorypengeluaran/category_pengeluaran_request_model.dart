import 'dart:convert';

class CateogryPengeluaranRequestModel {
    final String nama;

    CateogryPengeluaranRequestModel({
        required this.nama,
    });

    CateogryPengeluaranRequestModel copyWith({
        String? nama,
    }) => 
        CateogryPengeluaranRequestModel(
            nama: nama ?? this.nama,
        );

    factory CateogryPengeluaranRequestModel.fromRawJson(String str) => CateogryPengeluaranRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CateogryPengeluaranRequestModel.fromJson(Map<String, dynamic> json) => CateogryPengeluaranRequestModel(
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
    };
}
