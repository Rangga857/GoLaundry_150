import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/order_repository.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_state.dart';

class PelangganOrderBloc extends Bloc<PelangganOrderEvent, PelangganOrderState> {
  final OrderRepository repository;

  PelangganOrderBloc({required this.repository}) : super(PelangganOrderInitial()) {
    on<GetMyOrdersEvent>(_onGetMyOrders);
    on<AddOrderEvent>(_onAddOrder);
  }

  Future<void> _onGetMyOrders(
    GetMyOrdersEvent event,
    Emitter<PelangganOrderState> emit,
  ) async {
    emit(PelangganOrderLoading());
    final result = await repository.getOrdersByProfile();
    result.fold(
      (failure) => emit(PelangganOrderError(failure)),
      (success) => emit(PelangganOrderLoaded(success)),
    );
  }

  Future<void> _onAddOrder(
    AddOrderEvent event,
    Emitter<PelangganOrderState> emit,
  ) async {
    emit(PelangganOrderLoading());
    final result = await repository.addOrder(event.request);
    result.fold(
      (failure) => emit(PelangganOrderError(failure)),
      (success) => emit(PelangganOrderAdded(success)),
    );
  }
}
