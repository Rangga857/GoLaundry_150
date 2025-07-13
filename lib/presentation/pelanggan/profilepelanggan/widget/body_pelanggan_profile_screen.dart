import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';

import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/widget/pelanggan_profile_input.dart';

class BodyPelangganProfileScreen extends StatefulWidget {
  const BodyPelangganProfileScreen({super.key});

  @override
  State<BodyPelangganProfileScreen> createState() => _BodyPelangganProfileScreenState();
}

class _BodyPelangganProfileScreenState extends State<BodyPelangganProfileScreen> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePelangganBloc, ProfilePelangganState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (state is ProfilePelangganError) {
          _showSnackBar('Error: ${state.message}');
        } else if (state is ProfilePelangganUpdateError) {
          _showSnackBar('Update Error: ${state.message}');
        } else if (state is ProfilePelangganUpdated) {
          _showSnackBar('Profile updated successfully!');
          context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
        }
      },
      builder: (context, state) {
        if (state is ProfilePelangganLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
        } else if (state is ProfilePelangganLoaded) {
          final profile = state.profile.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  profile?.name ?? 'N/A',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavyBlue,
                  ),
                ),
                const SpaceHeight(10),
                Text(
                  profile?.phoneNumber ?? 'N/A',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.black87,
                  ),
                ),
                const SpaceHeight(30),
                CustomButton(
                  text: 'Edit Profil',
                  onPressed: () {
                    context.push(
                      ProfileInputScreen(
                        initialName: profile?.name,
                        initialPhoneNumber: profile?.phoneNumber,
                        initialProfilePictureUrl: profile?.profilePicture,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is ProfilePelangganError || state is ProfilePelangganInitial) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state is ProfilePelangganError
                        ? state.message
                        : 'Profil tidak ditemukan. Harap tambahkan profil Anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16, color: AppColors.black87),
                  ),
                  const SpaceHeight(20),
                  CustomButton(
                    text: 'Tambahkan Profil',
                    onPressed: () {
                      context.push(const ProfileInputScreen());
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}