import 'dart:convert';

class CommentRequestModel {
    final int orderId;
    final String commentText;
    final int rating;

    CommentRequestModel({
        required this.orderId,
        required this.commentText,
        required this.rating,
    });

    CommentRequestModel copyWith({
        int? orderId,
        String? commentText,
        int? rating,
    }) => 
        CommentRequestModel(
            orderId: orderId ?? this.orderId,
            commentText: commentText ?? this.commentText,
            rating: rating ?? this.rating,
        );

    factory CommentRequestModel.fromRawJson(String str) => CommentRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CommentRequestModel.fromJson(Map<String, dynamic> json) => CommentRequestModel(
        orderId: json["order_id"],
        commentText: json["comment_text"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "comment_text": commentText,
        "rating": rating,
    };
}
