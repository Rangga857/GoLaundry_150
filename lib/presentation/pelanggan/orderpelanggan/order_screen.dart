import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_pelanggan.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/order_body.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: const OrderBody(),
      bottomNavigationBar: const BottomNavBarPelanggan(selectedIndex: 1),
    );
  }
}