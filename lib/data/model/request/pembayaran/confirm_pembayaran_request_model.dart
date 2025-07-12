import 'dart:convert';

class ConfirmPembayaranRequestModel {
    final String status;

    ConfirmPembayaranRequestModel({
        required this.status,
    });

    ConfirmPembayaranRequestModel copyWith({
        String? status,
    }) => 
        ConfirmPembayaranRequestModel(
            status: status ?? this.status,
        );

    factory ConfirmPembayaranRequestModel.fromRawJson(String str) => ConfirmPembayaranRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConfirmPembayaranRequestModel.fromJson(Map<String, dynamic> json) => ConfirmPembayaranRequestModel(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
