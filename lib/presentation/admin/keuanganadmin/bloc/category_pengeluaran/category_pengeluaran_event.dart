import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/categorypengeluaran/category_pengeluaran_request_model.dart';

abstract class CategoryPengeluaranEvent extends Equatable {
  const CategoryPengeluaranEvent();

  @override
  List<Object> get props => [];
}

class AddCategoryPengeluaran extends CategoryPengeluaranEvent {
  final CateogryPengeluaranRequestModel requestModel;

  const AddCategoryPengeluaran({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}

class GetAllCategoriesPengeluaran extends CategoryPengeluaranEvent {
  const GetAllCategoriesPengeluaran();
}

class UpdateCategoryPengeluaran extends CategoryPengeluaranEvent {
  final int id;
  final CateogryPengeluaranRequestModel requestModel;

  const UpdateCategoryPengeluaran({required this.id, required this.requestModel});

  @override
  List<Object> get props => [id, requestModel];
}

class DeleteCategoryPengeluaran extends CategoryPengeluaranEvent {
  final int id;

  const DeleteCategoryPengeluaran({required this.id});

  @override
  List<Object> get props => [id];
}