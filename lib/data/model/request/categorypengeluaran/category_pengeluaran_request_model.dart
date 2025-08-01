import 'dart:convert';

class CategoryPengeluaranRequestModel {
    final String nama;

    CategoryPengeluaranRequestModel({
        required this.nama,
    });

    CategoryPengeluaranRequestModel copyWith({
        String? nama,
    }) => 
        CategoryPengeluaranRequestModel(
            nama: nama ?? this.nama,
        );

    factory CategoryPengeluaranRequestModel.fromRawJson(String str) => CategoryPengeluaranRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryPengeluaranRequestModel.fromJson(Map<String, dynamic> json) => CategoryPengeluaranRequestModel(
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
    };
}
