import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart'; 
import 'package:laundry_app/core/components/custom_text_form_field1.dart'; 
import 'package:laundry_app/data/model/request/confirmationpayments/confirmation_payment_request_model.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_event.dart';

class CreateConfirmationPaymentDialog extends StatefulWidget {
  final int orderId;

  const CreateConfirmationPaymentDialog({super.key, required this.orderId});

  @override
  State<CreateConfirmationPaymentDialog> createState() => _CreateConfirmationPaymentDialogState();
}

class _CreateConfirmationPaymentDialogState extends State<CreateConfirmationPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  @override
  void dispose() {
    _totalWeightController.dispose();
    _totalPriceController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final totalWeight = int.tryParse(_totalWeightController.text) ?? 0;
      final totalPrice = int.tryParse(_totalPriceController.text) ?? 0;
      final keterangan = _keteranganController.text;

      final requestModel = ConfirmationPaymentRequestModel(
        orderId: widget.orderId,
        totalWeight: totalWeight,
        totalPrice: totalPrice,
        keterangan: keterangan,
      );

      context.read<ConfirmationPaymentAdminBloc>().add(
            CreateNewConfirmationPayment(requestModel: requestModel),
          );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Buat Konfirmasi Pembayaran',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavyBlue,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Untuk Pesanan ID: ${widget.orderId}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 16),
              CustomTextFormField1(
                controller: _totalWeightController,
                keyboardType: TextInputType.number,
                labelText: 'Total Berat (kg)',
                hintText: 'Masukkan total berat laundry',
                prefixIcon: const Icon(Icons.fitness_center, color: AppColors.primaryBlue), 
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan total berat';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Berat harus angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextFormField1( 
                controller: _totalPriceController,
                keyboardType: TextInputType.number,
                labelText: 'Total Harga (Rp)',
                hintText: 'Masukkan total harga',
                prefixIcon: const Icon(Icons.attach_money, color: AppColors.primaryBlue), 
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan total harga';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Harga harus angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextFormField1( 
                controller: _keteranganController,
                maxLines: 3,
                labelText: 'Keterangan',
                hintText: 'Tambahkan keterangan tambahan (opsional)',
                prefixIcon: const Icon(Icons.description, color: AppColors.primaryBlue), 
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan keterangan';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grey,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            shadowColor: AppColors.primaryBlue.withOpacity(0.3),
          ),
          child: Text(
            'Buat Konfirmasi',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}