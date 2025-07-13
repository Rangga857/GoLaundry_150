import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/commentrepository.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_state.dart';

class AdminCommentBloc extends Bloc<AdminCommentEvent, AdminCommentState> {
  final CommentRepository commentRepository;

  AdminCommentBloc({required this.commentRepository}) : super(AdminCommentInitial()) {
    on<GetCommentByOrderId>(_onGetCommentByOrderId);
  }

  Future<void> _onGetCommentByOrderId(
    GetCommentByOrderId event,
    Emitter<AdminCommentState> emit,
  ) async {
    emit(AdminCommentLoading());
    try {
      final commentResponse = await commentRepository.getCommentByOrderId(event.orderId);
      emit(AdminCommentSuccess(message: commentResponse.message, data: commentResponse));
    } catch (e) {
      if (e.toString().contains('404')) { 
        emit(AdminCommentNotFound(message: 'Komentar tidak ditemukan untuk Order ID ini.'));
      } else {
        emit(AdminCommentFailure(error: e.toString()));
      }
    }
  }
}