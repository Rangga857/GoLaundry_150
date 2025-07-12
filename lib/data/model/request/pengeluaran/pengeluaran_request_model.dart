import 'dart:convert';

class PengeluaranRequestModel {
    final String namaKategori;
    final int jumlahPengeluaran;
    final String deskripsiPengeluaran;

    PengeluaranRequestModel({
        required this.namaKategori,
        required this.jumlahPengeluaran,
        required this.deskripsiPengeluaran,
    });

    PengeluaranRequestModel copyWith({
        String? namaKategori,
        int? jumlahPengeluaran,
        String? deskripsiPengeluaran,
    }) => 
        PengeluaranRequestModel(
            namaKategori: namaKategori ?? this.namaKategori,
            jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
            deskripsiPengeluaran: deskripsiPengeluaran ?? this.deskripsiPengeluaran,
        );

    factory PengeluaranRequestModel.fromRawJson(String str) => PengeluaranRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PengeluaranRequestModel.fromJson(Map<String, dynamic> json) => PengeluaranRequestModel(
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
