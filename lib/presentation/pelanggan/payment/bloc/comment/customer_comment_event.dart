sealed class CustomerCommentEvent {}

class AddNewComment extends CustomerCommentEvent {
  final int orderId;
  final String commentText;
  final int rating;

  AddNewComment({required this.orderId, required this.commentText, required this.rating});
}

class GetMyComments extends CustomerCommentEvent {}