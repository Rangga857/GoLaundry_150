import 'package:dartz/dartz.dart';
import 'package:laundry_app/service/service_http_client.dart'; 
import 'package:laundry_app/data/model/request/jenispewangi/jenis_pewangi_request_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/jenis_pewangi_response_model.dart'; 
import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/getbyid_jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/delete_jenis_pewangi_response_model.dart'; 

abstract class JenisPewangiRepository {

  Future<Either<String, JenisPewangiResponseModel>> addJenisPewangi(
      JenisPewangiRequestModel request);

  Future<Either<String, GetAllJenisPewangiResponseModel>> getAllJenisPewangiAdmin();
  Future<Either<String, GetAllJenisPewangiResponseModel>> getAllJenisPewangiPelanggan();
  Future<Either<String, GetByIdJenisPewangiResponseModel>> getJenisPewangiById(int id); 
  Future<Either<String, JenisPewangiResponseModel>> updateJenisPewangi(
      int id, JenisPewangiRequestModel request);
  Future<Either<String, DeleteJenisPewangiResponseModel>> deleteJenisPewangi(int id); 
}

class JenisPewangiRepositoryImpl implements JenisPewangiRepository {
  final ServiceHttpClient httpClient;

  JenisPewangiRepositoryImpl({required this.httpClient});

  @override
  Future<Either<String, JenisPewangiResponseModel>> addJenisPewangi(
      JenisPewangiRequestModel request) async {
    try {
      final response = await httpClient.post(
        'admin/jenispewangi', 
        body: request.toJson(),
        includeAuth: true,
      );

      final responseModel = JenisPewangiResponseModel.fromRawJson(response.body);

      if (response.statusCode == 201) { 
        return Right(responseModel);
      } else {
        return Left(responseModel.message ?? 'Gagal menambah jenis pewangi: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambah jenis pewangi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetAllJenisPewangiResponseModel>> getAllJenisPewangiAdmin() async {
    try {
      final response = await httpClient.get(
        'admin/jenispewangi', 
        includeAuth: true,
      );

      final responseModel = GetAllJenisPewangiResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan daftar jenis pewangi untuk admin: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetAllJenisPewangiResponseModel>> getAllJenisPewangiPelanggan() async {
    try {
      final response = await httpClient.get(
        'pelanggan/jenispewangi', 
        includeAuth: true,
      );

      final responseModel = GetAllJenisPewangiResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan daftar jenis pewangi untuk pelanggan: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetByIdJenisPewangiResponseModel>> getJenisPewangiById(int id) async { 
    try {
      final response = await httpClient.get(
        'pelanggan/jenispewangi/$id', 
        includeAuth: true, 
      );

      final responseModel = GetByIdJenisPewangiResponseModel.fromRawJson(response.body); 

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Jenis pewangi dengan ID $id tidak ditemukan.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan jenis pewangi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, JenisPewangiResponseModel>> updateJenisPewangi(
      int id, JenisPewangiRequestModel request) async {
    try {
      final response = await httpClient.put(
        'admin/jenispewangi/$id',
        body: request.toJson(),
        includeAuth: true,
      );

      final responseModel = JenisPewangiResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) { 
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Jenis pewangi dengan ID $id tidak ditemukan untuk diperbarui.');
      } else {
        return Left(responseModel.message ?? 'Gagal memperbarui jenis pewangi: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat memperbarui jenis pewangi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, DeleteJenisPewangiResponseModel>> deleteJenisPewangi(int id) async { 
    try {
      final response = await httpClient.delete(
        'admin/jenispewangi/$id', 
        includeAuth: true,
      );

      if (response.statusCode == 204) { 
        return Right(DeleteJenisPewangiResponseModel(
          message: 'Jenis pewangi berhasil dihapus',
          statusCode: 204,
          data: null,
        ));
      } else {
        final responseModel = DeleteJenisPewangiResponseModel.fromRawJson(response.body);
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menghapus jenis pewangi: ${e.toString()}');
    }
  }
}
