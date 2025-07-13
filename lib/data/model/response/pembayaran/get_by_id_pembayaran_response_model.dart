import 'dart:convert';

class GetByIdPembayaranResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    GetByIdPembayaranResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetByIdPembayaranResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        GetByIdPembayaranResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetByIdPembayaranResponseModel.fromRawJson(String str) => GetByIdPembayaranResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetByIdPembayaranResponseModel.fromJson(Map<String, dynamic> json) => GetByIdPembayaranResponseModel(
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
    final int id;
    final int confirmationPaymentId;
    final String metodePembayaran;
    final String buktiPembayaranUrl;
    final String status;
    final int totalFullPriceOrder;
    final String keteranganOrder;
    final String customerName;
    final String adminName;
    final OrderDetails orderDetails;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.confirmationPaymentId,
        required this.metodePembayaran,
        required this.buktiPembayaranUrl,
        required this.status,
        required this.totalFullPriceOrder,
        required this.keteranganOrder,
        required this.customerName,
        required this.adminName,
        required this.orderDetails,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        int? confirmationPaymentId,
        String? metodePembayaran,
        String? buktiPembayaranUrl,
        String? status,
        int? totalFullPriceOrder,
        String? keteranganOrder,
        String? customerName,
        String? adminName,
        OrderDetails? orderDetails,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            confirmationPaymentId: confirmationPaymentId ?? this.confirmationPaymentId,
            metodePembayaran: metodePembayaran ?? this.metodePembayaran,
            buktiPembayaranUrl: buktiPembayaranUrl ?? this.buktiPembayaranUrl,
            status: status ?? this.status,
            totalFullPriceOrder: totalFullPriceOrder ?? this.totalFullPriceOrder,
            keteranganOrder: keteranganOrder ?? this.keteranganOrder,
            customerName: customerName ?? this.customerName,
            adminName: adminName ?? this.adminName,
            orderDetails: orderDetails ?? this.orderDetails,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        confirmationPaymentId: json["confirmation_payment_id"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaranUrl: json["bukti_pembayaran_url"],
        status: json["status"],
        totalFullPriceOrder: json["total_full_price_order"],
        keteranganOrder: json["keterangan_order"],
        customerName: json["customer_name"],
        adminName: json["admin_name"],
        orderDetails: OrderDetails.fromJson(json["order_details"]),
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
        "customer_name": customerName,
        "admin_name": adminName,
        "order_details": orderDetails.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class OrderDetails {
    final int orderId;
    final String pickupAddress;
    final String statusOrder;
    final double totalWeight;
    final int totalOngkir;
    final int totalHargaItemOrder;

    OrderDetails({
        required this.orderId,
        required this.pickupAddress,
        required this.statusOrder,
        required this.totalWeight,
        required this.totalOngkir,
        required this.totalHargaItemOrder,
    });

    OrderDetails copyWith({
        int? orderId,
        String? pickupAddress,
        String? statusOrder,
        double? totalWeight,
        int? totalOngkir,
        int? totalHargaItemOrder,
    }) => 
        OrderDetails(
            orderId: orderId ?? this.orderId,
            pickupAddress: pickupAddress ?? this.pickupAddress,
            statusOrder: statusOrder ?? this.statusOrder,
            totalWeight: totalWeight ?? this.totalWeight,
            totalOngkir: totalOngkir ?? this.totalOngkir,
            totalHargaItemOrder: totalHargaItemOrder ?? this.totalHargaItemOrder,
        );

    factory OrderDetails.fromRawJson(String str) => OrderDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        orderId: json["order_id"],
        pickupAddress: json["pickup_address"],
        statusOrder: json["status_order"],
        totalWeight: json["total_weight"]?.toDouble(),
        totalOngkir: json["total_ongkir"],
        totalHargaItemOrder: json["total_harga_item_order"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "pickup_address": pickupAddress,
        "status_order": statusOrder,
        "total_weight": totalWeight,
        "total_ongkir": totalOngkir,
        "total_harga_item_order": totalHargaItemOrder,
    };
}
