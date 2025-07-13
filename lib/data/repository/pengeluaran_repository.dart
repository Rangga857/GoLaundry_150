import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laundry_app/data/model/request/pengeluaran/pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/request/pengeluaran/put_pengeluaran_request_model.dart'; 
import 'package:laundry_app/data/model/response/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/get_single_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/pengeluaran_response_model.dart'; 
import 'package:laundry_app/data/model/response/pengeluaran/put_pengeluaran_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart'; 

class PengeluaranRepository {
  final ServiceHttpClient _httpClient;

  PengeluaranRepository(this._httpClient);

  Future<PengeluaranResponseModel> addPengeluaran(PengeluaranRequestModel requestModel) async {
    try {
      final response = await _httpClient.post(
        'admin/pengeluaran',
        body: requestModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add pengeluaran: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding pengeluaran: $e');
    }
  }

  Future<GetAllPengeluaranResponseModel> getAllPengeluaran() async {
    try {
      final response = await _httpClient.get('admin/pengeluaran');

      if (response.statusCode == 200) {
        return GetAllPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get all pengeluaran: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting all pengeluaran: $e');
    }
  }

  Future<GetSinglePengeluaranResponseModel> getPengeluaranById(int id) async {
    try {
      final response = await _httpClient.get('admin/pengeluaran/$id');

      if (response.statusCode == 200) {
        return GetSinglePengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get single pengeluaran: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting single pengeluaran: $e');
    }
  }

  Future<PutPengeluaranResponseModel> updatePengeluaran(int id, PutPengeluaranRequestModel requestModel) async {
    try {
      final response = await _httpClient.put(
        'admin/pengeluaran/$id',
        body: requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        return PutPengeluaranResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update pengeluaran: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating pengeluaran: $e');
    }
  }

  Future<http.Response> deletePengeluaran(int id) async {
    try {
      final response = await _httpClient.delete('admin/pengeluaran/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        throw Exception('Failed to delete pengeluaran: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting pengeluaran: $e');
    }
  }
}