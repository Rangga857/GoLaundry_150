import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/confirmationpaymentsrepository.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_state.dart';

class ConfirmationPaymentAdminBloc extends Bloc<ConfirmationPaymentAdminEvent, ConfirmationPaymentAdminState> {
  final ConfirmationPaymentsRepository confirmationPaymentsRepository;

  ConfirmationPaymentAdminBloc({required this.confirmationPaymentsRepository})
      : super(ConfirmationPaymentAdminInitial()) {
    on<GetAllConfirmationPaymentsForAdmin>(_onGetAllConfirmationPaymentsForAdmin);
    on<CreateNewConfirmationPayment>(_onCreateNewConfirmationPayment);
    on<GetSingleConfirmationPaymentForAdmin>(_onGetSingleConfirmationPaymentForAdmin);
  }

  Future<void> _onGetAllConfirmationPaymentsForAdmin(
    GetAllConfirmationPaymentsForAdmin event,
    Emitter<ConfirmationPaymentAdminState> emit,
  ) async {
    emit(ConfirmationPaymentAdminLoading());
    try {
      final result = await confirmationPaymentsRepository.getAllConfirmationPaymentsForAdmin();

      if (result.statusCode == 200) {
        emit(ConfirmationPaymentAdminLoaded(confirmationPayments: result));
      } else {
        emit(ConfirmationPaymentAdminError(message: result.message));
      }
    } catch (e) {
      emit(ConfirmationPaymentAdminError(message: e.toString()));
    }
  }

  Future<void> _onCreateNewConfirmationPayment(
    CreateNewConfirmationPayment event,
    Emitter<ConfirmationPaymentAdminState> emit,
  ) async {
    emit(ConfirmationPaymentAdminCreating()); 
    try {
      final result = await confirmationPaymentsRepository.createConfirmationPayment(event.requestModel);

      if (result['success'] == true) {
        emit(ConfirmationPaymentAdminCreateSuccess(message: result['message']));
        add(const GetAllConfirmationPaymentsForAdmin());
      } else {
        emit(ConfirmationPaymentAdminCreateError(message: result['message']));
      }
    } catch (e) {
      emit(ConfirmationPaymentAdminCreateError(message: e.toString()));
    }
  }

  Future<void> _onGetSingleConfirmationPaymentForAdmin(
    GetSingleConfirmationPaymentForAdmin event,
    Emitter<ConfirmationPaymentAdminState> emit,
  ) async {
    emit(SingleConfirmationPaymentLoading());
    try {
      final result = await confirmationPaymentsRepository.getConfirmationPaymentByOrderIdForAdmin(event.orderId);

      if (result['success'] == true && result['data'] != null) {
        emit(SingleConfirmationPaymentLoaded(confirmationPayment: result['data']));
      } else {
        emit(SingleConfirmationPaymentError(message: result['message'] ?? 'Konfirmasi pembayaran tidak ditemukan.'));
      }
    } catch (e) {
      emit(SingleConfirmationPaymentError(message: e.toString()));
    }
  }
}