import 'package:laundry_app/data/model/request/pelanggan/profile_pelanggan_request_model.dart';
import 'package:laundry_app/data/model/response/pelanggan/profile_pelanggan_response_model.dart';
import 'package:laundry_app/data/model/response/pelanggan/get_profile_pelanggan_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

abstract class ProfilePelangganRepository {
  Future<ProfilePelangganResponseModel> addProfilePelanggan(ProfilePelangganRequestModel request);
  Future<GetProfilePelangganResponseModel> getProfilePelanggan();
  Future<ProfilePelangganResponseModel> updateProfilePelanggan(ProfilePelangganRequestModel request);
}

class ProfilePelangganRepositoryImpl implements ProfilePelangganRepository {
  final ServiceHttpClient httpClient;

  ProfilePelangganRepositoryImpl({required this.httpClient});

  @override
  Future<ProfilePelangganResponseModel> addProfilePelanggan(ProfilePelangganRequestModel request) async {
    try {
      final Map<String, String> fields = {
        'name': request.name!,
        'phone_number': request.phoneNumber!,
      };
      if (request.profilePicture == null) {
        throw Exception('Profile picture is required for adding a new profile.');
      }

      final response = await httpClient.postMultipart(
        'pelanggan/profile',
        fields: fields,
        file: request.profilePicture, 
        fileFieldName: 'photo', 
        includeAuth: true, 
      );

      return ProfilePelangganResponseModel.fromRawJson(response.body);
    } catch (e) {
      return ProfilePelangganResponseModel(
        message: 'Failed to add profile: $e',
        statusCode: 500,
        data: null,
      );
    }
  }

  @override
  Future<GetProfilePelangganResponseModel> getProfilePelanggan() async {
    try {
      final response = await httpClient.get(
        'pelanggan/profile',
        includeAuth: true,
      );
      return GetProfilePelangganResponseModel.fromRawJson(response.body);
    } catch (e) {
      return GetProfilePelangganResponseModel(
        message: 'Failed to get profile: $e',
        statusCode: 500,
        data: null,
      );
    }
  }

  @override
  Future<ProfilePelangganResponseModel> updateProfilePelanggan(ProfilePelangganRequestModel request) async {
    try {
      final Map<String, String> fields = {};
      if (request.name != null) {
        fields['name'] = request.name!;
      }
      if (request.phoneNumber != null) {
        fields['phone_number'] = request.phoneNumber!;
      }

      final response = await httpClient.putMultipart(
        'pelanggan/profile',
        fields: fields,
        file: request.profilePicture, 
        fileFieldName: 'photo', 
        includeAuth: true, 
      );

      return ProfilePelangganResponseModel.fromRawJson(response.body);
    } catch (e) {
      return ProfilePelangganResponseModel(
        message: 'Failed to update profile: $e',
        statusCode: 500,
        data: null,
      );
    }
  }
}
