import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 150 + statusBarHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkNavyBlue, 
        borderRadius: BorderRadius.vertical(),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kDefaultPadding + statusBarHeight,
          left: kDefaultPadding * 1.5,
          right: kDefaultPadding * 1.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row( 
              children: [
                Text(
                  'Pesanan Anda',
                  style: GoogleFonts.poppins( 
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 12), 
                Image.asset(
                  'assets/images/ls_van.png', 
                  height: 80, 
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Lihat status dan detail pesanan laundry Anda.',
              style: GoogleFonts.poppins( 
                color: AppColors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}