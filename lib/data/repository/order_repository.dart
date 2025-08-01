import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:laundry_app/data/model/request/orderlaundry/order_laundries_request_model.dart';
import 'package:laundry_app/data/model/request/orderlaundry/put_order_laundies_request_model.dart';
import 'package:laundry_app/service/service_http_client.dart';
import 'package:laundry_app/data/model/response/orderlaundry/order_laundries_response_model.dart' as add_order_res;
import 'package:laundry_app/data/model/response/orderlaundry/put_order_laundries_response_model.dart' as put_order_res;
import 'package:laundry_app/data/model/response/orderlaundry/my_order_laundries_response_model.dart' as my_order_res;
import 'package:laundry_app/data/model/response/orderlaundry/get_all_orders_response_model.dart' as get_all_res;
import 'package:laundry_app/data/model/response/orderlaundry/get_by_id_order_response_model.dart' as get_by_id_res;


abstract class OrderRepository {
  Future<Either<String, add_order_res.OrderLaundriesResponseModel>> addOrder(OrderLaundriesRequestModel request);
  Future<Either<String, get_all_res.GetAllOrdersResponseModel>> getAllOrdersAdmin({
    String? searchQuery,
    String? statusFilter,
  });
  Future<Either<String, my_order_res.MyOrderLaundriesResponseModel>> getOrdersByProfile();
  Future<Either<String, get_by_id_res.GetByIdOrderResponseModel>> getSpecificOrderForAdmin(int id);
  Future<Either<String, put_order_res.PutOrdesLaundriesResponseModel>> updateOrderStatus(int id, PutOrdesLaundriesRequestModel request);
}

class OrderRepositoryImpl implements OrderRepository {
  final ServiceHttpClient httpClient;

  OrderRepositoryImpl({required this.httpClient});

  @override
  Future<Either<String, add_order_res.OrderLaundriesResponseModel>> addOrder(OrderLaundriesRequestModel request) async {
    try {
      final response = await httpClient.post(
        'pelanggan/orders',
        body: request.toJson(),
        includeAuth: true,
      );

      add_order_res.OrderLaundriesResponseModel? responseModel;
      try {
        responseModel = add_order_res.OrderLaundriesResponseModel.fromRawJson(response.body);
      } catch (e) {

        return Left('Gagal memproses respons server: ${e.toString()}');
      }

      if (response.statusCode == 201) {
        return Right(responseModel);
      } else {
        String errorMessage = 'Gagal membuat pesanan. Status: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson != null && errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          } else if (errorJson != null && errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          }
        } catch (e) { /* ignore */ }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat membuat pesanan: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, get_all_res.GetAllOrdersResponseModel>> getAllOrdersAdmin({
    String? searchQuery,
    String? statusFilter,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['searchQuery'] = searchQuery;
      }
      if (statusFilter != null && statusFilter.isNotEmpty) {
        queryParams['statusFilter'] = statusFilter;
      }
      final response = await httpClient.get(
        'admin/orders',
        queryParameters: queryParams,
        includeAuth: true,
      );
      final responseModel = get_all_res.GetAllOrdersResponseModel.fromRawJson(response.body);
      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        String errorMessage = 'Gagal mendapatkan semua pesanan. Status: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson != null && errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          } else if (errorJson != null && errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          }
        } catch (e) { /* ignore */ }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan semua pesanan: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, my_order_res.MyOrderLaundriesResponseModel>> getOrdersByProfile() async {
    try {
      final response = await httpClient.get(
        'pelanggan/myorders', 
        includeAuth: true,
      );

      final responseModel = my_order_res.MyOrderLaundriesResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else {
        String errorMessage = 'Gagal mendapatkan pesanan berdasarkan profil. Status: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson != null && errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          } else if (errorJson != null && errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          }
        } catch (e) { /* ignore */ }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan pesanan berdasarkan profil: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, get_by_id_res.GetByIdOrderResponseModel>> getSpecificOrderForAdmin(int id) async {
    try {
      final response = await httpClient.get(
        'admin/orders/$id', 
        includeAuth: true,
      );

      get_by_id_res.GetByIdOrderResponseModel? responseModel;
      try {
        responseModel = get_by_id_res.GetByIdOrderResponseModel.fromRawJson(response.body);
      } catch (e) {
        return Left('Gagal memproses respons server: ${e.toString()}');
      }

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Pesanan tidak ditemukan.');
      } else {
        String errorMessage = 'Gagal mendapatkan pesanan spesifik. Status: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson != null && errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          } else if (errorJson != null && errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          }
        } catch (e) { /* ignore */ }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan pesanan spesifik: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, put_order_res.PutOrdesLaundriesResponseModel>> updateOrderStatus(int id, PutOrdesLaundriesRequestModel request) async {
    try {
      final response = await httpClient.put(
        'admin/orders/$id/status', 
        body: request.toJson(),
        includeAuth: true,
      );

      put_order_res.PutOrdesLaundriesResponseModel? responseModel;
      try {
        responseModel = put_order_res.PutOrdesLaundriesResponseModel.fromRawJson(response.body);
      } catch (e) {
        return Left('Gagal memproses respons server: ${e.toString()}');
      }

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 404) {
        return Left('Pesanan tidak ditemukan untuk diperbarui.');
      } else {
        String errorMessage = 'Gagal memperbarui status pesanan. Status: ${response.statusCode}';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson != null && errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          } else if (errorJson != null && errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          }
        } catch (e) { /* ignore */ }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat memperbarui status pesanan: ${e.toString()}');
    }
  }
}
