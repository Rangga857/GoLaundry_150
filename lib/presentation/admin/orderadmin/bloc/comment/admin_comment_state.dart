import 'package:laundry_app/data/model/response/comment/get_single_comment_response_model.dart';

sealed class AdminCommentState {}

class AdminCommentInitial extends AdminCommentState {}

class AdminCommentLoading extends AdminCommentState {}

class AdminCommentSuccess extends AdminCommentState {
  final String message;
  final GetSingleCommentResponseModel data;

  AdminCommentSuccess({required this.message, required this.data});
}

class AdminCommentNotFound extends AdminCommentState {
  final String message;

  AdminCommentNotFound({required this.message});
}

class AdminCommentFailure extends AdminCommentState {
  final String error;

  AdminCommentFailure({required this.error});
}