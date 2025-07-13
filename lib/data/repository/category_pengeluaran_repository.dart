import 'dart:convert';
import 'package:laundry_app/data/model/request/categorypengeluaran/category_pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/request/categorypengeluaran/edit_cateogory_pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/Delete_category_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/category_pengeluaran_response_model.dart'; 
import 'package:laundry_app/data/model/response/categorypengeluaran/get_all_cateogry_pengeluaran_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart'; 

class CategoryPengeluaranRepository {
  final ServiceHttpClient _httpClient;

  CategoryPengeluaranRepository(this._httpClient);

  Future<CategoryPengeluaranResponseModel> addCategoryPengeluaran(
      CateogryPengeluaranRequestModel requestModel) async {
    try {
      final response = await _httpClient.post(
        'admin/pengeluarancategory',
        body: requestModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CategoryPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add category: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding category: $e');
    }
  }

  Future<GetAllCategoryPengeluaranResponseModel> getAllCategoriesPengeluaran() async {
    try {
      final response = await _httpClient.get('admin/pengeluarancategory');

      if (response.statusCode == 200) {
        return GetAllCategoryPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get all categories: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting all categories: $e');
    }
  }

  Future<EditCateogryPengeluaranResponseModel> updateCategoryPengeluaran(
      int id, CateogryPengeluaranRequestModel requestModel) async {
    try {
      final response = await _httpClient.put(
        'admin/pengeluarancategory/$id',
        body: requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        return EditCateogryPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update category: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<DeleteCategoryPengeluaranResponseModel> deleteCategoryPengeluaran(int id) async {
    try {
      final response = await _httpClient.delete('admin/pengeluarancategory/$id');

      if (response.statusCode == 200) {
        return DeleteCategoryPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to delete category: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}