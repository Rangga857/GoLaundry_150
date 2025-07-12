import 'dart:convert';

class PutOrdesLaundriesRequestModel {
    final String status;

    PutOrdesLaundriesRequestModel({
        required this.status,
    });

    PutOrdesLaundriesRequestModel copyWith({
        String? status,
    }) => 
        PutOrdesLaundriesRequestModel(
            status: status ?? this.status,
        );

    factory PutOrdesLaundriesRequestModel.fromRawJson(String str) => PutOrdesLaundriesRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PutOrdesLaundriesRequestModel.fromJson(Map<String, dynamic> json) => PutOrdesLaundriesRequestModel(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
