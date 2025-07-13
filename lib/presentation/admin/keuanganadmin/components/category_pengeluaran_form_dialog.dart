import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/request/categorypengeluaran/category_pengeluaran_request_model.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_event.dart';

class CategoryPengeluaranFormDialog extends StatefulWidget {
  final int? categoryId;
  final String? initialName;

  const CategoryPengeluaranFormDialog({
    super.key,
    this.categoryId,
    this.initialName,
  });

  @override
  State<CategoryPengeluaranFormDialog> createState() => _CategoryPengeluaranFormDialogState();
}

class _CategoryPengeluaranFormDialogState extends State<CategoryPengeluaranFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final requestModel = CateogryPengeluaranRequestModel(nama: _nameController.text);

      if (widget.categoryId == null) {
        context.read<CategoryPengeluaranBloc>().add(AddCategoryPengeluaran(requestModel: requestModel));
      } else {
        context.read<CategoryPengeluaranBloc>().add(
              UpdateCategoryPengeluaran(id: widget.categoryId!, requestModel: requestModel),
            );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        widget.categoryId == null ? 'Tambah Kategori Baru' : 'Edit Kategori',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavyBlue,
        ),
      ),
      content: Form(
        key: _formKey,
        child: CustomTextFormField1(
          controller: _nameController,
          labelText: 'Nama Kategori',
          hintText: 'Misal: Listrik, Gaji Karyawan',
          fillColor: AppColors.lightGrey.withOpacity(0.5),
          enabledBorderColor: AppColors.grey.withOpacity(0.4),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama kategori tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
            widget.categoryId == null ? 'Tambah' : 'Simpan',
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