import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/colors.dart'; // Pastikan AppColors diimpor
import 'package:laundry_app/data/model/request/pemasukan/pemasukan_request_model.dart';
import 'package:laundry_app/data/model/request/pemasukan/put_pemasukan_request_model.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_manual_pemasukan_response_model.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/custome_date_picker.dart';

class PemasukanFormDialog extends StatefulWidget {
  final Datum? initialData;

  const PemasukanFormDialog({
    super.key,
    this.initialData,
  });

  @override
  State<PemasukanFormDialog> createState() => _PemasukanFormDialogState();
}

class _PemasukanFormDialogState extends State<PemasukanFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialData?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialData?.description ?? '',
    );
    _selectedDate = widget.initialData?.transactionDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_amountController.text);
      final String description = _descriptionController.text;

      if (widget.initialData == null) {
        final requestModel = PemasukanRequestModel(
          amount: amount,
          description: description,
          transactionDate: _selectedDate,
        );
        context.read<PemasukanBloc>().add(AddPemasukanEvent(requestModel));
      } else {
        final requestModel = PutPemasukanRequestModel(
          amount: amount.toInt(),
          description: description,
          transactionDate: _selectedDate,
        );
        context.read<PemasukanBloc>().add(UpdatePemasukanEvent(id: widget.initialData!.id, request: requestModel));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Sudut membulat
      ),
      title: Text(
        widget.initialData == null ? 'Tambah Pemasukan Baru' : 'Edit Pemasukan',
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
              CustomTextFormField1(
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelText: 'Jumlah Pemasukan',
                hintText: 'Misal: 150000',
                prefixText: 'Rp ', // prefixText tetap di CustomTextFormField
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah pemasukan tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Masukkan jumlah yang valid (angka positif)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField1(
                controller: _descriptionController,
                maxLines: 3,
                labelText: 'Deskripsi',
                hintText: 'Contoh: Pembayaran cuci express',
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDatePickerField(
                labelText: 'Tanggal Transaksi',
                initialDate: _selectedDate,
                onDateSelected: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal transaksi tidak boleh kosong';
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
            widget.initialData == null ? 'Tambah' : 'Simpan',
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