import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/model/request/auth/login_request_model.dart';
import 'package:laundry_app/presentation/admin/admin_profile_screen.dart';
import 'package:laundry_app/presentation/admin/profileadmin/widget/admin_profile_input.dart';
import 'package:laundry_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:laundry_app/presentation/auth/bloc/login/login_event.dart';
import 'package:laundry_app/presentation/auth/bloc/login/login_state.dart';
import 'package:laundry_app/presentation/auth/register_screen.dart';
import 'package:laundry_app/core/components/custom_text_field.dart';
import 'package:laundry_app/presentation/pelanggan/home/home_screen.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_event.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_state.dart'; 
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/widget/pelanggan_profile_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful! Checking role...')),
                );

                final userRole = state.responseModel.data?.role;

                if (userRole == 'admin') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengarahkan ke pengecekan profil admin.')),
                  );
                  context.read<ProfileAdminBloc>().add(GetProfileAdminEvent());
                } else if (userRole == 'pelanggan') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengarahkan ke pengecekan profil pelanggan.')),
                  );
                  context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Role pengguna tidak dikenal. Silakan hubungi admin.')),
                  );
                }
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login Failed: ${state.error}')),
                );
              }
            },
          ),
          BlocListener<ProfilePelangganBloc, ProfilePelangganState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              print('ProfilePelangganBloc Listener State: $state');

              if (state is ProfilePelangganLoaded) {
                if (state.profile.data != null &&
                    state.profile.data!.name != null &&
                    state.profile.data!.name!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil ditemukan! Mengarahkan ke Home.')),
                  );
                  context.pushAndRemoveUntil(const HomeScreen(), (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil tidak ditemukan atau tidak lengkap. Harap lengkapi profil Anda.')),
                  );
                  context.pushReplacement(const ProfileInputScreen());
                }
              } else if (state is ProfilePelangganError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error memuat profil: ${state.message}. Harap lengkapi profil Anda.')),
                );
                context.pushReplacement(const ProfileInputScreen());
              }
            },
          ),
          BlocListener<ProfileAdminBloc, ProfileAdminState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              print('ProfileAdminBloc Listener State: $state');

              if (state is ProfileAdminLoaded) {
                if (state.profile.data != null &&
                    state.profile.data!.name != null &&
                    state.profile.data!.name!.isNotEmpty &&
                    state.profile.data!.address != null &&
                    state.profile.data!.address!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil admin ditemukan! Mengarahkan ke Admin Dashboard.')),
                  );
                  context.pushAndRemoveUntil(const AdminHomeScreen(), (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil admin tidak lengkap. Harap lengkapi profil Anda.')),
                  );
                  context.pushReplacement(AdminProfileInputScreen(initialProfileData: state.profile.data)); // Kirim data yang ada
                }
              } else if (state is ProfileAdminError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error memuat profil admin: ${state.message}. Harap lengkapi profil Anda.')),
                );
                context.pushReplacement(const AdminProfileInputScreen());
              }
            },
          ),
        ],
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 180,
                    width: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_laundry_service,
                        size: 180,
                        color: AppColors.primaryBlue,
                      );
                    },
                  ),
                  const SpaceHeight(30),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SpaceHeight(50),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validatorMessage: 'Please enter your email',
                    customValidator: (value) {
                      if (value != null && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SpaceHeight(25),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    validatorMessage: 'Please enter your password',
                    customValidator: (value) {
                      if (value != null && value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SpaceHeight(40),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      final bool isLoading = state is LoginLoading;
                      return CustomButton(
                        text: 'Login',
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final requestModel = LoginRequestModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  context.read<LoginBloc>().add(
                                        LoginRequested(requestModel: requestModel),
                                      );
                                }
                              },
                      );
                    },
                  ),
                  const SpaceHeight(25),
                  TextButton(
                    onPressed: () {
                      context.push(const RegisterScreen());
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
