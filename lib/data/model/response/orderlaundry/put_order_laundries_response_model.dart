import 'dart:convert';

class PutOrdesLaundriesResponseModel {
  final String success;
  final PutOrder order; // Renamed to PutOrder to avoid naming conflict

  PutOrdesLaundriesResponseModel({
    required this.success,
    required this.order,
  });

  PutOrdesLaundriesResponseModel copyWith({
    String? success,
    PutOrder? order,
  }) =>
      PutOrdesLaundriesResponseModel(
        success: success ?? this.success,
        order: order ?? this.order,
      );

  factory PutOrdesLaundriesResponseModel.fromRawJson(String str) =>
      PutOrdesLaundriesResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PutOrdesLaundriesResponseModel.fromJson(Map<String, dynamic> json) =>
      PutOrdesLaundriesResponseModel(
        order: PutOrder.fromJson(json["order"]), success: '', // Use PutOrder
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order.toJson(),
      };
}

// Kelas PutOrder yang digunakan di PutOrdesLaundriesResponseModel
class PutOrder { // Renamed to PutOrder
  final int id;
  final int idProfile;
  final int jenisPewangiId;
  final int serviceId;
  final String pickupAddress;
  final double pickupLatitude; // Changed to double
  final double pickupLongitude; // Changed to double
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PutOrder({
    required this.id,
    required this.idProfile,
    required this.jenisPewangiId,
    required this.serviceId,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  PutOrder copyWith({
    int? id,
    int? idProfile,
    int? jenisPewangiId,
    int? serviceId,
    String? pickupAddress,
    double? pickupLatitude, // Changed to double
    double? pickupLongitude, // Changed to double
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PutOrder(
        id: id ?? this.id,
        idProfile: idProfile ?? this.idProfile,
        jenisPewangiId: jenisPewangiId ?? this.jenisPewangiId,
        serviceId: serviceId ?? this.serviceId,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PutOrder.fromRawJson(String str) => PutOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PutOrder.fromJson(Map<String, dynamic> json) => PutOrder(
        id: json["id"],
        idProfile: json["id_profile"],
        jenisPewangiId: json["jenis_pewangi_id"],
        serviceId: json["service_id"],
        pickupAddress: json["pickup_address"],
        pickupLatitude: (json["pickup_latitude"] as num).toDouble(), // Parse as double
        pickupLongitude: (json["pickup_longitude"] as num).toDouble(), // Parse as double
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_profile": idProfile,
        "jenis_pewangi_id": jenisPewangiId,
        "service_id": serviceId,
        "pickup_address": pickupAddress,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}