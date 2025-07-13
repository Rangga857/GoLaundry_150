import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/pembayaran/confirm_pembayaran_request_model.dart';

abstract class AdminPaymentEvent extends Equatable {
  const AdminPaymentEvent();

  @override
  List<Object> get props => [];
}

class GetAllPayments extends AdminPaymentEvent {
  const GetAllPayments();

  @override
  List<Object> get props => [];
}

class ConfirmPayment extends AdminPaymentEvent {
  final int paymentId;
  final ConfirmPembayaranRequestModel request;
  const ConfirmPayment({required this.paymentId, required this.request});

  @override
  List<Object> get props => [paymentId, request];
}

class GetPaymentById extends AdminPaymentEvent {
  final int paymentId;

  const GetPaymentById({required this.paymentId});

  @override
  List<Object> get props => [paymentId];
}