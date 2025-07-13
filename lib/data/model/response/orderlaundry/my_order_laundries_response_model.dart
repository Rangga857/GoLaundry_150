import 'dart:convert';

class MyOrderLaundriesResponseModel {
  final List<MyOrder> orders; 

  MyOrderLaundriesResponseModel({
    required this.orders,
  });

  MyOrderLaundriesResponseModel copyWith({
    List<MyOrder>? orders,
  }) =>
      MyOrderLaundriesResponseModel(
        orders: orders ?? this.orders,
      );

  factory MyOrderLaundriesResponseModel.fromRawJson(String str) =>
      MyOrderLaundriesResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrderLaundriesResponseModel.fromJson(Map<String, dynamic> json) =>
      MyOrderLaundriesResponseModel(
        orders: List<MyOrder>.from(json["orders"].map((x) => MyOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class MyOrder { 
  final int id;
  final String profileName;
  final String pickupAddress;
  final String jenisPewangiName;
  final String serviceTitle;
  final String status;
  final double pickupLatitude;
  final double pickupLongitude; 
  

  MyOrder({
    required this.id,
    required this.profileName,
    required this.pickupAddress,
    required this.jenisPewangiName,
    required this.serviceTitle,
    required this.status,
    required this.pickupLatitude,
    required this.pickupLongitude,
  });

  MyOrder copyWith({
    int? id,
    String? profileName,
    String? pickupAddress,
    String? jenisPewangiName,
    String? serviceTitle,
    String? status,
    double? pickupLatitude, 
    double? pickupLongitude, 
  }) =>
      MyOrder(
        id: id ?? this.id,
        profileName: profileName ?? this.profileName,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        jenisPewangiName: jenisPewangiName ?? this.jenisPewangiName,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        status: status ?? this.status,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      );

  factory MyOrder.fromRawJson(String str) => MyOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
        id: json["id"],
        profileName: json["profile_name"],
        pickupAddress: json["pickup_address"],
        jenisPewangiName: json["jenis_pewangi_name"],
        serviceTitle: json["service_title"],
        status: json["status"],
        pickupLatitude: (json["pickup_latitude"] as num).toDouble(), 
        pickupLongitude: (json["pickup_longitude"] as num).toDouble(), 
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