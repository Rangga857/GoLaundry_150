import 'package:equatable/equatable.dart';
import 'package:laundry_app/data/model/request/categorypengeluaran/edit_cateogory_pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/Delete_category_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/category_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/get_all_cateogry_pengeluaran_response_model.dart';

abstract class CategoryPengeluaranState extends Equatable {
  const CategoryPengeluaranState();

  @override
  List<Object> get props => [];
}

class CategoryPengeluaranInitial extends CategoryPengeluaranState {}

class CategoryPengeluaranLoading extends CategoryPengeluaranState {}

class CategoryPengeluaranLoaded extends CategoryPengeluaranState {
  final GetAllCategoryPengeluaranResponseModel categories;

  const CategoryPengeluaranLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryPengeluaranAdded extends CategoryPengeluaranState {
  final CategoryPengeluaranResponseModel newCategory;

  const CategoryPengeluaranAdded({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}

class CategoryPengeluaranUpdated extends CategoryPengeluaranState {
  final EditCateogryPengeluaranResponseModel updatedCategory;

  const CategoryPengeluaranUpdated({required this.updatedCategory});

  @override
  List<Object> get props => [updatedCategory];
}

class CategoryPengeluaranDeleted extends CategoryPengeluaranState {
  final DeleteCategoryPengeluaranResponseModel deleteResponse;

  const CategoryPengeluaranDeleted({required this.deleteResponse});

  @override
  List<Object> get props => [deleteResponse];
}

class CategoryPengeluaranError extends CategoryPengeluaranState {
  final String message;

  const CategoryPengeluaranError({required this.message});

  @override
  List<Object> get props => [message];
}