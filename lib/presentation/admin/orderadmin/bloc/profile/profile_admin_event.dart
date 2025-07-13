import 'package:laundry_app/data/model/request/admin/profile_admin_request.dart';

sealed class ProfileAdminEvent {}

class AddProfileAdminEvent extends ProfileAdminEvent {
  final ProfileAdminRequestModel requestModel;

  AddProfileAdminEvent({required this.requestModel});
}

class GetProfileAdminEvent extends ProfileAdminEvent {}

class UpdateProfileAdminEvent extends ProfileAdminEvent {
  final ProfileAdminRequestModel requestModel;

  UpdateProfileAdminEvent({required this.requestModel});
}
