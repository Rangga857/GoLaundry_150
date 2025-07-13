import 'package:flutter/material.dart';
import 'package:laundry_app/core/components/custom_buttons.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/presentation/auth/login_screen.dart'; 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200, 
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.0), 
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.1), 
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.2), 
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.5, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: context.deviceHeight * 0.28, 
              width: double.infinity, 
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Go',
                          style: TextStyle(color: AppColors.primaryBlue),
                        ),
                        TextSpan(
                          text: 'Laundry',
                          style: TextStyle(color: AppColors.customColor1),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(12.0),
                  const Text(
                    'The best application to find the nearest laundry from your location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SpaceHeight(25.0), 
                  CustomButton(
                    text: 'Get Started',
                    onPressed: () {
                      context.pushReplacement(const LoginScreen());
                    },
                    backgroundColor: AppColors.customColor2,
                    textColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
