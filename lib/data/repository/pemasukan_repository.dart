import 'dart:convert';
import 'package:laundry_app/data/model/request/pemasukan/pemasukan_request_model.dart';
import 'package:laundry_app/data/model/request/pemasukan/put_pemasukan_request_model.dart';
import 'package:laundry_app/data/model/response/pemasukan/delete_pemasukan_response_model.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_manual_pemasukan_response_model.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_total_pemasukan_response_model.dart';
import 'package:laundry_app/data/model/response/pemasukan/pemasukan_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

class PemasukanRepository {
  final ServiceHttpClient _httpClient;

  PemasukanRepository(this._httpClient);

  Future<PemasukanResponseModel> addPemasukan(PemasukanRequestModel request) async {
    try {
      final response = await _httpClient.post(
        'admin/pemasukan',
        body: request.toJson(),
      );

      if (response.statusCode == 201) { 
        return PemasukanResponseModel.fromRawJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to add pemasukan: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to add pemasukan: $e');
    }
  }

  Future<GetManualPemasukanResponseModel> getAllPemasukan() async {
    try {
      final response = await _httpClient.get(
        'admin/pemasukan',
      );

      if (response.statusCode == 200) { 
        return GetManualPemasukanResponseModel.fromRawJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to get all pemasukan: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to get all pemasukan: $e');
    }
  }

  Future<PemasukanResponseModel> updatePemasukan(int id, PutPemasukanRequestModel request) async {
    try {
      final response = await _httpClient.put(
        'admin/pemasukan/$id',
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        return PemasukanResponseModel.fromRawJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to update pemasukan $id: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to update pemasukan: $e');
    }
  }

  Future<DeletePemasukanResponseModel> deletePemasukan(int id) async {
    try {
      final response = await _httpClient.delete(
        'admin/pemasukan/$id', 
      );

      if (response.statusCode == 200) { 
        return DeletePemasukanResponseModel.fromRawJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to delete pemasukan $id: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to delete pemasukan: $e');
    }
  }

  Future<GetTotalPemasukanResponseModel> getTotalPemasukan() async {
    try {
      final response = await _httpClient.get(
        'admin/pemasukan/total', 
      );

      if (response.statusCode == 200) { // OK
        return GetTotalPemasukanResponseModel.fromRawJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to get total pemasukan: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to get total pemasukan: $e');
    }
  }
  Future<List<int>> exportPemasukanSummaryPdf() async {
    try {
      final response = await _httpClient.get(
        'admin/laporanharian/pdf', 
      );

      if (response.statusCode == 200) { 
        return response.bodyBytes;
      } else {
        throw Exception('Failed to download PDF report: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to download PDF report: $e');
    }
  }
}