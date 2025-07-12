import 'dart:convert';

class MyCommentResponseModel {
    final String message;
    final int statusCode;
    final List<Datum> data;

    MyCommentResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    MyCommentResponseModel copyWith({
        String? message,
        int? statusCode,
        List<Datum>? data,
    }) => 
        MyCommentResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory MyCommentResponseModel.fromRawJson(String str) => MyCommentResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MyCommentResponseModel.fromJson(Map<String, dynamic> json) => MyCommentResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final int id;
    final int orderId;
    final String orderStatus;
    final String customerProfileName;
    final String commentText;
    final int rating;
    final DateTime createdAt;
    final DateTime updatedAt;

    Datum({
        required this.id,
        required this.orderId,
        required this.orderStatus,
        required this.customerProfileName,
        required this.commentText,
        required this.rating,
        required this.createdAt,
        required this.updatedAt,
    });

    Datum copyWith({
        int? id,
        int? orderId,
        String? orderStatus,
        String? customerProfileName,
        String? commentText,
        int? rating,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            orderId: orderId ?? this.orderId,
            orderStatus: orderStatus ?? this.orderStatus,
            customerProfileName: customerProfileName ?? this.customerProfileName,
            commentText: commentText ?? this.commentText,
            rating: rating ?? this.rating,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        orderStatus: json["order_status"],
        customerProfileName: json["customer_profile_name"],
        commentText: json["comment_text"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "order_status": orderStatus,
        "customer_profile_name": customerProfileName,
        "comment_text": commentText,
        "rating": rating,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
