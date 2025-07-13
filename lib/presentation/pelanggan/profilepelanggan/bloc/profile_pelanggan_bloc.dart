import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/profile_pelanggan_repository.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';




class ProfilePelangganBloc extends Bloc<ProfilePelangganEvent, ProfilePelangganState> {
  final ProfilePelangganRepository profilePelangganRepository; 
  ProfilePelangganBloc({required this.profilePelangganRepository})
      : super(ProfilePelangganInitial()) {
    on<AddProfilePelangganEvent>(_addProfilePelanggan); 
    on<GetProfilePelangganEvent>(_getProfilePelanggan); 
    on<UpdateProfilePelangganEvent>(_updateProfilePelanggan); 
  }

  Future<void> _addProfilePelanggan(
    AddProfilePelangganEvent event,
    Emitter<ProfilePelangganState> emit,
  ) async {
    emit(ProfilePelangganLoading());
    try {
      final response = await profilePelangganRepository.addProfilePelanggan(
        event.requestModel,
      );

      if (response.statusCode == 201) { 
        emit(ProfilePelangganAdded(profile: response));
      } else {
        emit(ProfilePelangganAddError(message: response.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(ProfilePelangganAddError(message: e.toString()));
    }
  }

  Future<void> _getProfilePelanggan(
    GetProfilePelangganEvent event,
    Emitter<ProfilePelangganState> emit,
  ) async {
    emit(ProfilePelangganLoading());
    try {
      final response = await profilePelangganRepository.getProfilePelanggan();

      if (response.statusCode == 200) { 
        emit(ProfilePelangganLoaded(profile: response));
      } else {
        emit(ProfilePelangganError(message: response.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(ProfilePelangganError(message: e.toString()));
    }
  }

  Future<void> _updateProfilePelanggan(
    UpdateProfilePelangganEvent event,
    Emitter<ProfilePelangganState> emit,
  ) async {
    emit(ProfilePelangganLoading());
    try {
      final response = await profilePelangganRepository.updateProfilePelanggan(
        event.requestModel,
      );
      if (response.statusCode == 200) { 
        emit(ProfilePelangganUpdated(profile: response));
      } else {
        emit(ProfilePelangganUpdateError(message: response.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(ProfilePelangganUpdateError(message: e.toString()));
    }
  }
}
