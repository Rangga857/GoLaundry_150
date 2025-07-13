import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/presentation/admin/dashboard/dashboard_screen.dart';
import 'package:laundry_app/presentation/admin/orderadmin/dashboard_admin_screen.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/keuangan_admin_screen.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/layanan_laundry_admin_screen.dart';
import 'package:google_fonts/google_fonts.dart'; 

class BottomNavBarAdmin extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBarAdmin({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 5, 
      ),
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.white, 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, 
        children: <Widget>[
          _buildNavItem(
            context,
            Icons.home,
            'Home',
            0,
            const DashboardAdminScreen(),
          ),
          _buildNavItem(
            context,
            Icons.list_alt,
            'Orders',
            1,
            const OrderAdminScreen(),
          ),
          _buildNavItem(
            context,
            Icons.account_balance_wallet,
            'Finance',
            2,
            const KeuanganAdminScreen(),
          ),
          _buildNavItem(
            context,
            Icons.local_laundry_service,
            'Services',
            3,
            const LayananLaundryAdminScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, Widget screen) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.pushReplacement(screen);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavyBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(30), 
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.grey, 
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8), 
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}