
import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_event.dart';

abstract class ConfirmationPaymentAdminState extends Equatable {
  const ConfirmationPaymentAdminState();

  @override
  List<Object> get props => [];
}

class ConfirmationPaymentAdminInitial extends ConfirmationPaymentAdminState {}

class ConfirmationPaymentAdminLoading extends ConfirmationPaymentAdminState {}

class ConfirmationPaymentAdminLoaded extends ConfirmationPaymentAdminState {
  final GetAllConfirmationPaymentResponseModel confirmationPayments;

  const ConfirmationPaymentAdminLoaded({required this.confirmationPayments});

  @override
  List<Object> get props => [confirmationPayments];
}

class ConfirmationPaymentAdminError extends ConfirmationPaymentAdminState {
  final String message;

  const ConfirmationPaymentAdminError({required this.message});

  @override
  List<Object> get props => [message];
}

class ConfirmationPaymentAdminCreating extends ConfirmationPaymentAdminState {}

class ConfirmationPaymentAdminCreateSuccess extends ConfirmationPaymentAdminState {
  final String message;

  const ConfirmationPaymentAdminCreateSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ConfirmationPaymentAdminCreateError extends ConfirmationPaymentAdminState {
  final String message;

  const ConfirmationPaymentAdminCreateError({required this.message});

  @override
  List<Object> get props => [message];
}

class SingleConfirmationPaymentLoading extends ConfirmationPaymentAdminState {}

class SingleConfirmationPaymentLoaded extends ConfirmationPaymentAdminState {
  final Datum confirmationPayment;

  const SingleConfirmationPaymentLoaded({required this.confirmationPayment});

  @override
  List<Object> get props => [confirmationPayment];
}

class SingleConfirmationPaymentError extends ConfirmationPaymentAdminState {
  final String message;

  const SingleConfirmationPaymentError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetSingleConfirmationPaymentForAdmin extends ConfirmationPaymentAdminEvent {
  final int orderId;

  const GetSingleConfirmationPaymentForAdmin({required this.orderId});

  @override
  List<Object> get props => [orderId];
}