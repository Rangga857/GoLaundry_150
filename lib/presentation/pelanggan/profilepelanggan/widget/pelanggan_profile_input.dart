import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/custom_text_field.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/model/request/pelanggan/profile_pelanggan_request_model.dart';
import 'package:laundry_app/presentation/pelanggan/home/home_screen.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_bloc.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_event.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_state.dart';
import 'package:logger/logger.dart';

class ProfileInputScreen extends StatefulWidget {
  final String? initialName;
  final String? initialPhoneNumber;
  final String? initialProfilePictureUrl;

  const ProfileInputScreen({
    super.key,
    this.initialName,
    this.initialPhoneNumber,
    this.initialProfilePictureUrl,
  });

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  String? _currentProfilePictureUrl;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _phoneNumberController.text = widget.initialPhoneNumber ?? '';
    _currentProfilePictureUrl = widget.initialProfilePictureUrl;
    _logger.i('ProfileInputScreen initialized with:');
    _logger.i('   Initial Name: ${widget.initialName}');
    _logger.i('   Initial Phone: ${widget.initialPhoneNumber}');
    _logger.i('   Initial Picture URL: ${widget.initialProfilePictureUrl}');
  }

  Future<void> _showImageSourceSelection() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<CameraBloc>().add(PickImageFromGallery());
                  _logger.d('Picking image from gallery...');
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<CameraBloc>().add(OpenCameraAndCapture(context));
                  _logger.d('Opening camera to capture photo...');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Edit Profil' : 'Lengkapi Profil Anda'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfilePelangganBloc, ProfilePelangganState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (state is ProfilePelangganAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil ditambahkan!')),
                );
                _logger.i('Profile added successfully. Navigating to Home.');
                context.pushAndRemoveUntil(const HomeScreen(), (route) => false);
              } else if (state is ProfilePelangganAddError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan profil: ${state.message}')),
                );
                _logger.e('Failed to add profile: ${state.message}');
              } else if (state is ProfilePelangganUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui!')),
                );
                _logger.i('Profile updated successfully. Popping back.');
                context.pop(); // Go back to the profile view
              } else if (state is ProfilePelangganUpdateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal memperbarui profil: ${state.message}')),
                );
                _logger.e('Failed to update profile: ${state.message}');
              }
            },
          ),
          BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              if (state is CameraReady && state.snackbarMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.snackbarMessage!)),
                );
                _logger.d('CameraBloc snackbar message: ${state.snackbarMessage}');
                context.read<CameraBloc>().add(ClearSnackbar());
              }
              if (state is CameraReady && state.imageFile != null && _imageFile?.path != state.imageFile!.path) {
                setState(() {
                  _imageFile = state.imageFile;
                  _currentProfilePictureUrl = null;
                  _logger.i('New image file selected: ${_imageFile?.path}');
                });
              }
            },
          ),
        ],
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.initialName != null ? 'Edit Profil Anda' : 'Lengkapi Profil Anda',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SpaceHeight(30),
                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, cameraState) {
                      final bool isCameraReady = cameraState is CameraReady;
                      return GestureDetector(
                        onTap: isCameraReady ? _showImageSourceSelection : null,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.lightGrey,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (_currentProfilePictureUrl != null
                                    ? NetworkImage(_currentProfilePictureUrl!)
                                    : null) as ImageProvider<Object>?,
                          child: _imageFile == null && _currentProfilePictureUrl == null
                              ? (isCameraReady
                                    ? const Icon(
                                        Icons.add,
                                        size: 40,
                                        color: AppColors.grey,
                                      )
                                    : const CircularProgressIndicator(
                                        color: AppColors.primaryBlue,
                                        strokeWidth: 3,
                                      ))
                              : null,
                        ),
                      );
                    },
                  ),
                  const SpaceHeight(20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nama Lengkap',
                    prefixIcon: const Icon(Icons.person),
                    validatorMessage: 'Nama lengkap tidak boleh kosong',
                  ),
                  const SpaceHeight(20),
                  CustomTextField(
                    controller: _phoneNumberController,
                    label: 'Nomor Telepon',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    validatorMessage: 'Nomor telepon tidak boleh kosong',
                    customValidator: (value) {
                      if (value != null && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Nomor telepon hanya boleh berisi angka';
                      }
                      return null;
                    },
                  ),
                  const SpaceHeight(30),
                  BlocBuilder<ProfilePelangganBloc, ProfilePelangganState>(
                    builder: (context, state) {
                      final bool isLoading = state is ProfilePelangganLoading;
                      return CustomButton(
                        text: 'Simpan Profil',
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final requestModel = ProfilePelangganRequestModel(
                                    name: _nameController.text,
                                    phoneNumber: _phoneNumberController.text,
                                    profilePicture: _imageFile,
                                  );
                                  _logger.d('Sending request model: ${requestModel.toJson()}');

                                  if (widget.initialName != null) {
                                    _logger.i('Dispatching UpdateProfilePelangganEvent');
                                    context.read<ProfilePelangganBloc>().add(
                                          UpdateProfilePelangganEvent(requestModel: requestModel),
                                        );
                                  } else {
                                    _logger.i('Dispatching AddProfilePelangganEvent');
                                    context.read<ProfilePelangganBloc>().add(
                                          AddProfilePelangganEvent(requestModel: requestModel),
                                        );
                                  }
                                }
                              },
                      );
                    },
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
