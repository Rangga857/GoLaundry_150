import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/pemasukan/pemasukan_request_model.dart';
import 'package:laundry_app/data/model/request/pemasukan/put_pemasukan_request_model.dart';

abstract class PemasukanEvent extends Equatable {
  const PemasukanEvent();

  @override
  List<Object> get props => [];
}

class LoadPemasukan extends PemasukanEvent {
  const LoadPemasukan();
}

class AddPemasukanEvent extends PemasukanEvent {
  final PemasukanRequestModel request;

  const AddPemasukanEvent(this.request);

  @override
  List<Object> get props => [request];
}

class UpdatePemasukanEvent extends PemasukanEvent {
  final int id;
  final PutPemasukanRequestModel request;

  const UpdatePemasukanEvent({required this.id, required this.request});

  @override
  List<Object> get props => [id, request];
}

class DeletePemasukanEvent extends PemasukanEvent {
  final int id;

  const DeletePemasukanEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadTotalPemasukan extends PemasukanEvent {
  const LoadTotalPemasukan();
}

class DownloadPemasukanPdfReport extends PemasukanEvent {
  const DownloadPemasukanPdfReport();
}