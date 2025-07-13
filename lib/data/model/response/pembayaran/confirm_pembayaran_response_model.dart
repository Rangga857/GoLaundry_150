import 'dart:convert';

class ConfirmPembayaranResponseModel {
  final String message;
  final int statusCode;
  final ConfirmPaymentData data; // Using the renamed Data class

  ConfirmPembayaranResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  ConfirmPembayaranResponseModel copyWith({
    String? message,
    int? statusCode,
    ConfirmPaymentData? data,
  }) =>
      ConfirmPembayaranResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory ConfirmPembayaranResponseModel.fromRawJson(String str) =>
      ConfirmPembayaranResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfirmPembayaranResponseModel.fromJson(Map<String, dynamic> json) =>
      ConfirmPembayaranResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: ConfirmPaymentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

class ConfirmPaymentData {
  final int id;
  final String status;
  final int confirmationPaymentId;

  ConfirmPaymentData({
    required this.id,
    required this.status,
    required this.confirmationPaymentId,
  });

  ConfirmPaymentData copyWith({
    int? id,
    String? status,
    int? confirmationPaymentId,
  }) =>
      ConfirmPaymentData(
        id: id ?? this.id,
        status: status ?? this.status,
        confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
      );

  factory ConfirmPaymentData.fromRawJson(String str) => ConfirmPaymentData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfirmPaymentData.fromJson(Map<String, dynamic> json) => ConfirmPaymentData(
        id: json["id"],
        status: json["status"],
        confirmationPaymentId: json["confirmation_payment_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "confirmation_payment_id": confirmationPaymentId,
      };
}