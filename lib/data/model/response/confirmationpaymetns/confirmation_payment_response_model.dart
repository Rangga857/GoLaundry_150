import 'dart:convert';

class ConfirmationPaymentResponseModel {
    final String success;
    final ConfirmationPayment confirmationPayment;

    ConfirmationPaymentResponseModel({
        required this.success,
        required this.confirmationPayment,
    });

    ConfirmationPaymentResponseModel copyWith({
        String? success,
        ConfirmationPayment? confirmationPayment,
    }) => 
        ConfirmationPaymentResponseModel(
            success: success ?? this.success,
            confirmationPayment: confirmationPayment ?? this.confirmationPayment,
        );

    factory ConfirmationPaymentResponseModel.fromRawJson(String str) => ConfirmationPaymentResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConfirmationPaymentResponseModel.fromJson(Map<String, dynamic> json) => ConfirmationPaymentResponseModel(
        success: json["success"],
        confirmationPayment: ConfirmationPayment.fromJson(json["confirmation_payment"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "confirmation_payment": confirmationPayment.toJson(),
    };
}

class ConfirmationPayment {
    final int adminId;
    final int idProfile;
    final int orderId;
    final int totalWeight;
    final int totalOngkir;
    final int totalPrice;
    final int totalFullPrice;
    final String keterangan;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    ConfirmationPayment({
        required this.adminId,
        required this.idProfile,
        required this.orderId,
        required this.totalWeight,
        required this.totalOngkir,
        required this.totalPrice,
        required this.totalFullPrice,
        required this.keterangan,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    ConfirmationPayment copyWith({
        int? adminId,
        int? idProfile,
        int? orderId,
        int? totalWeight,
        int? totalOngkir,
        int? totalPrice,
        int? totalFullPrice,
        String? keterangan,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        ConfirmationPayment(
            adminId: adminId ?? this.adminId,
            idProfile: idProfile ?? this.idProfile,
            orderId: orderId ?? this.orderId,
            totalWeight: totalWeight ?? this.totalWeight,
            totalOngkir: totalOngkir ?? this.totalOngkir,
            totalPrice: totalPrice ?? this.totalPrice,
            totalFullPrice: totalFullPrice ?? this.totalFullPrice,
            keterangan: keterangan ?? this.keterangan,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory ConfirmationPayment.fromRawJson(String str) => ConfirmationPayment.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConfirmationPayment.fromJson(Map<String, dynamic> json) => ConfirmationPayment(
        adminId: json["admin_id"],
        idProfile: json["id_profile"],
        orderId: json["order_id"],
        totalWeight: json["total_weight"],
        totalOngkir: json["total_ongkir"],
        totalPrice: json["total_price"],
        totalFullPrice: json["total_full_price"],
        keterangan: json["keterangan"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "id_profile": idProfile,
        "order_id": orderId,
        "total_weight": totalWeight,
        "total_ongkir": totalOngkir,
        "total_price": totalPrice,
        "total_full_price": totalFullPrice,
        "keterangan": keterangan,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
