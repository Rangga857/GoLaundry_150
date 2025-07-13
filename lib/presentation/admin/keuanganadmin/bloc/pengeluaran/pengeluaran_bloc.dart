import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/pengeluaran_repository.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final PengeluaranRepository _repository;

  PengeluaranBloc({required PengeluaranRepository repository})
      : _repository = repository,
        super(PengeluaranInitial()) {
    on<AddPengeluaran>(_onAddPengeluaran);
    on<GetAllPengeluaran>(_onGetAllPengeluaran);
    on<GetSinglePengeluaran>(_onGetSinglePengeluaran);
    on<UpdatePengeluaran>(_onUpdatePengeluaran);
    on<DeletePengeluaran>(_onDeletePengeluaran);
  }

  Future<void> _onAddPengeluaran(
    AddPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      final newPengeluaran = await _repository.addPengeluaran(event.requestModel);
      emit(PengeluaranAdded(newPengeluaran: newPengeluaran));
      add(const GetAllPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onGetAllPengeluaran(
    GetAllPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      final pengeluaranList = await _repository.getAllPengeluaran();
      emit(PengeluaranLoaded(pengeluaranList: pengeluaranList));
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onGetSinglePengeluaran(
    GetSinglePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      final singlePengeluaran = await _repository.getPengeluaranById(event.id);
      emit(PengeluaranSingleLoaded(singlePengeluaran: singlePengeluaran));
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePengeluaran(
    UpdatePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      final updatedPengeluaran = await _repository.updatePengeluaran(event.id, event.requestModel);
      emit(PengeluaranUpdated(updatedPengeluaran: updatedPengeluaran));
      add(const GetAllPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onDeletePengeluaran(
    DeletePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      await _repository.deletePengeluaran(event.id);
      emit(const PengeluaranDeleted(message: 'Pengeluaran berhasil dihapus!'));
      add(const GetAllPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }
}