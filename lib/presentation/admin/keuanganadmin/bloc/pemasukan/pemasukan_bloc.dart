import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/pemasukan_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'pemasukan_event.dart';
import 'pemasukan_state.dart';

class PemasukanBloc extends Bloc<PemasukanEvent, PemasukanState> {
  final PemasukanRepository pemasukanRepository;

  PemasukanBloc({required this.pemasukanRepository}) : super(PemasukanInitial()) {
    on<LoadPemasukan>(_onLoadPemasukan);
    on<AddPemasukanEvent>(_onAddPemasukan);
    on<UpdatePemasukanEvent>(_onUpdatePemasukan);
    on<DeletePemasukanEvent>(_onDeletePemasukan);
    on<LoadTotalPemasukan>(_onLoadTotalPemasukan);
    on<DownloadPemasukanPdfReport>(_onDownloadPemasukanPdfReport);
  }

  Future<void> _onLoadPemasukan(LoadPemasukan event, Emitter<PemasukanState> emit) async {
    emit(PemasukanLoading());
    try {
      final pemasukanResponse = await pemasukanRepository.getAllPemasukan();
      final totalPemasukanResponse = await pemasukanRepository.getTotalPemasukan();

      emit(PemasukanLoaded(
        pemasukanList: pemasukanResponse.data,
        totalPemasukanData: totalPemasukanResponse.data,
        successMessage: null, // Clear previous success messages
      ));
    } catch (e) {
      emit(PemasukanError('Failed to load pemasukan: ${e.toString()}'));
    }
  }

  Future<void> _onAddPemasukan(AddPemasukanEvent event, Emitter<PemasukanState> emit) async {
    try {
      final response = await pemasukanRepository.addPemasukan(event.request);
      if (response.statusCode == 201) {
        await _onLoadPemasukan(const LoadPemasukan(), emit);
        if (state is PemasukanLoaded) {
          emit((state as PemasukanLoaded).copyWith(
            successMessage: 'Pemasukan berhasil ditambahkan: ${response.message}',
          ));
        } else {
            emit(PemasukanLoaded(pemasukanList: [], successMessage: 'Pemasukan berhasil ditambahkan: ${response.message}'));
        }
      } else {
        emit(PemasukanError('Gagal menambahkan pemasukan: ${response.message}'));
      }
    } catch (e) {
      emit(PemasukanError('Error menambahkan pemasukan: ${e.toString()}'));
    }
  }

  Future<void> _onUpdatePemasukan(UpdatePemasukanEvent event, Emitter<PemasukanState> emit) async {
    try {
      final response = await pemasukanRepository.updatePemasukan(event.id, event.request);
      if (response.statusCode == 200) {
        await _onLoadPemasukan(const LoadPemasukan(), emit);
         if (state is PemasukanLoaded) {
          emit((state as PemasukanLoaded).copyWith(
            successMessage: 'Pemasukan berhasil diperbarui: ${response.message}',
          ));
        } else {
            emit(PemasukanLoaded(pemasukanList: [], successMessage: 'Pemasukan berhasil diperbarui: ${response.message}'));
        }
      } else {
        emit(PemasukanError('Gagal memperbarui pemasukan: ${response.message}'));
      }
    } catch (e) {
      emit(PemasukanError('Error memperbarui pemasukan: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePemasukan(DeletePemasukanEvent event, Emitter<PemasukanState> emit) async {
    try {
      final response = await pemasukanRepository.deletePemasukan(event.id);
      if (response.statusCode == 200) { // atau 204
        await _onLoadPemasukan(const LoadPemasukan(), emit);
        if (state is PemasukanLoaded) {
          emit((state as PemasukanLoaded).copyWith(
            successMessage: 'Pemasukan berhasil dihapus: ${response.message}',
          ));
        } else {
            emit(PemasukanLoaded(pemasukanList: [], successMessage: 'Pemasukan berhasil dihapus: ${response.message}'));
        }
      } else {
        emit(PemasukanError('Gagal menghapus pemasukan: ${response.message}'));
      }
    } catch (e) {
      emit(PemasukanError('Error menghapus pemasukan: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTotalPemasukan(LoadTotalPemasukan event, Emitter<PemasukanState> emit) async {
    emit(PemasukanLoading()); // Atau state loading spesifik jika hanya ini yang di-load
    try {
      final response = await pemasukanRepository.getTotalPemasukan();
      if (state is PemasukanLoaded) {
        emit((state as PemasukanLoaded).copyWith(totalPemasukanData: response.data));
      } else {
        // Jika belum ada data pemasukan, bisa tampilkan state khusus atau loaded dengan list kosong
        emit(PemasukanLoaded(pemasukanList: [], totalPemasukanData: response.data));
      }
    } catch (e) {
      emit(PemasukanError('Failed to load total pemasukan: ${e.toString()}'));
    }
  }

  Future<void> _onDownloadPemasukanPdfReport(DownloadPemasukanPdfReport event, Emitter<PemasukanState> emit) async {
    emit(PemasukanPdfDownloading());
    try {
      final pdfBytes = await pemasukanRepository.exportPemasukanSummaryPdf();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/laporan_keuangan_pemasukan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      emit(PemasukanPdfDownloaded(filePath));
    } catch (e) {
      emit(PemasukanPdfError('Failed to download PDF report: ${e.toString()}'));
    }
  }
}