import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart'; 

void showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), 
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavyBlue, 
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.grey, 
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryBlue, 
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, 
              ),
            ),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, 
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      );
    },
  );
}