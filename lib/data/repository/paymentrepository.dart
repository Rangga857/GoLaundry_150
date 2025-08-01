import 'package:dartz/dartz.dart';
import 'package:laundry_app/data/model/request/pembayaran/confirm_pembayaran_request_model.dart';
import 'package:laundry_app/data/model/request/pembayaran/pembayaran_request_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/confirm_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_all_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_by_id_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_my_pembayaran_response_model.dart';
import 'package:laundry_app/data/model/response/pembayaran/pembayaran_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

abstract class PembayaranRepository {
  Future<Either<String, PaymentResponseModel>> addPayment(PaymentRequestModel request);
  Future<Either<String, ConfirmPembayaranResponseModel>> confirmPayment(
      int id, ConfirmPembayaranRequestModel request);
  Future<Either<String, GetMyPembayaranResponseModel>> getPaymentsByPelanggan();
  Future<Either<String, GetAllPembayaranResponseModel>> getAllPayments();
  Future<Either<String, GetByIdPembayaranResponseModel>> getPaymentById(int id);
}


class PembayaranRepositoryImpl implements PembayaranRepository {
  final ServiceHttpClient httpClient;

  PembayaranRepositoryImpl({required this.httpClient});

  @override
  Future<Either<String, PaymentResponseModel>> addPayment(PaymentRequestModel request) async {
    try {
      final response = await httpClient.postMultipart(
        'pelanggan/pembayaran', 
        fields: request.toFields(),
        file: request.buktiPembayaran, 
        fileFieldName: 'bukti_pembayaran', 
        includeAuth: true,
      );

      final responseModel = PaymentResponseModel.fromRawJson(response.body);

      if (response.statusCode == 201) {
        return Right(responseModel);
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambah pembayaran: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ConfirmPembayaranResponseModel>> confirmPayment(
      int id, ConfirmPembayaranRequestModel request) async {
    try {
      final response = await httpClient.put(
        'admin/pembayaran/$id/confirm',
        body: request.toJson(),
        includeAuth: true,
      );

      final responseModel = ConfirmPembayaranResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 403) {
        return Left('Akses ditolak. Hanya admin yang dapat mengonfirmasi pembayaran.');
      } else if (response.statusCode == 404) {
        return Left('Pembayaran dengan ID $id tidak ditemukan.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mengonfirmasi pembayaran: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetMyPembayaranResponseModel>> getPaymentsByPelanggan() async {
    try {
      final response = await httpClient.get(
        'pelanggan/mypembayaran', 
        includeAuth: true,
      );

      final responseModel = GetMyPembayaranResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 404 && responseModel.data!.isEmpty) {
        return Left('Tidak ada catatan pembayaran ditemukan untuk pelanggan ini.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan catatan pembayaran pelanggan: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GetAllPembayaranResponseModel>> getAllPayments() async {
    try {
      final response = await httpClient.get(
        'admin/pembayaran', 
        includeAuth: true,
      );

      final responseModel = GetAllPembayaranResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 403) {
        return Left('Akses ditolak. Hanya admin yang dapat melihat semua pembayaran.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan semua catatan pembayaran: ${e.toString()}');
    }
  }
  
  @override
  Future<Either<String, GetByIdPembayaranResponseModel>> getPaymentById(int id) async {
    try {
      final response = await httpClient.get(
        'admin/pembayaran/$id', 
        includeAuth: true,
      );

      final responseModel = GetByIdPembayaranResponseModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return Right(responseModel);
      } else if (response.statusCode == 403) {
        return Left('Akses ditolak. Anda tidak memiliki izin untuk melihat pembayaran ini.');
      } else if (response.statusCode == 404) {
        return Left('Pembayaran dengan ID $id tidak ditemukan.');
      } else {
        return Left(responseModel.message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mendapatkan detail pembayaran: ${e.toString()}');
    }
  }
}
