import 'dart:convert';
import 'dart:io';

class PaymentRequestModel {
  final int confirmationPaymentId;
  final String metodePembayaran;
  final File? buktiPembayaran; 

  PaymentRequestModel({
    required this.confirmationPaymentId,
    required this.metodePembayaran,
    this.buktiPembayaran, 
  });

  PaymentRequestModel copyWith({
    int? confirmationPaymentId,
    String? metodePembayaran,
    File? buktiPembayaran,
  }) =>
      PaymentRequestModel(
        confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
        metodePembayaran: metodePembayaran ?? this.metodePembayaran,
        buktiPembayaran: buktiPembayaran ?? this.buktiPembayaran,
      );

  factory PaymentRequestModel.fromRawJson(String str) => PaymentRequestModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());
  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) => PaymentRequestModel(
        confirmationPaymentId: json["confirmation_payment_id"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: null, 
      );

  Map<String, String> toFields() => {
        "confirmation_payment_id": confirmationPaymentId.toString(),
        "metode_pembayaran": metodePembayaran,
      };

  Map<String, dynamic> toJson() => {
        "confirmation_payment_id": confirmationPaymentId,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran?.path ?? '', 
      };
}
