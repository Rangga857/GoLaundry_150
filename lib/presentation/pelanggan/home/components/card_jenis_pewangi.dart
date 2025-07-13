import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'dart:math';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/core/constants/colors.dart';

class CardJenisPewangi extends StatelessWidget {
  final String name;
  final String description;
  final int id;

  const CardJenisPewangi({
    super.key,
    required this.name,
    required this.description,
    required this.id,
  });

  static const List<IconData> _availableIcons = [
    Icons.auto_awesome,
    Icons.local_florist,
    Icons.spa,
    Icons.bubble_chart,
    Icons.clean_hands,
    Icons.favorite,
    Icons.star_half,
    Icons.brightness_5,
  ];

  IconData _getIconForId(int id) {
    final random = Random(id);
    return _availableIcons[random.nextInt(_availableIcons.length)];
  }

  @override
  Widget build(BuildContext context) {
    final selectedIcon = _getIconForId(id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              selectedIcon,
              size: 40,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: kDefaultPadding / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpaceHeight(4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                  // Removed maxLines and overflow to allow text to wrap
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}