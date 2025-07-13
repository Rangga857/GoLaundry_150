import 'package:equatable/equatable.dart';

abstract class ConfirmationPaymentPelangganEvent extends Equatable {
  const ConfirmationPaymentPelangganEvent();

  @override
  List<Object> get props => [];
}

class GetConfirmationPaymentsByPelanggan extends ConfirmationPaymentPelangganEvent {}

class GetSingleConfirmationPaymentForPelanggan extends ConfirmationPaymentPelangganEvent {
  final int orderId;

  const GetSingleConfirmationPaymentForPelanggan({required this.orderId});

  @override
  List<Object> get props => [orderId];
}