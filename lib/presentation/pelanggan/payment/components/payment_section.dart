import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart'; 

class PaymentSection extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const PaymentSection({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.black87, 
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600, 
                color: valueColor ?? AppColors.darkNavyBlue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}