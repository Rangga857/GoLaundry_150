import 'dart:convert';

class GetMyPembayaranResponseModel {
    final String message;
    final int statusCode;
    final List<DatumMyPembayaran>? data;

    GetMyPembayaranResponseModel({
        required this.message,
        required this.statusCode,
        this.data,
    });

    GetMyPembayaranResponseModel copyWith({
        String? message,
        int? statusCode,
        List<DatumMyPembayaran>? data,
    }) => 
        GetMyPembayaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetMyPembayaranResponseModel.fromRawJson(String str) => GetMyPembayaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetMyPembayaranResponseModel.fromJson(Map<String, dynamic> json) => GetMyPembayaranResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
       data: json["data"] == null
            ? []
            : List<DatumMyPembayaran>.from(json["data"].map((x) => DatumMyPembayaran.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson()))
    };
}

class DatumMyPembayaran {
    final int id;
    final int confirmationPaymentId;
    final String metodePembayaran;
    final String buktiPembayaranUrl;
    final String status;
    final int totalFullPriceOrder;
    final String keteranganOrder;
    final DateTime createdAt;
    final DateTime updatedAt;

    DatumMyPembayaran({
        required this.id,
        required this.confirmationPaymentId,
        required this.metodePembayaran,
        required this.buktiPembayaranUrl,
        required this.status,
        required this.totalFullPriceOrder,
        required this.keteranganOrder,
        required this.createdAt,
        required this.updatedAt,
    });

    DatumMyPembayaran copyWith({
        int? id,
        int? confirmationPaymentId,
        String? metodePembayaran,
        String? buktiPembayaranUrl,
        String? status,
        int? totalFullPriceOrder,
        String? keteranganOrder,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        DatumMyPembayaran(
            id: id ?? this.id,
            confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
            metodePembayaran: metodePembayaran ?? this.metodePembayaran,
            buktiPembayaranUrl: buktiPembayaranUrl ?? this.buktiPembayaranUrl,
            status: status ?? this.status,
            totalFullPriceOrder: totalFullPriceOrder ?? this.totalFullPriceOrder,
            keteranganOrder: keteranganOrder ?? this.keteranganOrder,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory DatumMyPembayaran.fromRawJson(String str) => DatumMyPembayaran.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumMyPembayaran.fromJson(Map<String, dynamic> json) => DatumMyPembayaran(
        id: json["id"],
        confirmationPaymentId: json["confirmation_payment_id"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaranUrl: json["bukti_pembayaran_url"],
        status: json["status"],
        totalFullPriceOrder: json["total_full_price_order"],
        keteranganOrder: json["keterangan_order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "confirmation_payment_id": confirmationPaymentId,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran_url": buktiPembayaranUrl,
        "status": status,
        "total_full_price_order": totalFullPriceOrder,
        "keterangan_order": keteranganOrder,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
