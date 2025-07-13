// lib/blocs/pemasukan/pemasukan_state.dart
import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_total_pemasukan_response_model.dart';

import '../../../../../data/model/response/pemasukan/get_manual_pemasukan_response_model.dart';

abstract class PemasukanState extends Equatable {
  const PemasukanState();

  @override
  List<Object?> get props => [];
}

class PemasukanInitial extends PemasukanState {}

class PemasukanLoading extends PemasukanState {}

class PemasukanLoaded extends PemasukanState {
  final List<Datum> pemasukanList;
  final Data? totalPemasukanData; 
  final String? successMessage;

  const PemasukanLoaded({
    required this.pemasukanList,
    this.totalPemasukanData,
    this.successMessage,
  });

  PemasukanLoaded copyWith({
    List<Datum>? pemasukanList,
    Data? totalPemasukanData,
    String? successMessage,
  }) {
    return PemasukanLoaded(
      pemasukanList: pemasukanList ?? this.pemasukanList,
      totalPemasukanData: totalPemasukanData ?? this.totalPemasukanData,
      successMessage: successMessage, 
    );
  }

  @override
  List<Object?> get props => [pemasukanList, totalPemasukanData, successMessage];
}

class PemasukanError extends PemasukanState {
  final String message;

  const PemasukanError(this.message);

  @override
  List<Object?> get props => [message];
}
class PemasukanPdfDownloading extends PemasukanState {}

class PemasukanPdfDownloaded extends PemasukanState {
  final String filePath; 

  const PemasukanPdfDownloaded(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class PemasukanPdfError extends PemasukanState {
  final String message;

  const PemasukanPdfError(this.message);

  @override
  List<Object?> get props => [message];
}