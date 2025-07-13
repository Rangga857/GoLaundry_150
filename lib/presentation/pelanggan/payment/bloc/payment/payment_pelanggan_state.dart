import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_my_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/pembayaran_response_model.dart'; 

abstract class PembayaranPelangganState extends Equatable {
  const PembayaranPelangganState();

  @override
  List<Object> get props => [];
}

class PembayaranInitial extends PembayaranPelangganState {}

class PembayaranLoading extends PembayaranPelangganState {}

class PaymentAdded extends PembayaranPelangganState {
  final PaymentResponseModel paymentResponse;

  const PaymentAdded({required this.paymentResponse});

  @override
  List<Object> get props => [paymentResponse];
}

class MyPaymentsLoaded extends PembayaranPelangganState {
  final GetMyPembayaranResponseModel payments;

  const MyPaymentsLoaded({required this.payments});

  @override
  List<Object> get props => [payments];
}

class PembayaranError extends PembayaranPelangganState {
  final String message;

  const PembayaranError({required this.message});

  @override
  List<Object> get props => [message];
}
