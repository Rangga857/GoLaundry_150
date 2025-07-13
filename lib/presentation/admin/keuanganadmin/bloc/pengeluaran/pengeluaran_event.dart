import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/pengeluaran/pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/request/pengeluaran/put_pengeluaran_request_model.dart';

abstract class PengeluaranEvent extends Equatable {
  const PengeluaranEvent();

  @override
  List<Object> get props => [];
}

class AddPengeluaran extends PengeluaranEvent {
  final PengeluaranRequestModel requestModel;

  const AddPengeluaran({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}

class GetAllPengeluaran extends PengeluaranEvent {
  const GetAllPengeluaran();
}

class GetSinglePengeluaran extends PengeluaranEvent {
  final int id;

  const GetSinglePengeluaran({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdatePengeluaran extends PengeluaranEvent {
  final int id;
  final PutPengeluaranRequestModel requestModel;

  const UpdatePengeluaran({required this.id, required this.requestModel});

  @override
  List<Object> get props => [id, requestModel];
}

class DeletePengeluaran extends PengeluaranEvent {
  final int id;

  const DeletePengeluaran({required this.id});

  @override
  List<Object> get props => [id];
}