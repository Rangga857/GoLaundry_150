

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/model/request/comment/comment_request_model.dart';
import 'package:laundry_app/data/repository/commentrepository.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_event.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_state.dart';

class CustomerCommentBloc extends Bloc<CustomerCommentEvent, CustomerCommentState> {
  final CommentRepository commentRepository;

  CustomerCommentBloc({required this.commentRepository}) : super(CustomerCommentInitial()) {
    on<AddNewComment>(_onAddNewComment);
    on<GetMyComments>(_onGetMyComments);
  }

  Future<void> _onAddNewComment(
    AddNewComment event,
    Emitter<CustomerCommentState> emit,
  ) async {
    emit(CustomerCommentLoading());
    try {
      final newCommentData = await commentRepository.addComment(
        CommentRequestModel(
          orderId: event.orderId,
          commentText: event.commentText,
          rating: event.rating,
        ),
      );
      emit(CustomerCommentSuccess(message: 'Komentar berhasil ditambahkan.', data: newCommentData));
    } catch (e) {
      emit(CustomerCommentFailure(error: e.toString()));
    }
  }

  Future<void> _onGetMyComments(
    GetMyComments event,
    Emitter<CustomerCommentState> emit,
  ) async {
    emit(CustomerCommentLoading());
    try {
      final myCommentsResponse = await commentRepository.getMyComments();
      if (myCommentsResponse.data.isEmpty) {
        emit(CustomerCommentEmpty(message: myCommentsResponse.message));
      } else {
        emit(CustomerCommentSuccess(message: myCommentsResponse.message, data: myCommentsResponse));
      }
    } catch (e) {
      emit(CustomerCommentFailure(error: e.toString()));
    }
  }
}