sealed class AdminCommentEvent {}

class GetCommentByOrderId extends AdminCommentEvent {
  final int orderId;

  GetCommentByOrderId({required this.orderId});
}