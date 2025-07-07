import 'package:laundry_app/data/model/response/admin/profile_admin_response_model.dart'; 
sealed class ProfileAdminState {}

final class ProfileAdminInitial extends ProfileAdminState {}

final class ProfileAdminLoading extends ProfileAdminState {}

final class ProfileAdminLoaded extends ProfileAdminState {
  final ProfileAdminResponseModel profile; 

  ProfileAdminLoaded({required this.profile});
}

final class ProfileAdminError extends ProfileAdminState {
  final String message;

  ProfileAdminError({required this.message});
}

final class ProfileAdminAdded extends ProfileAdminState {
  final ProfileAdminResponseModel profile; 

  ProfileAdminAdded({required this.profile});
}

final class ProfileAdminAddError extends ProfileAdminState {
  final String message;

  ProfileAdminAddError({required this.message});
}

final class ProfileAdminUpdated extends ProfileAdminState {
  final ProfileAdminResponseModel profile;

  ProfileAdminUpdated({required this.profile});
}

final class ProfileAdminUpdateError extends ProfileAdminState {
  final String message;

  ProfileAdminUpdateError({required this.message});
}
