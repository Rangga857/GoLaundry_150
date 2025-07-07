import 'package:laundry_app/data/model/response/auth/login_response_model.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResponseModel responseModel;

  LoginSuccess({required this.responseModel});
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
