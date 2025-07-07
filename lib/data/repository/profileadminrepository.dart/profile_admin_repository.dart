import 'package:dartz/dartz.dart';
import 'package:laundry_app/data/model/request/admin/profile_admin_request.dart';
import 'package:laundry_app/data/model/response/admin/profile_admin_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

abstract class ProfileAdminRepository {
  Future<Either<String, ProfileAdminResponseModel>> addProfileAdmin(
      ProfileAdminRequestModel request);
  Future<Either<String, ProfileAdminResponseModel>> getProfileAdmin();
  Future<Either<String, ProfileAdminResponseModel>> updateProfileAdmin(
      ProfileAdminRequestModel request);
}

class ProfileAdminRepositoryImpl implements ProfileAdminRepository {
  final ServiceHttpClient httpClient;

  ProfileAdminRepositoryImpl({required this.httpClient});

  @override
  Future<Either<String, ProfileAdminResponseModel>> addProfileAdmin(
      ProfileAdminRequestModel request) async {
    try {
      final response = await httpClient.post(
        'admin/profile',
        body: request.toJson(),
        includeAuth: true, 
      );

      final responseModel = ProfileAdminResponseModel.fromRawJson(response.body);

      if (response.statusCode == 201) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message ?? 'Gagal menambahkan profil admin: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambahkan profil admin: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ProfileAdminResponseModel>> getProfileAdmin() async {
    try {
      final response = await httpClient.get(
        'admin/profile',
        includeAuth: true,
      );

      final responseModel = ProfileAdminResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message ?? 'Gagal mendapatkan profil admin: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan profil admin: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ProfileAdminResponseModel>> updateProfileAdmin(
      ProfileAdminRequestModel request) async {
    try {
      final response = await httpClient.put(
        'admin/profile', 
        body: request.toJson(),
        includeAuth: true, 
      );

      final responseModel = ProfileAdminResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message ?? 'Gagal memperbarui profil admin: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat memperbarui profil admin: ${e.toString()}');
    }
  }
}
