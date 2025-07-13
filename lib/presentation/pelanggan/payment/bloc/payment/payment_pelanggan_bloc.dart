import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/model/request/pembayaran/pembayaran_request_model.dart';
import 'package:laundry_app/data/repository/paymentrepository.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_state.dart';

class PembayaranPelangganBloc extends Bloc<PembayaranPelangganEvent, PembayaranPelangganState> {
  final PembayaranRepository pembayaranRepository;

  PembayaranPelangganBloc({required this.pembayaranRepository}) : super(PembayaranInitial()) {
    on<AddPayment>(_onAddPayment);
    on<GetMyPayments>(_onGetMyPayments);
  }

  Future<void> _onAddPayment(AddPayment event, Emitter<PembayaranPelangganState> emit) async {
    emit(PembayaranLoading());
    try {
      final requestModel = PaymentRequestModel(
        confirmationPaymentId: event.confirmationPaymentId,
        metodePembayaran: event.metodePembayaran,
        buktiPembayaran: event.buktiPembayaran,
      );
      final result = await pembayaranRepository.addPayment(requestModel);
      result.fold(
        (failure) => emit(PembayaranError(message: failure)),
        (success) => emit(PaymentAdded(paymentResponse: success)),
      );
    } catch (e) {
      emit(PembayaranError(message: 'Terjadi kesalahan tidak terduga saat menambah pembayaran: ${e.toString()}'));
    }
  }

  Future<void> _onGetMyPayments(GetMyPayments event, Emitter<PembayaranPelangganState> emit) async {
    emit(PembayaranLoading());
    try {
      final result = await pembayaranRepository.getPaymentsByPelanggan();
      result.fold(
        (failure) => emit(PembayaranError(message: failure)),
        (success) => emit(MyPaymentsLoaded(payments: success)),
      );
    } catch (e) {
      emit(PembayaranError(message: 'Terjadi kesalahan tidak terduga saat mengambil pembayaran: ${e.toString()}'));
    }
  }
}
