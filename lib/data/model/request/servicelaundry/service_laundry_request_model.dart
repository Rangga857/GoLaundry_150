import 'dart:convert';

class ServiceLaundryRequestModel {
    final String title;
    final String subtitle;
    final int priceperkg;

    ServiceLaundryRequestModel({
        required this.title,
        required this.subtitle,
        required this.priceperkg,
    });

    ServiceLaundryRequestModel copyWith({
        String? title,
        String? subtitle,
        int? priceperkg,
    }) => 
        ServiceLaundryRequestModel(
            title: title ?? this.title,
            subtitle: subtitle ?? this.subtitle,
            priceperkg: priceperkg ?? this.priceperkg,
        );

    factory ServiceLaundryRequestModel.fromRawJson(String str) => ServiceLaundryRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ServiceLaundryRequestModel.fromJson(Map<String, dynamic> json) => ServiceLaundryRequestModel(
        title: json["title"],
        subtitle: json["subtitle"],
        priceperkg: json["priceperkg"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "priceperkg": priceperkg,
    };
}
