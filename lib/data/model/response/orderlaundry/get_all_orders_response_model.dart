import 'dart:convert';

class GetAllOrdersResponseModel {
  final List<Order> orders;

  GetAllOrdersResponseModel({
    required this.orders,
  });

  GetAllOrdersResponseModel copyWith({
    List<Order>? orders,
  }) =>
      GetAllOrdersResponseModel(
        orders: orders ?? this.orders,
      );

  factory GetAllOrdersResponseModel.fromRawJson(String str) =>
      GetAllOrdersResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllOrdersResponseModel(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

// Kelas Order yang digunakan di GetAllOrdersResponseModel
class Order {
  final int id;
  final String profileName;
  final String pickupAddress;
  final String jenisPewangiName;
  final String serviceTitle;
  final String status;
  final double pickupLatitude; // Changed to double
  final double pickupLongitude; // Changed to double

  Order({
    required this.id,
    required this.profileName,
    required this.pickupAddress,
    required this.jenisPewangiName,
    required this.serviceTitle,
    required this.status,
    required this.pickupLatitude,
    required this.pickupLongitude,
  });

  Order copyWith({
    int? id,
    String? profileName,
    String? pickupAddress,
    String? jenisPewangiName,
    String? serviceTitle,
    String? status,
    double? pickupLatitude, // Changed to double
    double? pickupLongitude, // Changed to double
  }) =>
      Order(
        id: id ?? this.id,
        profileName: profileName ?? this.profileName,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        jenisPewangiName: jenisPewangiName ?? this.jenisPewangiName,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        status: status ?? this.status,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      );

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        profileName: json["profile_name"],
        pickupAddress: json["pickup_address"],
        jenisPewangiName: json["jenis_pewangi_name"],
        serviceTitle: json["service_title"],
        status: json["status"],
        pickupLatitude: (json["pickup_latitude"]), // Parse as double
        pickupLongitude: (json["pickup_longitude"]), // Parse as double
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