import 'dart:convert';

class OrderLaundriesRequestModel {
  final String jenisPewangiName;
  final String serviceName;
  final String pickupAddress;
  final double pickupLatitude; 
  final double pickupLongitude;

  OrderLaundriesRequestModel({
    required this.jenisPewangiName,
    required this.serviceName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
  });

  OrderLaundriesRequestModel copyWith({
    String? jenisPewangiName,
    String? serviceName,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
  }) =>
      OrderLaundriesRequestModel(
        jenisPewangiName: jenisPewangiName ?? this.jenisPewangiName,
        serviceName: serviceName ?? this.serviceName,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      );

  factory OrderLaundriesRequestModel.fromRawJson(String str) =>
      OrderLaundriesRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderLaundriesRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderLaundriesRequestModel(
        jenisPewangiName: json["jenis_pewangi_name"],
        serviceName: json["service_name"],
        pickupAddress: json["pickup_address"],
        pickupLatitude: (json["pickup_latitude"]), 
        pickupLongitude: (json["pickup_longitude"]), 
      );

  Map<String, dynamic> toJson() => {
        "jenis_pewangi_name": jenisPewangiName,
        "service_name": serviceName,
        "pickup_address": pickupAddress,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
      };
}