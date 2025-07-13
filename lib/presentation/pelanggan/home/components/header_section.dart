import 'package:flutter/material.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/constants.dart'; 

class HeaderSection extends StatelessWidget {
  final String userName;
  final String userLocation;
  final VoidCallback onNotificationTap;

  const HeaderSection({
    super.key,
    required this.userName,
    required this.userLocation,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(40), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi $userName!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SpaceHeight(4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.white, size: 18),
                      const SizedBox(width: 4), 
                      Text(
                        userLocation,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.white.withOpacity(0.2),
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: AppColors.white),
                  onPressed: onNotificationTap,
                ),
              ),
            ],
          ),
          const SpaceHeight(kDefaultPadding), 
        ],
      ),
    );
  }
}
