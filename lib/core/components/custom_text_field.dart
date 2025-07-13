import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon; 
  final bool readOnly;
  final int maxLines;
  final String? validatorMessage;
  final FormFieldValidator<String>? customValidator;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool? isPassword; 
  final VoidCallback? onTapSuffixIcon; 
  final bool isSuffixIconVisible; 

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.validatorMessage,
    this.customValidator,
    this.onFieldSubmitted,
    this.onTap,
    this.isPassword, 
    this.onTapSuffixIcon, 
    this.isSuffixIconVisible = true, 
  });

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffixIcon = suffixIcon;
    if (isPassword == true && effectiveSuffixIcon == null) {
      effectiveSuffixIcon = GestureDetector(
        onTap: onTapSuffixIcon,
        child: Icon(
          obscureText && isSuffixIconVisible
              ? Icons.visibility
              : Icons.visibility_off,
          color: AppColors.grey,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (validatorMessage != null && (value == null || value.isEmpty)) {
              return validatorMessage;
            }
            if (customValidator != null) {
              return customValidator!(value);
            }
            return null;
          },
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.poppins(color: AppColors.grey),
            prefixIcon: prefixIcon,
            suffixIcon: effectiveSuffixIcon, 
            filled: true,
            fillColor: AppColors.primaryBlueLight.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }
}