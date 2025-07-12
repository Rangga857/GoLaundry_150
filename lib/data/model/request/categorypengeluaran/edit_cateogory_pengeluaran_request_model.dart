import 'dart:convert';

class EditCateogryPengeluaranResponseModel {
    final String nama;

    EditCateogryPengeluaranResponseModel({
        required this.nama,
    });

    EditCateogryPengeluaranResponseModel copyWith({
        String? nama,
    }) => 
        EditCateogryPengeluaranResponseModel(
            nama: nama ?? this.nama,
        );

    factory EditCateogryPengeluaranResponseModel.fromRawJson(String str) => EditCateogryPengeluaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EditCateogryPengeluaranResponseModel.fromJson(Map<String, dynamic> json) => EditCateogryPengeluaranResponseModel(
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
    };
}
