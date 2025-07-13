import 'dart:convert';

class OrderLaundriesResponseModel {
  final String success;
  final OrderDetail order; // Renamed to OrderDetail to avoid naming conflict

  OrderLaundriesResponseModel({
    required this.success,
    required this.order,
  });

  OrderLaundriesResponseModel copyWith({
    String? success,
    OrderDetail? order,
  }) =>
      OrderLaundriesResponseModel(
        success: success ?? this.success,
        order: order ?? this.order,
      );

  factory OrderLaundriesResponseModel.fromRawJson(String str) =>
      OrderLaundriesResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderLaundriesResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderLaundriesResponseModel(
        order: OrderDetail.fromJson(json["order"]), success: '', // Use OrderDetail
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order.toJson(),
      };
}

// Kelas OrderDetail yang digunakan di OrderLaundriesResponseModel
class OrderDetail { // Renamed to OrderDetail
  final int idProfile;
  final int jenisPewangiId;
  final int serviceId;
  final String pickupAddress;
  final double pickupLatitude; // Changed to double
  final double pickupLongitude; // Changed to double
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  OrderDetail({
    required this.idProfile,
    required this.jenisPewangiId,
    required this.serviceId,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  OrderDetail copyWith({
    int? idProfile,
    int? jenisPewangiId,
    int? serviceId,
    String? pickupAddress,
    double? pickupLatitude, // Changed to double
    double? pickupLongitude, // Changed to double
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
  }) =>
      OrderDetail(
        idProfile: idProfile ?? this.idProfile,
        jenisPewangiId: jenisPewangiId ?? this.jenisPewangiId,
        serviceId: serviceId ?? this.serviceId,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
      );

  factory OrderDetail.fromRawJson(String str) => OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        idProfile: json["id_profile"],
        jenisPewangiId: json["jenis_pewangi_id"],
        serviceId: json["service_id"],
        pickupAddress: json["pickup_address"],
        pickupLatitude: (json["pickup_latitude"] as num).toDouble(), // Parse as double
        pickupLongitude: (json["pickup_longitude"] as num).toDouble(), // Parse as double
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id_profile": idProfile,
        "jenis_pewangi_id": jenisPewangiId,
        "service_id": serviceId,
        "pickup_address": pickupAddress,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "status": status,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}