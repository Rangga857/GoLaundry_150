import 'dart:convert';

class PaymentResponseModel {
  final String message;
  final int statusCode;
  final PaymentResponseData data; // Using the renamed Data class

  PaymentResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  PaymentResponseModel copyWith({
    String? message,
    int? statusCode,
    PaymentResponseData? data,
  }) =>
      PaymentResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory PaymentResponseModel.fromRawJson(String str) => PaymentResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) => PaymentResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: PaymentResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

// Renamed from 'Data' to 'PaymentResponseData' to resolve naming conflict
class PaymentResponseData {
  final int id;
  final int confirmationPaymentId;
  final String metodePembayaran;
  final String buktiPembayaranUrl;
  final String status;
  final DateTime createdAt;

  PaymentResponseData({
    required this.id,
    required this.confirmationPaymentId,
    required this.metodePembayaran,
    required this.buktiPembayaranUrl,
    required this.status,
    required this.createdAt,
  });

  PaymentResponseData copyWith({
    int? id,
    int? confirmationPaymentId,
    String? metodePembayaran,
    String? buktiPembayaranUrl,
    String? status,
    DateTime? createdAt,
  }) =>
      PaymentResponseData(
        id: id ?? this.id,
        confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
        metodePembayaran: metodePembayaran ?? this.metodePembayaran,
        buktiPembayaranUrl: buktiPembayaranUrl ?? this.buktiPembayaranUrl,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory PaymentResponseData.fromRawJson(String str) => PaymentResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) => PaymentResponseData(
        id: json["id"],
        confirmationPaymentId: json["confirmation_payment_id"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaranUrl: json["bukti_pembayaran_url"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "confirmation_payment_id": confirmationPaymentId,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran_url": buktiPembayaranUrl,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}