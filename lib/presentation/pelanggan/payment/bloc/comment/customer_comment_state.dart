sealed class CustomerCommentState {}

class CustomerCommentInitial extends CustomerCommentState {}

class CustomerCommentLoading extends CustomerCommentState {}

class CustomerCommentSuccess extends CustomerCommentState {
  final String message;
  final dynamic data;

  CustomerCommentSuccess({required this.message, this.data});
}

class CustomerCommentEmpty extends CustomerCommentState {
  final String message;

  CustomerCommentEmpty({required this.message});
}

class CustomerCommentFailure extends CustomerCommentState {
  final String error;

  CustomerCommentFailure({required this.error});
}