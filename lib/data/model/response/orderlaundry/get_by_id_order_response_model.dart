import 'dart:convert';

class GetByIdOrderResponseModel {
  final OrderById order; // Renamed to OrderById to avoid naming conflict

  GetByIdOrderResponseModel({
    required this.order,
  });

  GetByIdOrderResponseModel copyWith({
    OrderById? order,
  }) =>
      GetByIdOrderResponseModel(
        order: order ?? this.order,
      );

  factory GetByIdOrderResponseModel.fromRawJson(String str) =>
      GetByIdOrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetByIdOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      GetByIdOrderResponseModel(
        order: OrderById.fromJson(json["order"]), // Use OrderById
      );

  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
      };
}

// Kelas OrderById yang digunakan di GetByIdOrderResponseModel
class OrderById { // Renamed to OrderById
  final int id;
  final String profileName;
  final String pickupAddress;
  final String jenisPewangiName;
  final String serviceTitle;
  final String status;
  final double pickupLatitude; // Changed to double
  final double pickupLongitude; // Changed to double

  OrderById({
    required this.id,
    required this.profileName,
    required this.pickupAddress,
    required this.jenisPewangiName,
    required this.serviceTitle,
    required this.status,
    required this.pickupLatitude,
    required this.pickupLongitude,
  });

  OrderById copyWith({
    int? id,
    String? profileName,
    String? pickupAddress,
    String? jenisPewangiName,
    String? serviceTitle,
    String? status,
    double? pickupLatitude, // Changed to double
    double? pickupLongitude, // Changed to double
  }) =>
      OrderById(
        id: id ?? this.id,
        profileName: profileName ?? this.profileName,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        jenisPewangiName: jenisPewangiName ?? this.jenisPewangiName,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        status: status ?? this.status,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      );

  factory OrderById.fromRawJson(String str) => OrderById.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderById.fromJson(Map<String, dynamic> json) => OrderById(
        id: json["id"] as int,
        profileName: json["profile_name"] as String,
        pickupAddress: json["pickup_address"] as String,
        jenisPewangiName: json["jenis_pewangi_name"] as String,
        serviceTitle: json["service_title"] as String,
        status: json["status"] as String,
        pickupLatitude: (json["pickup_latitude"] as num).toDouble(), // Parse as double
        pickupLongitude: (json["pickup_longitude"] as num).toDouble(), // Parse as double
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_name": profileName,
        "pickup_address": pickupAddress,
        "jenis_pewangi_name": jenisPewangiName,
        "service_title": serviceTitle,
        "status": status,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
      };
}