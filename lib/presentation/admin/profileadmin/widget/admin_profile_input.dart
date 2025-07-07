import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/custom_text_field.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/model/request/admin/profile_admin_request.dart';
import 'package:laundry_app/data/model/response/admin/profile_admin_response_model.dart'; 
import 'package:laundry_app/presentation/admin/admin_profile_screen.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_event.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_state.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_bloc.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_event.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_state.dart';
import 'package:laundry_app/presentation/maps/maps_page.dart';

class AdminProfileInputScreen extends StatefulWidget {
  final Data? initialProfileData;

  const AdminProfileInputScreen({super.key, this.initialProfileData});

  @override
  State<AdminProfileInputScreen> createState() => _AdminProfileInputScreenState();
}

class _AdminProfileInputScreenState extends State<AdminProfileInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.initialProfileData != null) {
      _nameController.text = widget.initialProfileData!.name ?? '';
      _addressController.text = widget.initialProfileData!.address ?? '';
      _latitude = widget.initialProfileData!.latitude;
      _longitude = widget.initialProfileData!.longitude;
    }
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
  Future<void> _openMapsPage() async {
    final result = await context.push(const MapsPage()); 
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _addressController.text = result['address'] ?? '';
        _latitude = result['latitude'];
        _longitude = result['longitude'];
      });
      _showSnackBar('Lokasi dipilih: ${_addressController.text}');
    } else {
      _showSnackBar('Pemilihan lokasi dibatalkan.');
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialProfileData == null ? 'Lengkapi Profil Admin' : 'Edit Profil Admin'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileAdminBloc, ProfileAdminState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              print('AdminProfileInputScreen ProfileAdminBloc Listener State: $state');

              if (state is ProfileAdminAdded) {
                _showSnackBar('Profil admin berhasil ditambahkan!');
                context.pushAndRemoveUntil(const AdminHomeScreen(), (route) => false);
              } else if (state is ProfileAdminAddError) {
                _showSnackBar('Gagal menambahkan profil admin: ${state.message}');
              } else if (state is ProfileAdminUpdated) {
                _showSnackBar('Profil admin berhasil diperbarui!');
                context.pushAndRemoveUntil(const AdminHomeScreen(), (route) => false);
              } else if (state is ProfileAdminUpdateError) {
                _showSnackBar('Gagal memperbarui profil admin: ${state.message}');
              }
            },
          ),
          BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              if (state is CameraReady && state.snackbarMessage != null) {
                _showSnackBar(state.snackbarMessage!);
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
                  Text(
                    widget.initialProfileData == null ? 'Data Laundry Anda' : 'Perbarui Data Laundry',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SpaceHeight(30),
                  // Bagian Foto Profil
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
                                  ? const Icon(Icons.add, size: 40, color: AppColors.grey)
                                  : const CircularProgressIndicator(color: AppColors.primaryBlue, strokeWidth: 3))
                              : null,
                        ),
                      );
                    },
                  ),
                  const SpaceHeight(20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nama Laundry',
                    prefixIcon: const Icon(Icons.store),
                    validatorMessage: 'Nama laundry tidak boleh kosong',
                  ),
                  const SpaceHeight(20),
                  CustomTextField(
                    controller: _addressController,
                    label: 'Alamat Laundry',
                    prefixIcon: const Icon(Icons.location_on),
                    readOnly: true,
                    validatorMessage: 'Alamat tidak boleh kosong',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map, color: AppColors.primaryBlue),
                      onPressed: _openMapsPage,
                    ),
                  ),
                  const SpaceHeight(20),
                  Text(
                    'Latitude: ${_latitude?.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 14, color: AppColors.black87),
                  ),
                  Text(
                    'Longitude: ${_longitude?.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 14, color: AppColors.black87),
                  ),
                  const SpaceHeight(30),
                  BlocBuilder<ProfileAdminBloc, ProfileAdminState>(
                    builder: (context, state) {
                      final bool isLoading = state is ProfileAdminLoading;
                      return CustomButton(
                        text: widget.initialProfileData == null ? 'Simpan Profil' : 'Perbarui Profil',
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_latitude == null || _longitude == null) {
                                    _showSnackBar('Harap pilih lokasi laundry di peta.');
                                    return;
                                  }
                                  if (_imageFile == null) {
                                    _showSnackBar('Harap pilih gambar profil Anda.');
                                    return; 
                                  }
                                  String? base64Image;
                                  List<int> imageBytes = await _imageFile!.readAsBytes();
                                  base64Image = base64Encode(imageBytes);

                                  final requestModel = ProfileAdminRequestModel(
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    latitude: _latitude,
                                    longitude: _longitude,
                                    profilePicture: base64Image,
                                  );

                                  if (widget.initialProfileData == null) {
                                    context.read<ProfileAdminBloc>().add(
                                          AddProfileAdminEvent(requestModel: requestModel),
                                        );
                                  } else {
                                    context.read<ProfileAdminBloc>().add(
                                          UpdateProfileAdminEvent(requestModel: requestModel),
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
