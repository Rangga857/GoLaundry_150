import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/orderlaundry/order_laundries_request_model.dart';

abstract class PelangganOrderEvent extends Equatable {
  const PelangganOrderEvent();

  @override
  List<Object> get props => [];
}

class GetMyOrdersEvent extends PelangganOrderEvent {
  const GetMyOrdersEvent();
}

class AddOrderEvent extends PelangganOrderEvent {
  final OrderLaundriesRequestModel request;

  const AddOrderEvent({required this.request});

  @override
  List<Object> get props => [request];
}
