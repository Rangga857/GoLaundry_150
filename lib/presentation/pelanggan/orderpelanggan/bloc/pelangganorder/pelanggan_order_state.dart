import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/orderlaundry/my_order_laundries_response_model.dart';
import 'package:laundry_app/data/model/response/orderlaundry/order_laundries_response_model.dart';

abstract class PelangganOrderState extends Equatable {
  const PelangganOrderState();

  @override
  List<Object> get props => [];
}

class PelangganOrderInitial extends PelangganOrderState {}

class PelangganOrderLoading extends PelangganOrderState {}

class PelangganOrderLoaded extends PelangganOrderState {
  final MyOrderLaundriesResponseModel ordersList;

  const PelangganOrderLoaded(this.ordersList);

  @override
  List<Object> get props => [ordersList];
}

class PelangganOrderAdded extends PelangganOrderState {
  final OrderLaundriesResponseModel response;

  const PelangganOrderAdded(this.response);

  @override
  List<Object> get props => [response];
}

class PelangganOrderError extends PelangganOrderState {
  final String message;

  const PelangganOrderError(this.message);

  @override
  List<Object> get props => [message];
}
