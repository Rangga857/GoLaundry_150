import 'dart:convert';

class PemasukanRequestModel {
    final double amount;
    final String description;
    final DateTime transactionDate;

    PemasukanRequestModel({
        required this.amount,
        required this.description,
        required this.transactionDate,
    });

    PemasukanRequestModel copyWith({
        double ? amount,
        String? description,
        DateTime? transactionDate,
    }) => 
        PemasukanRequestModel(
            amount: amount ?? this.amount,
            description: description ?? this.description,
            transactionDate: transactionDate ?? this.transactionDate,
        );

    factory PemasukanRequestModel.fromRawJson(String str) => PemasukanRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PemasukanRequestModel.fromJson(Map<String, dynamic> json) => PemasukanRequestModel(
        amount: json["amount"],
        description: json["description"],
        transactionDate: DateTime.parse(json["transaction_date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "description": description,
        "transaction_date": transactionDate.toIso8601String(),
    };
}
