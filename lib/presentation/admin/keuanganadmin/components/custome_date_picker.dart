import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';

class CustomDatePickerField extends StatefulWidget {
  final String labelText;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final String? Function(String?)? validator;

  const CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.initialDate,
    required this.onDateSelected,
    this.validator,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late TextEditingController _dateController;
  late DateTime _currentSelectedDate;

  @override
  void initState() {
    super.initState();
    _currentSelectedDate = widget.initialDate;
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_currentSelectedDate),
    );
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _currentSelectedDate = widget.initialDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(_currentSelectedDate);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.darkNavyBlue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.darkNavyBlue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            textTheme: TextTheme(
              titleLarge: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.white,
              ),
              bodyLarge: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
              bodyMedium: GoogleFonts.poppins(color: AppColors.grey),
              bodySmall: GoogleFonts.poppins(color: AppColors.grey),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentSelectedDate) {
      setState(() {
        _currentSelectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_currentSelectedDate);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: 'Pilih tanggal',
        labelStyle: GoogleFonts.poppins(color: AppColors.grey),
        hintStyle: GoogleFonts.poppins(color: AppColors.grey.withOpacity(0.6)),
        fillColor: AppColors.lightGrey.withOpacity(0.5),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: AppColors.primaryBlue),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      validator: widget.validator,
      style: GoogleFonts.poppins(color: AppColors.darkNavyBlue), 
    );
  }
}