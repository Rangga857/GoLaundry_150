import 'dart:convert';

class GetSingleCommentResponseModel {
    final String message;
    final int statusCode;
    final Data data;

    GetSingleCommentResponseModel({
        required this.message,
        required this.statusCode,
        required this.data,
    });

    GetSingleCommentResponseModel copyWith({
        String? message,
        int? statusCode,
        Data? data,
    }) => 
        GetSingleCommentResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetSingleCommentResponseModel.fromRawJson(String str) => GetSingleCommentResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetSingleCommentResponseModel.fromJson(Map<String, dynamic> json) => GetSingleCommentResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
    };
}

class Data {
    final int id;
    final int orderId;
    final String orderStatus;
    final String customerProfileName;
    final String commentText;
    final int rating;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.orderId,
        required this.orderStatus,
        required this.customerProfileName,
        required this.commentText,
        required this.rating,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        int? orderId,
        String? orderStatus,
        String? customerProfileName,
        String? commentText,
        int? rating,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            orderId: orderId ?? this.orderId,
            orderStatus: orderStatus ?? this.orderStatus,
            customerProfileName: customerProfileName ?? this.customerProfileName,
            commentText: commentText ?? this.commentText,
            rating: rating ?? this.rating,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
