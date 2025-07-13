import 'dart:io';
import 'package:equatable/equatable.dart';


abstract class PembayaranPelangganEvent extends Equatable {
  const PembayaranPelangganEvent();

  @override
  List<Object> get props => [];
}

class AddPayment extends PembayaranPelangganEvent {
  final int confirmationPaymentId;
  final String metodePembayaran;
  final File? buktiPembayaran; 

  const AddPayment({
    required this.confirmationPaymentId,
    required this.metodePembayaran,
    this.buktiPembayaran,
  });

  @override
  List<Object> get props => [confirmationPaymentId, metodePembayaran, buktiPembayaran ?? ''];
}

class GetMyPayments extends PembayaranPelangganEvent {
  const GetMyPayments();

  @override
  List<Object> get props => [];
}
