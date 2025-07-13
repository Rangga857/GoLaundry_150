import 'dart:convert';

class GetAllPembayaranResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    GetAllPembayaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllPembayaranResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        GetAllPembayaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllPembayaranResponseModel.fromRawJson(String str) => GetAllPembayaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllPembayaranResponseModel.fromJson(Map<String, dynamic> json) => GetAllPembayaranResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final int id;
    final int confirmationPaymentId;
    final String customerName;
    final String metodePembayaran;
    final String buktiPembayaranUrl;
    final String status;
    final int totalFullPriceOrder;
    final String keteranganOrder;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.id,
        required this.confirmationPaymentId,
        required this.customerName,
        required this.metodePembayaran,
        required this.buktiPembayaranUrl,
        required this.status,
        required this.totalFullPriceOrder,
        required this.keteranganOrder,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        int? confirmationPaymentId,
        String? customerName,
        String? metodePembayaran,
        String? buktiPembayaranUrl,
        String? status,
        int? totalFullPriceOrder,
        String? keteranganOrder,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
            customerName: customerName ?? this.customerName,
            metodePembayaran: metodePembayaran ?? this.metodePembayaran,
            buktiPembayaranUrl: buktiPembayaranUrl ?? this.buktiPembayaranUrl,
            status: status ?? this.status,
            totalFullPriceOrder: totalFullPriceOrder ?? this.totalFullPriceOrder,
            keteranganOrder: keteranganOrder ?? this.keteranganOrder,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        confirmationPaymentId: json["confirmation_payment_id"],
        customerName: json["customer_name"],
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
        "customer_name": customerName,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran_url": buktiPembayaranUrl,
        "status": status,
        "total_full_price_order": totalFullPriceOrder,
        "keterangan_order": keteranganOrder,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
