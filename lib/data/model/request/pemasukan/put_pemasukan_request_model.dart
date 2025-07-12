import 'dart:convert';

class PutPemasukanRequestModel {
    final int amount;
    final String description;
    final DateTime transactionDate;

    PutPemasukanRequestModel({
        required this.amount,
        required this.description,
        required this.transactionDate,
    });

    PutPemasukanRequestModel copyWith({
        int? amount,
        String? description,
        DateTime? transactionDate,
    }) => 
        PutPemasukanRequestModel(
            amount: amount ?? this.amount,
            description: description ?? this.description,
            transactionDate: transactionDate ?? this.transactionDate,
        );

    factory PutPemasukanRequestModel.fromRawJson(String str) => PutPemasukanRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PutPemasukanRequestModel.fromJson(Map<String, dynamic> json) => PutPemasukanRequestModel(
        amount: json["amount"],
        description: json["description"],
        transactionDate: DateTime.parse(json["transaction_date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "description": description,
        "transaction_date": "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
    };
}
