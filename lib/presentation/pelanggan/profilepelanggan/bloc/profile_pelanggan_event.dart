
import 'package:laundry_app/data/model/request/pelanggan/profile_pelanggan_request_model.dart';

sealed class ProfilePelangganEvent {}

class AddProfilePelangganEvent extends ProfilePelangganEvent {
  final ProfilePelangganRequestModel requestModel;

  AddProfilePelangganEvent({required this.requestModel});
}

class GetProfilePelangganEvent extends ProfilePelangganEvent {}

class UpdateProfilePelangganEvent extends ProfilePelangganEvent {
  final ProfilePelangganRequestModel requestModel;

  UpdateProfilePelangganEvent({required this.requestModel});
}