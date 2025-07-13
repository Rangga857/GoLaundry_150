import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/constants.dart'; 

class SectionTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const SectionTitleRow({
    super.key,
    required this.title,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
          TextButton(
            onPressed: onSeeAllTap,
            child: const Text(
              'See all',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}
