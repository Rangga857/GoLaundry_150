import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/jenis_pewangi_repository.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_state.dart';


class JenisPewangiBloc extends Bloc<JenisPewangiEvent, JenisPewangiState> {
  final JenisPewangiRepositoryImpl repository;

  JenisPewangiBloc({required this.repository}) : super(JenisPewangiInitial()) {
    on<GetJenisPewangiAllEvent>(_onGetJenisPewangiAll);
  }

  Future<void> _onGetJenisPewangiAll(
    GetJenisPewangiAllEvent event,
    Emitter<JenisPewangiState> emit,
  ) async {
    emit(JenisPewangiLoading());
    final result = await repository.getAllJenisPewangiPelanggan();
    result.fold(
      (failure) => emit(JenisPewangiError(failure)),
      (success) => emit(JenisPewangiAllLoaded(success)),
    );
  }
}