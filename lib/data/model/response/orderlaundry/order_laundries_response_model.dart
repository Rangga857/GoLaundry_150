import 'dart:convert';

class OrderLaundriesResponseModel {
  final String success;
  final OrderDetail order;

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
        success: json["success"], 
        order: OrderDetail.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order.toJson(),
      };
}

class OrderDetail {
  final int id; 
  final String profileName;
  final String pickupAddress;
  final String jenisPewangiName; 
  final String serviceTitle; 
  final String status;
  final double pickupLatitude;
  final double pickupLongitude;
  final DateTime createdAt;
  final DateTime updatedAt;


  OrderDetail({
    required this.id,
    required this.profileName,
    required this.pickupAddress,
    required this.jenisPewangiName,
    required this.serviceTitle,
    required this.status,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderDetail copyWith({
    int? id,
    String? profileName,
    String? pickupAddress,
    String? jenisPewangiName,
    String? serviceTitle,
    String? status,
    double? pickupLatitude,
    double? pickupLongitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      OrderDetail(
        id: id ?? this.id,
        profileName: profileName ?? this.profileName,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        jenisPewangiName: jenisPewangiName ?? this.jenisPewangiName,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        status: status ?? this.status,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory OrderDetail.fromRawJson(String str) => OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        profileName: json["profile_name"], 
        pickupAddress: json["pickup_address"],
        jenisPewangiName: json["jenis_pewangi_name"], 
        serviceTitle: json["service_title"], 
        status: json["status"],
        pickupLatitude: (json["pickup_latitude"] as num).toDouble(),
        pickupLongitude: (json["pickup_longitude"] as num).toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}