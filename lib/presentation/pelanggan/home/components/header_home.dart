import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/confirmation_notification_screen.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_state.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_state.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key});

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  int _unreadNotificationsCount = 0;
  String _userName = 'Pelanggan';

  @override
  void initState() {
    super.initState();
    context.read<ConfirmationPaymentPelangganBloc>().add(GetConfirmationPaymentsByPelanggan());
    context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
  }

  void _resetNotifications() {
    setState(() {
      _unreadNotificationsCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 250 + statusBarHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkNavyBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: kDefaultPadding * 1.5 + statusBarHeight,
              left: kDefaultPadding * 1.5,
              right: kDefaultPadding * 1.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProfilePelangganBloc, ProfilePelangganState>(
                  builder: (context, state) {
                    if (state is ProfilePelangganLoaded) {
                      _userName = state.profile.data?.name ?? 'Pelanggan';
                    } else if (state is ProfilePelangganError) {
                      debugPrint('Error loading profile: ${state.message}');
                      _userName = 'Pelanggan';
                    }
                    return Column( // Tambahkan Column di sini
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello', 
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 38,
                          ),
                        ),
                        Text(
                          _userName,
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat datang di aplikasi Laundry Anda.',
                  style: GoogleFonts.lora( 
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: kDefaultPadding * 1.5 + statusBarHeight,
            right: kDefaultPadding * 1.5,
            child: Row(
              children: [
                // Ikon Notifikasi
                BlocConsumer<ConfirmationPaymentPelangganBloc,
                    ConfirmationPaymentPelangganState>(
                  listener: (context, state) {
                    if (state is ConfirmationPaymentPelangganLoaded) {
                      setState(() {
                        _unreadNotificationsCount = state.confirmationPayments.data.length;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications, color: AppColors.white, size: 28),
                          onPressed: () async {
                            await context.push(const ConfirmationNotificationScreen());
                            _resetNotifications();
                          },
                        ),
                        if (_unreadNotificationsCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$_unreadNotificationsCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}