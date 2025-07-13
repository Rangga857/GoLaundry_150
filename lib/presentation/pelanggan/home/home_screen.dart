import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_pelanggan.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/body_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: BodyHome(),
      bottomNavigationBar: BottomNavBarPelanggan(selectedIndex: 0),
    );
  }
}