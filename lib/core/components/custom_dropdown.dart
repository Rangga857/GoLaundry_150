import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/colors.dart';

typedef ItemBuilder<T> = Widget Function(T item, bool isSelected, VoidCallback onTap);

class CustomSelectionCardDropdown<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T?>? validator;
  final String? hintText;
  final String? selectedDisplayText; 
  final ItemBuilder<T> itemBuilder;
  final String dialogTitle;

  const CustomSelectionCardDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.selectedDisplayText,
    required this.itemBuilder,
    required this.dialogTitle,
  });

  @override
  State<CustomSelectionCardDropdown<T>> createState() => _CustomSelectionCardDropdownState<T>();
}

class _CustomSelectionCardDropdownState<T> extends State<CustomSelectionCardDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.black87,
          ),
        ),
        const SpaceHeight(8.0),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: widget.selectedDisplayText ?? ''),
          onTap: () async {
            final T? selectedItem = await showDialog<T>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Text(
                    widget.dialogTitle,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryBlueDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return widget.itemBuilder(
                          item,
                          item == widget.value,
                          () {
                            Navigator.of(dialogContext).pop(item); 
                          },
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); 
                      },
                      style: TextButton.styleFrom(foregroundColor: AppColors.grey),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                );
              },
            );

            if (selectedItem != null) {
              widget.onChanged(selectedItem);
            }
          },
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(widget.value);
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(color: AppColors.grey),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          style: GoogleFonts.poppins(color: AppColors.black87), 
        ),
      ],
    );
  }
}