import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart'; // Pastikan Datum dan GetAllConfirmationPaymentResponseModel terimport

// part of 'confirmation_payment_pelanggan_bloc.dart'; // Jangan lupa tambahkan ini di blocnya nanti

abstract class ConfirmationPaymentPelangganState extends Equatable {
  const ConfirmationPaymentPelangganState();

  @override
  List<Object> get props => [];
}

class ConfirmationPaymentPelangganInitial extends ConfirmationPaymentPelangganState {}
class ConfirmationPaymentPelangganLoading extends ConfirmationPaymentPelangganState {}
class ConfirmationPaymentPelangganLoaded extends ConfirmationPaymentPelangganState {
  final GetAllConfirmationPaymentResponseModel confirmationPayments;

  const ConfirmationPaymentPelangganLoaded({required this.confirmationPayments});

  @override
  List<Object> get props => [confirmationPayments];
}
class ConfirmationPaymentPelangganError extends ConfirmationPaymentPelangganState {
  final String message;

  const ConfirmationPaymentPelangganError({required this.message});

  @override
  List<Object> get props => [message];
}

class SingleConfirmationPaymentPelangganLoading extends ConfirmationPaymentPelangganState {}

class SingleConfirmationPaymentPelangganLoaded extends ConfirmationPaymentPelangganState {
  final Datum confirmationPayment; 

  const SingleConfirmationPaymentPelangganLoaded({required this.confirmationPayment});

  @override
  List<Object> get props => [confirmationPayment];
}

class SingleConfirmationPaymentPelangganError extends ConfirmationPaymentPelangganState {
  final String message;

  const SingleConfirmationPaymentPelangganError({required this.message});

  @override
  List<Object> get props => [message];
}