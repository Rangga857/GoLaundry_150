import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/service_laundry_repository.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_state.dart';

class AdminServiceLaundryBloc extends Bloc<AdminServiceLaundryEvent, AdminServiceLaundryState> {
  final ServiceLaundryRepository repository; 

  AdminServiceLaundryBloc({required this.repository}) : super(AdminServiceLaundryInitial()) {
    on<GetAdminServiceLaundryAllEvent>(_onGetAdminServiceLaundryAll);
    on<GetAdminServiceLaundryByIdEvent>(_onGetAdminServiceLaundryById);
    on<AddServiceLaundryEvent>(_onAddServiceLaundry);
    on<UpdateServiceLaundryEvent>(_onUpdateServiceLaundry);
    on<DeleteServiceLaundryEvent>(_onDeleteServiceLaundry);
  }

  Future<void> _onGetAdminServiceLaundryAll(
    GetAdminServiceLaundryAllEvent event,
    Emitter<AdminServiceLaundryState> emit,
  ) async {
    emit(AdminServiceLaundryLoading());
    final result = await repository.getAllServiceLaundryAdmin();
    result.fold(
      (failure) => emit(AdminServiceLaundryError(failure)),
      (success) => emit(AdminServiceLaundryAllLoaded(success)),
    );
  }

  Future<void> _onGetAdminServiceLaundryById(
    GetAdminServiceLaundryByIdEvent event,
    Emitter<AdminServiceLaundryState> emit,
  ) async {
    emit(AdminServiceLaundryLoading());
    final result = await repository.getServiceLaundryById(event.id);
    result.fold(
      (failure) => emit(AdminServiceLaundryError(failure)),
      (success) => emit(AdminServiceLaundryByIdLoaded(success)),
    );
  }

  Future<void> _onAddServiceLaundry(
    AddServiceLaundryEvent event,
    Emitter<AdminServiceLaundryState> emit,
  ) async {
    emit(AdminServiceLaundryLoading());
    final result = await repository.addServiceLaundry(event.request);
    result.fold(
      (failure) => emit(AdminServiceLaundryError(failure)),
      (success) => emit(ServiceLaundryAdded(success)),
    );
  }

  Future<void> _onUpdateServiceLaundry(
    UpdateServiceLaundryEvent event,
    Emitter<AdminServiceLaundryState> emit,
  ) async {
    emit(AdminServiceLaundryLoading());
    final result = await repository.updateServiceLaundry(event.id, event.request);
    result.fold(
      (failure) => emit(AdminServiceLaundryError(failure)),
      (success) => emit(ServiceLaundryUpdated(success)),
    );
  }

  Future<void> _onDeleteServiceLaundry(
    DeleteServiceLaundryEvent event,
    Emitter<AdminServiceLaundryState> emit,
  ) async {
    emit(AdminServiceLaundryLoading());
    final result = await repository.deleteServiceLaundry(event.id);
    result.fold(
      (failure) => emit(AdminServiceLaundryError(failure)),
      (success) => emit(ServiceLaundryDeleted(success)),
    );
  }
}
