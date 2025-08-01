import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/order_repository.dart';
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
    final result = await repository.getAllOrdersAdmin(
      searchQuery: event.searchQuery,
      statusFilter: event.statusFilter,
    );

    result.fold(
      (failure) => emit(AdminOrderError(failure)),
      (responseModel) {
        emit(AdminOrderAllLoaded(
          responseModel,
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