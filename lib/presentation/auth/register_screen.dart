import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/request/auth/register_request_model.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_event.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_state.dart';
import 'package:laundry_app/presentation/auth/login_screen.dart'; 
import 'package:laundry_app/core/components/custom_text_field.dart';
import 'package:laundry_app/core/components/spaces_height.dart'; 
import 'package:laundry_app/core/extensions/build_context_ext.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); 
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pushReplacement(const LoginScreen()); 
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
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
                    height: 160, 
                    width: 160, 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_laundry_service,
                        size: 160,
                        color: AppColors.primaryBlue,
                      );
                    },
                  ),
                  const SpaceHeight(25), 

                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SpaceHeight(40), 
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
                  const SpaceHeight(20),
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
                  const SpaceHeight(20), 
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    validatorMessage: 'Please confirm your password',
                    customValidator: (value) {
                      if (value != null && value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SpaceHeight(30), 
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return const CircularProgressIndicator();
                      }
                      return CustomButton(
                        text: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final requestModel = RegisterRequestModel(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            context.read<RegisterBloc>().add(
                                  RegisterRequested(requestModel: requestModel),
                                );
                          }
                        },
                      );
                    },
                  ),
                  const SpaceHeight(20), 
                  TextButton(
                    onPressed: () {
                      context.pushReplacement(const LoginScreen());
                    },
                    child: const Text(
                      "Already have an account? Login here",
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
