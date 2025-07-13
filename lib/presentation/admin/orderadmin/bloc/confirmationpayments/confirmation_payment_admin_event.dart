
import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/confirmationpayments/confirmation_payment_request_model.dart';

abstract class ConfirmationPaymentAdminEvent extends Equatable {
  const ConfirmationPaymentAdminEvent();

  @override
  List<Object> get props => [];
}

class GetAllConfirmationPaymentsForAdmin extends ConfirmationPaymentAdminEvent {
  const GetAllConfirmationPaymentsForAdmin();
}

class CreateNewConfirmationPayment extends ConfirmationPaymentAdminEvent {
  final ConfirmationPaymentRequestModel requestModel;

  const CreateNewConfirmationPayment({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}