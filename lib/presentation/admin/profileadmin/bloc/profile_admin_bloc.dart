import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/profileadminrepository.dart/profile_admin_repository.dart';

import 'profile_admin_event.dart'; 
import 'profile_admin_state.dart'; 

class ProfileAdminBloc extends Bloc<ProfileAdminEvent, ProfileAdminState> {
  final ProfileAdminRepository profileAdminRepository;

  ProfileAdminBloc({required this.profileAdminRepository})
      : super(ProfileAdminInitial()) {
    on<AddProfileAdminEvent>(_addProfileAdmin);
    on<GetProfileAdminEvent>(_getProfileAdmin);
    on<UpdateProfileAdminEvent>(_updateProfileAdmin);
  }

  Future<void> _addProfileAdmin(
    AddProfileAdminEvent event,
    Emitter<ProfileAdminState> emit,
  ) async {
    emit(ProfileAdminLoading());
    final result = await profileAdminRepository.addProfileAdmin(event.requestModel);

    result.fold(
      (error) => emit(ProfileAdminAddError(message: error)),
      (response) {
        // Asumsi 201 Created untuk penambahan sukses
        if (response.statusCode == 201) {
          emit(ProfileAdminAdded(profile: response));
        } else {
          emit(ProfileAdminAddError(message: response.message ?? 'Unknown error occurred'));
        }
      },
    );
  }

  Future<void> _getProfileAdmin(
    GetProfileAdminEvent event,
    Emitter<ProfileAdminState> emit,
  ) async {
    emit(ProfileAdminLoading());
    final result = await profileAdminRepository.getProfileAdmin();

    result.fold(
      (error) => emit(ProfileAdminError(message: error)),
      (response) {
        // Asumsi 200 OK untuk pengambilan sukses
        if (response.statusCode == 200) {
          emit(ProfileAdminLoaded(profile: response));
        } else {
          emit(ProfileAdminError(message: response.message ?? 'Unknown error occurred'));
        }
      },
    );
  }

  Future<void> _updateProfileAdmin(
    UpdateProfileAdminEvent event,
    Emitter<ProfileAdminState> emit,
  ) async {
    emit(ProfileAdminLoading());
    final result = await profileAdminRepository.updateProfileAdmin(event.requestModel);

    result.fold(
      (error) => emit(ProfileAdminUpdateError(message: error)),
      (response) {
        // Asumsi 200 OK untuk pembaruan sukses
        if (response.statusCode == 200) {
          emit(ProfileAdminUpdated(profile: response));
        } else {
          emit(ProfileAdminUpdateError(message: response.message ?? 'Unknown error occurred'));
        }
      },
    );
  }
}
