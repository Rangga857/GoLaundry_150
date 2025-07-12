import 'dart:convert';

class ConfirmationPaymentRequestModel {
    final int orderId;
    final int totalWeight;
    final int totalPrice;
    final String keterangan;

    ConfirmationPaymentRequestModel({
        required this.orderId,
        required this.totalWeight,
        required this.totalPrice,
        required this.keterangan,
    });

    ConfirmationPaymentRequestModel copyWith({
        int? orderId,
        int? totalWeight,
        int? totalPrice,
        String? keterangan,
    }) => 
        ConfirmationPaymentRequestModel(
            orderId: orderId ?? this.orderId,
            totalWeight: totalWeight ?? this.totalWeight,
            totalPrice: totalPrice ?? this.totalPrice,
            keterangan: keterangan ?? this.keterangan,
        );

    factory ConfirmationPaymentRequestModel.fromRawJson(String str) => ConfirmationPaymentRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConfirmationPaymentRequestModel.fromJson(Map<String, dynamic> json) => ConfirmationPaymentRequestModel(
        orderId: json["order_id"],
        totalWeight: json["total_weight"],
        totalPrice: json["total_price"],
        keterangan: json["keterangan"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_weight": totalWeight,
        "total_price": totalPrice,
        "keterangan": keterangan,
    };
}
