import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/service_laundry_repository.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_event.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_state.dart';

class ServiceLaundryBloc extends Bloc<ServiceLaundryEvent, ServiceLaundryState> {
  final ServiceLaundryRepositoryImpl repository;

  ServiceLaundryBloc({required this.repository}) : super(ServiceLaundryInitial()) {
    on<GetServiceLaundryAllEvent>(_onGetServiceLaundryAll);
  }

  Future<void> _onGetServiceLaundryAll(
    GetServiceLaundryAllEvent event,
    Emitter<ServiceLaundryState> emit,
  ) async {
    emit(ServiceLaundryLoading());
    final result = await repository.getAllServiceLaundryPelanggan(); // Customer-specific method
    result.fold(
      (failure) => emit(ServiceLaundryError(failure)),
      (success) => emit(ServiceLaundryAllLoaded(success)),
    );
  }

}