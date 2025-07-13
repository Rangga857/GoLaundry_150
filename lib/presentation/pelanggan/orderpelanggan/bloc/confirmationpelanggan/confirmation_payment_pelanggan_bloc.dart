import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/confirmationpaymentsrepository.dart'; 
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_state.dart'; 

class ConfirmationPaymentPelangganBloc extends Bloc<ConfirmationPaymentPelangganEvent, ConfirmationPaymentPelangganState> {
  final ConfirmationPaymentsRepository confirmationPaymentsRepository;

  ConfirmationPaymentPelangganBloc({required this.confirmationPaymentsRepository})
      : super(ConfirmationPaymentPelangganInitial()) {
    on<GetConfirmationPaymentsByPelanggan>(_onGetConfirmationPaymentsByPelanggan);
    on<GetSingleConfirmationPaymentForPelanggan>(_onGetSingleConfirmationPaymentForPelanggan);
  }

  Future<void> _onGetConfirmationPaymentsByPelanggan(
    GetConfirmationPaymentsByPelanggan event,
    Emitter<ConfirmationPaymentPelangganState> emit,
  ) async {
    emit(ConfirmationPaymentPelangganLoading());
    try {
      final result = await confirmationPaymentsRepository.getConfirmationPaymentByPelanggan();
      if (result.statusCode == 200) {
        emit(ConfirmationPaymentPelangganLoaded(confirmationPayments: result));
      } else {
        emit(ConfirmationPaymentPelangganError(message: result.message));
      }
    } catch (e) {
      emit(ConfirmationPaymentPelangganError(message: e.toString()));
    }
  }

  Future<void> _onGetSingleConfirmationPaymentForPelanggan(
    GetSingleConfirmationPaymentForPelanggan event,
    Emitter<ConfirmationPaymentPelangganState> emit,
  ) async {
    emit(SingleConfirmationPaymentPelangganLoading());
    try {
      final result = await confirmationPaymentsRepository.getConfirmationPaymentByOrderIdForPelanggan(event.orderId);

      if (result['success'] == true && result['data'] != null) {
        emit(SingleConfirmationPaymentPelangganLoaded(confirmationPayment: result['data']));
      } else {
        emit(SingleConfirmationPaymentPelangganError(message: result['message'] ?? 'Konfirmasi pembayaran tidak ditemukan.'));
      }
    } catch (e) {
      emit(SingleConfirmationPaymentPelangganError(message: e.toString()));
    }
  }
}