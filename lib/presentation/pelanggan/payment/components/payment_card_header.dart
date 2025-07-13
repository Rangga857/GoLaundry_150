import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart'; 

class PaymentCardHeader extends StatelessWidget {
  final String status;
  final String metodePembayaran;
  final DateTime createdAt;

  const PaymentCardHeader({
    super.key,
    required this.status,
    required this.metodePembayaran,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'confirmed' ? AppColors.green : AppColors.red;
    IconData statusIcon = status == 'confirmed' ? Icons.check_circle : Icons.hourglass_empty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 20, 
              ),
              const SizedBox(width: 8),
              Text(
                status.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metodePembayaran,
                style: GoogleFonts.poppins(
                  fontSize: 15, 
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavyBlue, 
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), 
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(createdAt.toLocal()),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}