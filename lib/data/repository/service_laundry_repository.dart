import 'package:dartz/dartz.dart';
import 'package:laundry_app/service/service_http_client.dart'; 

import 'package:laundry_app/data/model/request/servicelaundry/service_laundry_request_model.dart';

import 'package:laundry_app/data/model/response/servicelaundry/service_laundry_response_model.dart'; // Untuk Add/Update
import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart'; // Untuk GetAll
import 'package:laundry_app/data/model/response/servicelaundry/delete_service_laundry_response_model.dart'; // Untuk Delete
import 'package:laundry_app/data/model/response/servicelaundry/getbyid_service_laundry_response_model.dart'; // Untuk GetById


abstract class ServiceLaundryRepository {
  Future<Either<String, ServiceLaundryResponseModel>> addServiceLaundry(
      ServiceLaundryRequestModel request);
  Future<Either<String, GetAllServiceLaundryResponseModel>> getAllServiceLaundryAdmin();
  Future<Either<String, GetAllServiceLaundryResponseModel>> getAllServiceLaundryPelanggan();
  Future<Either<String, GetByIdServiceLaundryResponseModel>> getServiceLaundryById(int id);
  Future<Either<String, ServiceLaundryResponseModel>> updateServiceLaundry(
      int id, ServiceLaundryRequestModel request);
  Future<Either<String, DeleteServiceLaundryResponseModel>> deleteServiceLaundry(int id);
}

class ServiceLaundryRepositoryImpl implements ServiceLaundryRepository {
  final ServiceHttpClient httpClient;

  ServiceLaundryRepositoryImpl({required this.httpClient});

  @override
  Future<Either<String, ServiceLaundryResponseModel>> addServiceLaundry(
      ServiceLaundryRequestModel request) async {
    try {
      final response = await httpClient.post(
        'admin/servicelaundry',
        body: request.toJson(),
        includeAuth: true,
      );

      ServiceLaundryResponseModel? responseModel;
      try {
        responseModel = ServiceLaundryResponseModel.fromRawJson(response.body);
      } catch (e) {
        print('Error parsing ServiceLaundryResponseModel in addServiceLaundry: $e');
      }

      if (response.statusCode == 201) {
        return Right(responseModel ?? ServiceLaundryResponseModel(
          message: 'Service laundry berhasil ditambahkan',
          statusCode: 201,
          data: null, 
        ));
      } else {
        return Left(responseModel?.message ?? 'Gagal menambah layanan laundry. Status: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambah layanan laundry: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetAllServiceLaundryResponseModel>> getAllServiceLaundryAdmin() async {
    try {
      final response = await httpClient.get(
        'admin/servicelaundry',
        includeAuth: true,
      );

      final responseModel = GetAllServiceLaundryResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan daftar layanan laundry untuk admin: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetAllServiceLaundryResponseModel>> getAllServiceLaundryPelanggan() async {
    try {
      final response = await httpClient.get(
        'pelanggan/servicelaundry', 
        includeAuth: true, 
      );

      final responseModel = GetAllServiceLaundryResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan daftar layanan laundry untuk pelanggan: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetByIdServiceLaundryResponseModel>> getServiceLaundryById(int id) async {
    try {
      final response = await httpClient.get(
        'pelanggan/servicelaundry/$id', 
        includeAuth: true, 
      );

      final responseModel = GetByIdServiceLaundryResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Layanan laundry dengan ID $id tidak ditemukan.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan layanan laundry: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ServiceLaundryResponseModel>> updateServiceLaundry(
      int id, ServiceLaundryRequestModel request) async {
    try {
      final response = await httpClient.put(
        'admin/servicelaundry/$id', 
        body: request.toJson(),
        includeAuth: true,
      );

      ServiceLaundryResponseModel? responseModel;
      responseModel = ServiceLaundryResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Layanan laundry dengan ID $id tidak ditemukan untuk diperbarui.');
      } else {
        return Left(responseModel.message ?? 'Gagal memperbarui layanan laundry. Status: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat memperbarui layanan laundry: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, DeleteServiceLaundryResponseModel>> deleteServiceLaundry(int id) async {
    try {
      final response = await httpClient.delete(
        'admin/servicelaundry/$id',
        includeAuth: true,
      );
      DeleteServiceLaundryResponseModel? responseModel;
      responseModel = DeleteServiceLaundryResponseModel.fromRawJson(response.body);
      if (response.statusCode == 204) {
        return Right(DeleteServiceLaundryResponseModel(
          message: 'Layanan laundry berhasil dihapus',
          statusCode: 204,
          data: null, 
        ));
      }
      else if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseModel.statusCode == 200) {
          return Right(responseModel);
        } else {
          String errorMessage = responseModel.message;
          return Left(errorMessage);
        }
      }
      else {
        String errorMessage = responseModel.message;
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menghapus layanan laundry: ${e.toString()}');
    }
  }
}
