import 'dart:convert';
import 'package:laundry_app/data/model/request/confirmationpayments/confirmation_payment_request_model.dart';
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

abstract class ConfirmationPaymentsRepository {
  Future<Map<String, dynamic>> createConfirmationPayment(
      ConfirmationPaymentRequestModel requestModel);
  Future<GetAllConfirmationPaymentResponseModel>
      getAllConfirmationPaymentsForAdmin();
  Future<GetAllConfirmationPaymentResponseModel>
      getConfirmationPaymentByPelanggan();
  Future<Map<String, dynamic>> getConfirmationPaymentByOrderIdForAdmin(int orderId);
  Future<Map<String, dynamic>> getConfirmationPaymentByOrderIdForPelanggan(int orderId);
}

class ConfirmationPaymentsRepositoryImpl
    implements ConfirmationPaymentsRepository {
  final ServiceHttpClient httpClient;

  ConfirmationPaymentsRepositoryImpl({required this.httpClient});

  @override
  Future<Map<String, dynamic>> createConfirmationPayment(
      ConfirmationPaymentRequestModel requestModel) async {
    try {
      final response = await httpClient.post(
        'admin/confirmationpayments', 
        body: requestModel.toJson(),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Confirmation payment created successfully'
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Failed to create confirmation payment'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  @override
  Future<GetAllConfirmationPaymentResponseModel>
      getAllConfirmationPaymentsForAdmin() async {
    try {
      final response = await httpClient.get(
          'admin/confirmationpayments'); 
      if (response.statusCode == 200) {
        return GetAllConfirmationPaymentResponseModel.fromRawJson(response.body);
      } else if (response.statusCode == 403) {
        return GetAllConfirmationPaymentResponseModel(
          message: 'Akses ditolak. Hanya admin yang dapat melihat semua konfirmasi pembayaran.',
          statusCode: 403,
          data: [],
        );
      } else {
        final errorBody = jsonDecode(response.body);
        return GetAllConfirmationPaymentResponseModel(
          message: errorBody['message'] ?? 'Failed to get all confirmation payments for admin',
          statusCode: response.statusCode,
          data: [],
        );
      }
    } catch (e) {
      return GetAllConfirmationPaymentResponseModel(
        message: 'An unexpected error occurred: $e',
        statusCode: 500,
        data: [],
      );
    }
  }

  @override
  Future<GetAllConfirmationPaymentResponseModel>
      getConfirmationPaymentByPelanggan() async {
    try {
      final response = await httpClient.get(
          'pelanggan/confirmationpayments');
      if (response.statusCode == 200) {
        return GetAllConfirmationPaymentResponseModel.fromRawJson(response.body);
      } else if (response.statusCode == 404) {
        return GetAllConfirmationPaymentResponseModel(
          message: 'Konfirmasi pembayaran tidak ditemukan untuk pelanggan ini.',
          statusCode: 404,
          data: [],
        );
      } else {
        final errorBody = jsonDecode(response.body);
        return GetAllConfirmationPaymentResponseModel(
          message: errorBody['message'] ?? 'Failed to get confirmation payments by customer',
          statusCode: response.statusCode,
          data: [],
        );
      }
    } catch (e) {
      return GetAllConfirmationPaymentResponseModel(
        message: 'An unexpected error occurred: $e',
        statusCode: 500,
        data: [],
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getConfirmationPaymentByOrderIdForAdmin(int orderId) async {
    try {
      final response = await httpClient.get('admin/confirmationpayments/$orderId'); 
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['data'] != null) {
          final Datum confirmationData = Datum.fromJson(responseBody['data']);
          return {'success': true, 'data': confirmationData};
        } else {
          return {'success': false, 'message': 'Data konfirmasi pembayaran tidak ditemukan di respons.'};
        }
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Konfirmasi pembayaran untuk Order ID $orderId tidak ditemukan.'};
      } else if (response.statusCode == 403) {
        return {'success': false, 'message': 'Akses ditolak. Hanya admin yang dapat melihat konfirmasi pembayaran.'};
      }
      else {
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Failed to get confirmation payment by order ID'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  @override
  Future<Map<String, dynamic>> getConfirmationPaymentByOrderIdForPelanggan(int orderId) async {
    try {
      final response = await httpClient.get('pelanggan/confirmationpayments/$orderId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['data'] != null) {
          final Datum confirmationData = Datum.fromJson(responseBody['data']);
          return {'success': true, 'data': confirmationData};
        } else {
          return {'success': false, 'message': 'Data konfirmasi pembayaran tidak ditemukan di respons.'};
        }
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Konfirmasi pembayaran untuk Order ID $orderId tidak ditemukan.'};
      } else if (response.statusCode == 403) {
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['error'] ?? 'Akses ditolak. Anda tidak memiliki izin.'};
      } else {
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Failed to get confirmation payment by order ID for customer'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }
}