import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laundry_app/data/model/request/auth/login_request_model.dart';
import 'package:laundry_app/data/model/request/auth/register_request_model.dart';
import 'package:laundry_app/data/model/response/auth/login_response_model.dart';
import 'package:laundry_app/data/model/response/auth/register_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';


class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, LoginResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        body: requestModel.toMap(),
        includeAuth: false,
      );

      final jsonResponse = json.decode(response.body);
      final loginResponse = LoginResponseModel.fromMap(jsonResponse);

      if (response.statusCode == 200 && loginResponse.data != null) {
        if (loginResponse.data!.token != null) {
          await secureStorage.write(
            key: "authToken",
            value: loginResponse.data!.token!,
          );
          await secureStorage.write(
            key: "userRole",
            value: loginResponse.data!.role!, 
          );
          print("Token and Role saved: ${loginResponse.data!.token}, ${loginResponse.data!.role}");
        } else {
          return Left('Login response data is incomplete (token missing).');
        }
        return Right(loginResponse);
      } else {
        String errorMessage = loginResponse.message ?? 'An unknown error occurred.';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((key, value) {
            errorMessage += "\n${(value as List).join(', ')}";
          });
        }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Failed to login: $e');
    }
  }

  Future<Either<String, RegisterResponseModel>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        body: requestModel.toMap(),
        includeAuth: false,
      );

      final jsonResponse = json.decode(response.body);
      final registerResponse = RegisterResponseModel.fromMap(jsonResponse);

      if (response.statusCode == 201) { 
        return Right(registerResponse); 
      } else {
        String errorMessage = registerResponse.message ?? 'Registration failed.';
        if (jsonResponse['errors'] != null) {
          jsonResponse['errors'].forEach((key, value) {
            errorMessage += "\n${(value as List).join(', ')}"; 
          });
        }
        return Left(errorMessage); 
      }
    } catch (e) {
      return Left('An error occurred while registering: $e');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final response = await _serviceHttpClient.post(
        "logout",
        includeAuth: true, 
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        await secureStorage.delete(key: 'authToken');
        await secureStorage.delete(key: 'userRole');
        return Right(jsonResponse['message'] ?? 'Logout successful.');
      } else {
        return Left(jsonResponse['message'] ?? 'Logout failed.');
      }
    } catch (e) {
      return Left('Failed to logout: $e');
    }
  }
}
