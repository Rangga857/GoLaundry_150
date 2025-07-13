import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/custom_text_field.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/request/admin/profile_admin_request.dart';
import 'package:laundry_app/data/model/response/admin/profile_admin_response_model.dart';
import 'package:laundry_app/presentation/admin/dashboard/dashboard_screen.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_state.dart';
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

  Future<void> _openMapsPage() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (context) => const MapsPage()),
    );
    if (result != null && result.containsKey('address')) {
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
        title: Text(
          widget.initialProfileData == null ? 'Lengkapi Profil Admin' : 'Edit Profil Admin',
          style: GoogleFonts.poppins( // Applied Poppins font
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileAdminBloc, ProfileAdminState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (state is ProfileAdminAdded) {
                _showSnackBar('Profil admin berhasil ditambahkan!');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardAdminScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (state is ProfileAdminAddError) {
                _showSnackBar('Gagal menambahkan profil admin: ${state.message}');
              } else if (state is ProfileAdminUpdated) {
                _showSnackBar('Profil admin berhasil diperbarui!');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardAdminScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (state is ProfileAdminUpdateError) {
                _showSnackBar('Gagal memperbarui profil admin: ${state.message}');
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
                    style: GoogleFonts.poppins( // Applied Poppins font
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SpaceHeight(24),
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
                                  final requestModel = ProfileAdminRequestModel(
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    latitude: _latitude,
                                    longitude: _longitude,
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