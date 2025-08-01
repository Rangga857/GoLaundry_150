import 'dart:convert';

class EditCategoryPengeluaranResponseModel {
    final String nama;

    EditCategoryPengeluaranResponseModel({
        required this.nama,
    });

    EditCategoryPengeluaranResponseModel copyWith({
        String? nama,
    }) => 
        EditCategoryPengeluaranResponseModel(
            nama: nama ?? this.nama,
        );

    factory EditCategoryPengeluaranResponseModel.fromRawJson(String str) => EditCategoryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EditCategoryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => EditCategoryPengeluaranResponseModel(
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
    };
}
