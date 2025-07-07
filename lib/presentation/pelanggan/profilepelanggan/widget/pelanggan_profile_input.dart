import 'dart:io';
import 'dart:convert'; 

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

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<CameraBloc>().add(OpenCameraAndCapture(context));
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfilePelangganBloc, ProfilePelangganState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (state is ProfilePelangganAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil ditambahkan!')),
                );
                context.pushAndRemoveUntil(const HomeScreen(), (route) => false);
              } else if (state is ProfilePelangganAddError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan profil: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              if (state is CameraReady && state.snackbarMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.snackbarMessage!)),
                );
                context.read<CameraBloc>().add(ClearSnackbar());
              }
              if (state is CameraReady && state.imageFile != null && _imageFile?.path != state.imageFile!.path) {
                setState(() {
                  _imageFile = state.imageFile;
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
                  const Text(
                    'Lengkapi Profil Anda',
                    style: TextStyle(
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
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                          child: _imageFile == null
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
                                  String? base64Image;
                                  if (_imageFile != null) {
                                    List<int> imageBytes = await _imageFile!.readAsBytes();
                                    base64Image = base64Encode(imageBytes);
                                  }

                                  final requestModel = ProfilePelangganRequestModel(
                                    name: _nameController.text,
                                    phoneNumber: _phoneNumberController.text,
                                    profilePicture: base64Image,
                                  );
                                  context.read<ProfilePelangganBloc>().add(
                                        AddProfilePelangganEvent(requestModel: requestModel),
                                      );
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
