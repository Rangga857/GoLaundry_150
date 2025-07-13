import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/orderlaundry/get_all_orders_response_model.dart';
import 'package:laundry_app/data/model/response/orderlaundry/get_by_id_order_response_model.dart';
import 'package:laundry_app/data/model/response/orderlaundry/put_order_laundries_response_model.dart';

abstract class AdminOrderState extends Equatable {
  const AdminOrderState();

  @override
  List<Object> get props => [];
}

class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrderAllLoaded extends AdminOrderState {
  final GetAllOrdersResponseModel ordersList;
  final String? lastSearchQuery;
  final String? lastStatusFilter; 

  const AdminOrderAllLoaded(this.ordersList, {this.lastSearchQuery, this.lastStatusFilter});

  @override
  List<Object> get props => [ordersList, lastSearchQuery ?? '', lastStatusFilter ?? ''];
}

class AdminOrderByIdLoaded extends AdminOrderState {
  final GetByIdOrderResponseModel order;

  const AdminOrderByIdLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class AdminOrderStatusUpdated extends AdminOrderState {
  final PutOrdesLaundriesResponseModel response;

  const AdminOrderStatusUpdated(this.response);

  @override
  List<Object> get props => [response];
}

class AdminOrderError extends AdminOrderState {
  final String message;

  const AdminOrderError(this.message);

  @override
  List<Object> get props => [message];
}