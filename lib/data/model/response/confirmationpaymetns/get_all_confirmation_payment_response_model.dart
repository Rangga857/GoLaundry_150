import 'dart:convert';

class GetAllConfirmationPaymentResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    GetAllConfirmationPaymentResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetAllConfirmationPaymentResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        GetAllConfirmationPaymentResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllConfirmationPaymentResponseModel.fromRawJson(String str) => GetAllConfirmationPaymentResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllConfirmationPaymentResponseModel.fromJson(Map<String, dynamic> json) => GetAllConfirmationPaymentResponseModel(
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
    final int orderId;
    final String customerName;
    final String laundryName;
    final String pickupAddress;
    final double totalWeight;
    final int totalPrice;
    final int totalOngkir;
    final int totalFullPrice;
    final String keterangan;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.id,
        required this.orderId,
        required this.customerName,
        required this.laundryName,
        required this.pickupAddress,
        required this.totalWeight,
        required this.totalPrice,
        required this.totalOngkir,
        required this.totalFullPrice,
        required this.keterangan,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        int? orderId,
        String? customerName,
        String? laundryName,
        String? pickupAddress,
        double? totalWeight,
        int? totalPrice,
        int? totalOngkir,
        int? totalFullPrice,
        String? keterangan,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            orderId: orderId ?? this.orderId,
            customerName: customerName ?? this.customerName,
            laundryName: laundryName ?? this.laundryName,
            pickupAddress: pickupAddress ?? this.pickupAddress,
            totalWeight: totalWeight ?? this.totalWeight,
            totalPrice: totalPrice ?? this.totalPrice,
            totalOngkir: totalOngkir ?? this.totalOngkir,
            totalFullPrice: totalFullPrice ?? this.totalFullPrice,
            keterangan: keterangan ?? this.keterangan,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        customerName: json["customer_name"],
        laundryName: json["laundry_name"],
        pickupAddress: json["pickup_address"],
        totalWeight: json["total_weight"]?.toDouble(),
        totalPrice: json["total_price"],
        totalOngkir: json["total_ongkir"],
        totalFullPrice: json["total_full_price"],
        keterangan: json["keterangan"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "customer_name": customerName,
        "laundry_name": laundryName,
        "pickup_address": pickupAddress,
        "total_weight": totalWeight,
        "total_price": totalPrice,
        "total_ongkir": totalOngkir,
        "total_full_price": totalFullPrice,
        "keterangan": keterangan,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
