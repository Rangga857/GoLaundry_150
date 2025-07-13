import 'dart:convert';
import 'package:laundry_app/data/model/request/comment/comment_request_model.dart';
import 'package:laundry_app/data/model/response/comment/get_single_comment_response_model.dart';
import 'package:laundry_app/data/model/response/comment/my_comment_response_model.dart';
import 'package:laundry_app/service/service_http_client.dart';

class CommentRepository {
  final ServiceHttpClient _httpClient;

  CommentRepository(this._httpClient);
  Future<CommentRequestModel> addComment(CommentRequestModel requestModel) async {
    final response = await _httpClient.post(
      'pelanggan/comments',
      body: requestModel.toJson(),
      includeAuth: true, 
    );

    if (response.statusCode == 201) {
      return CommentRequestModel.fromJson(json.decode(response.body)['data']);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception('${errorBody['message'] ?? 'Gagal menambahkan komentar'} (Status: ${response.statusCode})');
    }
  }

  Future<MyCommentResponseModel> getMyComments() async {
    final response = await _httpClient.get(
      'pelanggan/comments',
      includeAuth: true,
    );

    if (response.statusCode == 200) {
      return MyCommentResponseModel.fromRawJson(response.body);
    } else if (response.statusCode == 404) {
      return MyCommentResponseModel(
        message: json.decode(response.body)['message'] ?? 'Tidak ada komentar yang ditemukan untuk Anda.',
        statusCode: 404,
        data: [], 
      );
    }
    else {
      final errorBody = json.decode(response.body);
      throw Exception('${errorBody['message'] ?? 'Gagal mengambil komentar Anda'} (Status: ${response.statusCode})');
    }
  }

  Future<GetSingleCommentResponseModel> getCommentByOrderId(int orderId) async {
    final response = await _httpClient.get(
      'admin/comments/$orderId',
      includeAuth: true, 
    );

    if (response.statusCode == 200) {
      return GetSingleCommentResponseModel.fromRawJson(response.body);
    } else if (response.statusCode == 404) {
        final errorBody = json.decode(response.body);
        throw Exception('${errorBody['message'] ?? 'Komentar tidak ditemukan.'} (Status: ${response.statusCode})');
    } else {
      final errorBody = json.decode(response.body);
      throw Exception('${errorBody['message'] ?? 'Gagal mengambil komentar berdasarkan Order ID'} (Status: ${response.statusCode})');
    }
  }
}