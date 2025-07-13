import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/order_repository.dart';
import 'package:laundry_app/data/model/response/orderlaundry/get_all_orders_response_model.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_state.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final OrderRepository repository;

  AdminOrderBloc({required this.repository}) : super(AdminOrderInitial()) {
    on<GetAdminOrdersAllEvent>(_onGetAdminOrdersAll);
    on<GetAdminOrderByIdEvent>(_onGetAdminOrderById);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onGetAdminOrdersAll(
    GetAdminOrdersAllEvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(AdminOrderLoading());
    final result = await repository.getAllOrdersAdmin();

    result.fold(
      (failure) => emit(AdminOrderError(failure)),
      (responseModel) {
        List<Order> orders = responseModel.orders;

        if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
          final query = event.searchQuery!.toLowerCase();
          orders = orders
              .where((order) =>
                  order.profileName.toLowerCase().contains(query))
              .toList();
        }

        if (event.statusFilter != null && event.statusFilter != 'All') {
          orders = orders
              .where((order) => order.status == event.statusFilter)
              .toList();
        }

        final filteredResponseModel = GetAllOrdersResponseModel(
          orders: orders,
        );
        emit(AdminOrderAllLoaded(
          filteredResponseModel,
          lastSearchQuery: event.searchQuery, 
          lastStatusFilter: event.statusFilter, 
        ));
      },
    );
  }

  Future<void> _onGetAdminOrderById(
    GetAdminOrderByIdEvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(AdminOrderLoading());
    final result = await repository.getSpecificOrderForAdmin(event.id);
    result.fold(
      (failure) => emit(AdminOrderError(failure)),
      (success) => emit(AdminOrderByIdLoaded(success)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(AdminOrderLoading());
    final result = await repository.updateOrderStatus(event.id, event.request);
    result.fold(
      (failure) => emit(AdminOrderError(failure)),
      (success) => emit(AdminOrderStatusUpdated(success)),
    );
  }
}