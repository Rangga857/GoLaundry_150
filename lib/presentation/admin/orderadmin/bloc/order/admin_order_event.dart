import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/orderlaundry/put_order_laundies_request_model.dart';

abstract class AdminOrderEvent extends Equatable {
  const AdminOrderEvent();

  @override
  List<Object> get props => [];
}

class GetAdminOrdersAllEvent extends AdminOrderEvent {
  final String? searchQuery;
  final String? statusFilter; 

  const GetAdminOrdersAllEvent({this.searchQuery, this.statusFilter});

  @override
  List<Object> get props => [searchQuery ?? '', statusFilter ?? ''];
}

class GetAdminOrderByIdEvent extends AdminOrderEvent {
  final int id;

  const GetAdminOrderByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateOrderStatusEvent extends AdminOrderEvent {
  final int id;
  final PutOrdesLaundriesRequestModel request;

  const UpdateOrderStatusEvent({required this.id, required this.request});

  @override
  List<Object> get props => [id, request];
}