import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';

abstract class ServiceLaundryState {}

class ServiceLaundryInitial extends ServiceLaundryState {}

class ServiceLaundryLoading extends ServiceLaundryState {}

class ServiceLaundryAllLoaded extends ServiceLaundryState {
  final GetAllServiceLaundryResponseModel serviceLaundryList;

  ServiceLaundryAllLoaded(this.serviceLaundryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLaundryAllLoaded &&
        other.serviceLaundryList == serviceLaundryList;
  }

  @override
  int get hashCode => serviceLaundryList.hashCode;
}

class ServiceLaundryError extends ServiceLaundryState {
  final String message;

  ServiceLaundryError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLaundryError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}