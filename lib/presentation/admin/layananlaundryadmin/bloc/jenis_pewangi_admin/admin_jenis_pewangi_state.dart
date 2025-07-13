import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/getbyid_jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/delete_jenis_pewangi_response_model.dart';

abstract class AdminJenisPewangiState {}

class AdminJenisPewangiInitial extends AdminJenisPewangiState {}

class AdminJenisPewangiLoading extends AdminJenisPewangiState {}

class AdminJenisPewangiAllLoaded extends AdminJenisPewangiState {
  final GetAllJenisPewangiResponseModel jenisPewangiList;

  AdminJenisPewangiAllLoaded(this.jenisPewangiList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminJenisPewangiAllLoaded &&
        other.jenisPewangiList == jenisPewangiList;
  }

  @override
  int get hashCode => jenisPewangiList.hashCode;
}

class AdminJenisPewangiByIdLoaded extends AdminJenisPewangiState {
  final GetByIdJenisPewangiResponseModel jenisPewangi;

  AdminJenisPewangiByIdLoaded(this.jenisPewangi);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminJenisPewangiByIdLoaded && other.jenisPewangi == jenisPewangi;
  }

  @override
  int get hashCode => jenisPewangi.hashCode;
}

class JenisPewangiAdded extends AdminJenisPewangiState {
  final JenisPewangiResponseModel response;

  JenisPewangiAdded(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JenisPewangiAdded && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class JenisPewangiUpdated extends AdminJenisPewangiState {
  final JenisPewangiResponseModel response;

  JenisPewangiUpdated(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JenisPewangiUpdated && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class JenisPewangiDeleted extends AdminJenisPewangiState {
  final DeleteJenisPewangiResponseModel response;

  JenisPewangiDeleted(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JenisPewangiDeleted && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class AdminJenisPewangiError extends AdminJenisPewangiState {
  final String message;

  AdminJenisPewangiError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminJenisPewangiError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}