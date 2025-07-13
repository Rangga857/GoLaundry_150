import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';
import 'package:laundry_app/data/model/response/servicelaundry/getbyid_service_laundry_response_model.dart';
import 'package:laundry_app/data/model/response/servicelaundry/service_laundry_response_model.dart';
import 'package:laundry_app/data/model/response/servicelaundry/delete_service_laundry_response_model.dart';

abstract class AdminServiceLaundryState {}

class AdminServiceLaundryInitial extends AdminServiceLaundryState {}

class AdminServiceLaundryLoading extends AdminServiceLaundryState {}

class AdminServiceLaundryAllLoaded extends AdminServiceLaundryState {
  final GetAllServiceLaundryResponseModel serviceLaundryList;

  AdminServiceLaundryAllLoaded(this.serviceLaundryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminServiceLaundryAllLoaded &&
        other.serviceLaundryList == serviceLaundryList;
  }

  @override
  int get hashCode => serviceLaundryList.hashCode;
}

class AdminServiceLaundryByIdLoaded extends AdminServiceLaundryState {
  final GetByIdServiceLaundryResponseModel serviceLaundry;

  AdminServiceLaundryByIdLoaded(this.serviceLaundry);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminServiceLaundryByIdLoaded &&
        other.serviceLaundry == serviceLaundry;
  }

  @override
  int get hashCode => serviceLaundry.hashCode;
}

class ServiceLaundryAdded extends AdminServiceLaundryState {
  final ServiceLaundryResponseModel response;

  ServiceLaundryAdded(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLaundryAdded && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class ServiceLaundryUpdated extends AdminServiceLaundryState {
  final ServiceLaundryResponseModel response;

  ServiceLaundryUpdated(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLaundryUpdated && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class ServiceLaundryDeleted extends AdminServiceLaundryState {
  final DeleteServiceLaundryResponseModel response;

  ServiceLaundryDeleted(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLaundryDeleted && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}

class AdminServiceLaundryError extends AdminServiceLaundryState {
  final String message;

  AdminServiceLaundryError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminServiceLaundryError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}