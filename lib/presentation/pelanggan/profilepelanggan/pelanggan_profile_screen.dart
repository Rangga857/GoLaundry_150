import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/repository/authrepository.dart';
import 'package:laundry_app/service/service_http_client.dart';
import 'package:laundry_app/presentation/auth/login_screen.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_pelanggan.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/widget/body_pelanggan_profile_screen.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';

class PelangganProfileScreen extends StatefulWidget {
  const PelangganProfileScreen({super.key});

  @override
  State<PelangganProfileScreen> createState() => _PelangganProfileScreenState();
}

class _PelangganProfileScreenState extends State<PelangganProfileScreen> {
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(ServiceHttpClient());
    context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
  }

  void _showSnackBar(String message, {Color backgroundColor = AppColors.primaryBlue}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: AppColors.white),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final result = await _authRepository.logout();
    result.fold(
      (errorMessage) {
        _showSnackBar('Logout gagal: $errorMessage', backgroundColor: AppColors.red);
      },
      (successMessage) {
        _showSnackBar(successMessage, backgroundColor: AppColors.primaryBlue);
        context.pushAndRemoveUntil(const LoginScreen(), (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue, 
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/gambar3.jpg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.darkNavyBlue,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: AppColors.white, size: 80),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.white, size: 28),
                  onPressed: _handleLogout,
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.45,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: const BodyPelangganProfileScreen(),
            ),
          ),
          BlocBuilder<ProfilePelangganBloc, ProfilePelangganState>(
            builder: (context, state) {
              if (state is ProfilePelangganLoaded) {
                final profile = state.profile.data;
                final double avatarRadius = 60;
                final double avatarTopPosition = (screenHeight * 0.45) - avatarRadius;
                final double avatarLeftPosition = (screenWidth / 2) - avatarRadius;

                return Positioned(
                  top: avatarTopPosition,
                  left: avatarLeftPosition,
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: AppColors.primaryBlue,
                    child: CircleAvatar(
                      radius: avatarRadius - 4,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: profile?.profilePicture != null
                          ? NetworkImage(profile!.profilePicture!)
                          : null,
                      child: profile?.profilePicture == null
                          ? const Icon(Icons.person, size: 60, color: AppColors.grey)
                          : null,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarPelanggan(selectedIndex: 3),
    );
  }
}