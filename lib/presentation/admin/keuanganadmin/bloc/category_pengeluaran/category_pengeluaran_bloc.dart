import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/category_pengeluaran_repository.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_state.dart';

class CategoryPengeluaranBloc extends Bloc<CategoryPengeluaranEvent, CategoryPengeluaranState> {
  final CategoryPengeluaranRepository _repository;

  CategoryPengeluaranBloc({required CategoryPengeluaranRepository repository})
      : _repository = repository,
        super(CategoryPengeluaranInitial()) {
    on<AddCategoryPengeluaran>(_onAddCategoryPengeluaran);
    on<GetAllCategoriesPengeluaran>(_onGetAllCategoriesPengeluaran);
    on<UpdateCategoryPengeluaran>(_onUpdateCategoryPengeluaran);
    on<DeleteCategoryPengeluaran>(_onDeleteCategoryPengeluaran);
  }

  Future<void> _onAddCategoryPengeluaran(
    AddCategoryPengeluaran event,
    Emitter<CategoryPengeluaranState> emit,
  ) async {
    emit(CategoryPengeluaranLoading());
    try {
      final newCategory = await _repository.addCategoryPengeluaran(event.requestModel);
      emit(CategoryPengeluaranAdded(newCategory: newCategory));
      add(const GetAllCategoriesPengeluaran());
    } catch (e) {
      print('DEBUG BLOC ERROR: AddCategoryPengeluaran failed: $e'); 
      emit(CategoryPengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onGetAllCategoriesPengeluaran( // Nama metode ini dipanggil saat GetAllCategoriesPengeluaran di-dispatch
    GetAllCategoriesPengeluaran event,
    Emitter<CategoryPengeluaranState> emit,
  ) async {
    print('DEBUG BLOC: _onGetAllCategoriesPengeluaran event received.'); // Debugging
    emit(CategoryPengeluaranLoading());
    try {
      final categories = await _repository.getAllCategoriesPengeluaran();
      print('DEBUG BLOC: Fetched categories from repo. Count: ${categories.data.length}'); // Debugging
      if (categories.data.isNotEmpty) {
        print('DEBUG BLOC: First category from repo: ${categories.data.first.nama}'); // Debugging
      } else {
        print('DEBUG BLOC: Categories list from repository is empty.'); // Debugging
      }
      emit(CategoryPengeluaranLoaded(categories: categories));
    } catch (e) {
      print('DEBUG BLOC ERROR: Failed to fetch categories: $e'); // Debugging
      emit(CategoryPengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCategoryPengeluaran(
    UpdateCategoryPengeluaran event,
    Emitter<CategoryPengeluaranState> emit,
  ) async {
    emit(CategoryPengeluaranLoading());
    try {
      final updatedCategory = await _repository.updateCategoryPengeluaran(event.id, event.requestModel);
      emit(CategoryPengeluaranUpdated(updatedCategory: updatedCategory));
      add(const GetAllCategoriesPengeluaran()); // Refresh daftar setelah update
    } catch (e) {
      print('DEBUG BLOC ERROR: UpdateCategoryPengeluaran failed: $e'); // Debugging
      emit(CategoryPengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onDeleteCategoryPengeluaran(
    DeleteCategoryPengeluaran event,
    Emitter<CategoryPengeluaranState> emit,
  ) async {
    emit(CategoryPengeluaranLoading());
    try {
      final deleteResponse = await _repository.deleteCategoryPengeluaran(event.id);
      emit(CategoryPengeluaranDeleted(deleteResponse: deleteResponse));
      add(const GetAllCategoriesPengeluaran()); // Refresh daftar setelah delete
    } catch (e) {
      print('DEBUG BLOC ERROR: DeleteCategoryPengeluaran failed: $e'); // Debugging
      emit(CategoryPengeluaranError(message: e.toString()));
    }
  }
}