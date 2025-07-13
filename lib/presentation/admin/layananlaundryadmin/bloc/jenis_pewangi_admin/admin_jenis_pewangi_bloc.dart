import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/jenis_pewangi_repository.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_state.dart';

class AdminJenisPewangiBloc extends Bloc<AdminJenisPewangiEvent, AdminJenisPewangiState> {
  final JenisPewangiRepositoryImpl repository;

  AdminJenisPewangiBloc({required this.repository}) : super(AdminJenisPewangiInitial()) {
    on<GetAdminJenisPewangiAllEvent>(_onGetAdminJenisPewangiAll);
    on<GetAdminJenisPewangiByIdEvent>(_onGetAdminJenisPewangiById);
    on<AddJenisPewangiEvent>(_onAddJenisPewangi);
    on<UpdateJenisPewangiEvent>(_onUpdateJenisPewangi);
    on<DeleteJenisPewangiEvent>(_onDeleteJenisPewangi);
  }

  Future<void> _onGetAdminJenisPewangiAll(
    GetAdminJenisPewangiAllEvent event,
    Emitter<AdminJenisPewangiState> emit,
  ) async {
    emit(AdminJenisPewangiLoading());
    final result = await repository.getAllJenisPewangiAdmin();
    result.fold(
      (failure) => emit(AdminJenisPewangiError(failure)),
      (success) => emit(AdminJenisPewangiAllLoaded(success)),
    );
  }

  Future<void> _onGetAdminJenisPewangiById(
    GetAdminJenisPewangiByIdEvent event,
    Emitter<AdminJenisPewangiState> emit,
  ) async {
    emit(AdminJenisPewangiLoading());
    final result = await repository.getJenisPewangiById(event.id);
    result.fold(
      (failure) => emit(AdminJenisPewangiError(failure)),
      (success) => emit(AdminJenisPewangiByIdLoaded(success)),
    );
  }

  Future<void> _onAddJenisPewangi(
    AddJenisPewangiEvent event,
    Emitter<AdminJenisPewangiState> emit,
  ) async {
    emit(AdminJenisPewangiLoading());
    final result = await repository.addJenisPewangi(event.request);
    result.fold(
      (failure) => emit(AdminJenisPewangiError(failure)),
      (success) => emit(JenisPewangiAdded(success)),
    );
  }

  Future<void> _onUpdateJenisPewangi(
    UpdateJenisPewangiEvent event,
    Emitter<AdminJenisPewangiState> emit,
  ) async {
    emit(AdminJenisPewangiLoading());
    final result = await repository.updateJenisPewangi(event.id, event.request);
    result.fold(
      (failure) => emit(AdminJenisPewangiError(failure)),
      (success) => emit(JenisPewangiUpdated(success)),
    );
  }

  Future<void> _onDeleteJenisPewangi(
    DeleteJenisPewangiEvent event,
    Emitter<AdminJenisPewangiState> emit,
  ) async {
    emit(AdminJenisPewangiLoading());
    final result = await repository.deleteJenisPewangi(event.id);
    result.fold(
      (failure) => emit(AdminJenisPewangiError(failure)),
      (success) => emit(JenisPewangiDeleted(success)),
    );
  }
}