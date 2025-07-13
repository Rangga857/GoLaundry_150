import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_all_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/confirm_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_by_id_pembayaran_response_model.dart'; // Import ini untuk kelas Data

abstract class AdminPaymentState extends Equatable {
  const AdminPaymentState();

  @override
  List<Object> get props => [];
}

class AdminPaymentInitial extends AdminPaymentState {}

class AdminPaymentLoading extends AdminPaymentState {}

class AllPaymentsLoaded extends AdminPaymentState {
  final GetAllPembayaranResponseModel payments;

  const AllPaymentsLoaded({required this.payments});

  @override
  List<Object> get props => [payments];
}

class PaymentConfirmed extends AdminPaymentState {
  final ConfirmPembayaranResponseModel paymentResponse;

  const PaymentConfirmed({required this.paymentResponse});

  @override
  List<Object> get props => [paymentResponse];
}

class PaymentRejected extends AdminPaymentState {
  final PaymentResponseModel paymentResponse;

  const PaymentRejected({required this.paymentResponse});

  @override
  List<Object> get props => [paymentResponse];
}

class AdminPaymentError extends AdminPaymentState {
  final String message;

  const AdminPaymentError({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentDetailLoading extends AdminPaymentState {}

class PaymentDetailLoaded extends AdminPaymentState {
  final Data paymentDetail;

  const PaymentDetailLoaded({required this.paymentDetail});

  @override
  List<Object> get props => [paymentDetail];
}