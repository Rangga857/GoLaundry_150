import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/get_single_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/put_pengeluaran_response_model.dart';

abstract class PengeluaranState extends Equatable {
  const PengeluaranState();

  @override
  List<Object> get props => [];
}

class PengeluaranInitial extends PengeluaranState {}

class PengeluaranLoading extends PengeluaranState {}

class PengeluaranLoaded extends PengeluaranState {
  final GetAllPengeluaranResponseModel pengeluaranList;

  const PengeluaranLoaded({required this.pengeluaranList});

  @override
  List<Object> get props => [pengeluaranList];
}

class PengeluaranSingleLoaded extends PengeluaranState {
  final GetSinglePengeluaranResponseModel singlePengeluaran;

  const PengeluaranSingleLoaded({required this.singlePengeluaran});

  @override
  List<Object> get props => [singlePengeluaran];
}

class PengeluaranAdded extends PengeluaranState {
  final PengeluaranResponseModel newPengeluaran;

  const PengeluaranAdded({required this.newPengeluaran});

  @override
  List<Object> get props => [newPengeluaran];
}

class PengeluaranUpdated extends PengeluaranState {
  final PutPengeluaranResponseModel updatedPengeluaran;

  const PengeluaranUpdated({required this.updatedPengeluaran});

  @override
  List<Object> get props => [updatedPengeluaran];
}

class PengeluaranDeleted extends PengeluaranState {
  final String message; // Bisa disesuaikan jika API mengembalikan data spesifik setelah delete

  const PengeluaranDeleted({required this.message});

  @override
  List<Object> get props => [message];
}

class PengeluaranError extends PengeluaranState {
  final String message;

  const PengeluaranError({required this.message});

  @override
  List<Object> get props => [message];
}