import 'package:laundry_app/data/model/response/pelanggan/profile_pelanggan_response_model.dart';
import 'package:laundry_app/data/model/response/pelanggan/get_profile_pelanggan_response_model.dart'; 

sealed class ProfilePelangganState {}

final class ProfilePelangganInitial extends ProfilePelangganState {}

final class ProfilePelangganLoading extends ProfilePelangganState {}

final class ProfilePelangganLoaded extends ProfilePelangganState {
  final GetProfilePelangganResponseModel profile; 

  ProfilePelangganLoaded({required this.profile});
}

final class ProfilePelangganError extends ProfilePelangganState {
  final String message;

  ProfilePelangganError({required this.message});
}


final class ProfilePelangganAdded extends ProfilePelangganState {
  final ProfilePelangganResponseModel profile; 

  ProfilePelangganAdded({required this.profile});
}

final class ProfilePelangganAddError extends ProfilePelangganState {
  final String message;

  ProfilePelangganAddError({required this.message});
}

final class ProfilePelangganUpdated extends ProfilePelangganState {
  final ProfilePelangganResponseModel profile;

  ProfilePelangganUpdated({required this.profile});
}

final class ProfilePelangganUpdateError extends ProfilePelangganState {
  final String message;

  ProfilePelangganUpdateError({required this.message});
}
