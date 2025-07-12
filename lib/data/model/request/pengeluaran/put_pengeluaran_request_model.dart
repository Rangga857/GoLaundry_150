import 'dart:convert';

class PutPengeluaranRequestModel {
    final String namaKategori;
    final int jumlahPengeluaran;
    final String deskripsiPengeluaran;

    PutPengeluaranRequestModel({
        required this.namaKategori,
        required this.jumlahPengeluaran,
        required this.deskripsiPengeluaran,
    });

    PutPengeluaranRequestModel copyWith({
        String? namaKategori,
        int? jumlahPengeluaran,
        String? deskripsiPengeluaran,
    }) => 
        PutPengeluaranRequestModel(
            namaKategori: namaKategori ?? this.namaKategori,
            jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
            deskripsiPengeluaran: deskripsiPengeluaran ?? this.deskripsiPengeluaran,
        );

    factory PutPengeluaranRequestModel.fromRawJson(String str) => PutPengeluaranRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PutPengeluaranRequestModel.fromJson(Map<String, dynamic> json) => PutPengeluaranRequestModel(
        namaKategori: json["nama_kategori"],
        jumlahPengeluaran: json["jumlah_pengeluaran"],
        deskripsiPengeluaran: json["deskripsi_pengeluaran"],
    );

    Map<String, dynamic> toJson() => {
        "nama_kategori": namaKategori,
        "jumlah_pengeluaran": jumlahPengeluaran,
        "deskripsi_pengeluaran": deskripsiPengeluaran,
    };
}
