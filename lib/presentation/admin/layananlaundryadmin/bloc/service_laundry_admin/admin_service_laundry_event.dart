import 'package:laundry_app/data/model/request/servicelaundry/service_laundry_request_model.dart';

abstract class AdminServiceLaundryEvent {}

class GetAdminServiceLaundryAllEvent extends AdminServiceLaundryEvent {}

class GetAdminServiceLaundryByIdEvent extends AdminServiceLaundryEvent {
  final int id;

  GetAdminServiceLaundryByIdEvent(this.id);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetAdminServiceLaundryByIdEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AddServiceLaundryEvent extends AdminServiceLaundryEvent {
  final ServiceLaundryRequestModel request;

  AddServiceLaundryEvent({required this.request});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddServiceLaundryEvent && other.request == request;
  }

  @override
  int get hashCode => request.hashCode;
}

class UpdateServiceLaundryEvent extends AdminServiceLaundryEvent {
  final int id;
  final ServiceLaundryRequestModel request;

  UpdateServiceLaundryEvent({required this.id, required this.request});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateServiceLaundryEvent &&
        other.id == id &&
        other.request == request;
  }

  @override
  int get hashCode => id.hashCode ^ request.hashCode;
}

class DeleteServiceLaundryEvent extends AdminServiceLaundryEvent {
  final int id;

  DeleteServiceLaundryEvent(this.id);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteServiceLaundryEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}