import 'dart:convert';

class GetTotalPemasukanResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    GetTotalPemasukanResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetTotalPemasukanResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        GetTotalPemasukanResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetTotalPemasukanResponseModel.fromRawJson(String str) => GetTotalPemasukanResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetTotalPemasukanResponseModel.fromJson(Map<String, dynamic> json) => GetTotalPemasukanResponseModel(
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
    final int totalPemasukanOfflineTercatat;
    final int totalPemasukanOnlineTerkonfirmasi;
    final int grandTotalPemasukan;

    Data({
        required this.totalPemasukanOfflineTercatat,
        required this.totalPemasukanOnlineTerkonfirmasi,
        required this.grandTotalPemasukan,
    });

    Data copyWith({
        int? totalPemasukanOfflineTercatat,
        int? totalPemasukanOnlineTerkonfirmasi,
        int? grandTotalPemasukan,
    }) => 
        Data(
            totalPemasukanOfflineTercatat: totalPemasukanOfflineTercatat ?? this.totalPemasukanOfflineTercatat,
            totalPemasukanOnlineTerkonfirmasi: totalPemasukanOnlineTerkonfirmasi ?? this.totalPemasukanOnlineTerkonfirmasi,
            grandTotalPemasukan: grandTotalPemasukan ?? this.grandTotalPemasukan,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPemasukanOfflineTercatat: json["total_pemasukan_offline_tercatat"],
        totalPemasukanOnlineTerkonfirmasi: json["total_pemasukan_online_terkonfirmasi"],
        grandTotalPemasukan: json["grand_total_pemasukan"],
    );

    Map<String, dynamic> toJson() => {
        "total_pemasukan_offline_tercatat": totalPemasukanOfflineTercatat,
        "total_pemasukan_online_terkonfirmasi": totalPemasukanOnlineTerkonfirmasi,
        "grand_total_pemasukan": grandTotalPemasukan,
    };
}
