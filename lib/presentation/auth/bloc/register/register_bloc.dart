import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/authrepository.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_event.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await authRepository.register(event.requestModel);
    result.fold(
      (error) => emit(RegisterFailure(error: error)),
      (response) => emit(RegisterSuccess(message: response.message ?? 'Registration successful!')),
    );
  }
}