import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/paymentrepository.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_state.dart';

class AdminPaymentBloc extends Bloc<AdminPaymentEvent, AdminPaymentState> {
  final PembayaranRepository pembayaranRepository;

  AdminPaymentBloc({required this.pembayaranRepository}) : super(AdminPaymentInitial()) {
    on<GetAllPayments>(_onGetAllPayments);
    on<ConfirmPayment>(_onConfirmPayment);
    on<GetPaymentById>(_onGetPaymentById);
  }

  Future<void> _onGetAllPayments(GetAllPayments event, Emitter<AdminPaymentState> emit) async {
    emit(AdminPaymentLoading());
    try {
      final result = await pembayaranRepository.getAllPayments();
      result.fold(
        (failure) => emit(AdminPaymentError(message: failure)),
        (success) => emit(AllPaymentsLoaded(payments: success)),
      );
    } catch (e) {
      emit(AdminPaymentError(message: 'Terjadi kesalahan tidak terduga saat mengambil semua pembayaran: ${e.toString()}'));
    }
  }

  Future<void> _onConfirmPayment(ConfirmPayment event, Emitter<AdminPaymentState> emit) async {
    emit(AdminPaymentLoading());
    try {
      final result = await pembayaranRepository.confirmPayment(event.paymentId, event.request);
      result.fold(
        (failure) => emit(AdminPaymentError(message: failure)),
        (success) => emit(PaymentConfirmed(paymentResponse: success)),
      );
    } catch (e) {
      emit(AdminPaymentError(message: 'Terjadi kesalahan tidak terduga saat mengonfirmasi pembayaran: ${e.toString()}'));
    }
  }

  Future<void> _onGetPaymentById(GetPaymentById event, Emitter<AdminPaymentState> emit) async {
    emit(AdminPaymentLoading()); 
    try {
      final result = await pembayaranRepository.getPaymentById(event.paymentId);
      result.fold(
        (failure) => emit(AdminPaymentError(message: failure)),
        (success) {
          if (success.data != null) {
            emit(PaymentDetailLoaded(paymentDetail: success.data));
          } else {
            emit(AdminPaymentError(message: 'Detail pembayaran tidak ditemukan.'));
          }
        },
      );
    } catch (e) {
      emit(AdminPaymentError(message: 'Terjadi kesalahan tidak terduga saat mengambil detail pembayaran: ${e.toString()}'));
    }
  }
}