import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/servicelaundry/service_laundry_request_model.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_state.dart';

class AddServiceTab extends StatefulWidget {
  const AddServiceTab({super.key});

  @override
  State<AddServiceTab> createState() => _AddServiceTabState();
}

class _AddServiceTabState extends State<AddServiceTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _pricePerKgController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _pricePerKgController.dispose();
    super.dispose();
  }

  void _addService() {
    if (_formKey.currentState!.validate()) {
      final int? priceperkg = int.tryParse(_pricePerKgController.text);
      if (priceperkg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Harga per Kg harus berupa angka valid.',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final request = ServiceLaundryRequestModel(
        title: _titleController.text,
        subtitle: _subTitleController.text,
        priceperkg: priceperkg,
      );
      context.read<AdminServiceLaundryBloc>().add(AddServiceLaundryEvent(request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminServiceLaundryBloc, AdminServiceLaundryState>(
      listener: (context, state) {
        if (state is ServiceLaundryAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Layanan "${state.response.data?.title ?? 'Baru'}" berhasil ditambahkan!',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
          _titleController.clear();
          _subTitleController.clear();
          _pricePerKgController.clear();
          context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
        } else if (state is AdminServiceLaundryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal menambahkan layanan: ${state.message}',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Layanan Laundry Baru',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavyBlue,
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),
              CustomTextFormField1(
                controller: _titleController,
                labelText: 'Judul Layanan',
                hintText: 'Misal: Cuci Kering, Cuci Setrika',
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding),
              CustomTextFormField1(
                controller: _subTitleController,
                labelText: 'Sub Judul / Deskripsi Singkat',
                hintText: 'Misal: Pakaian bersih tanpa disetrika',
                maxLines: 3, 
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sub Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding),

              CustomTextFormField1(
                controller: _pricePerKgController,
                labelText: 'Harga per Kg',
                hintText: 'Contoh: 6000',
                keyboardType: TextInputType.number,
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka bulat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 2.5),

              Center(
                child: BlocBuilder<AdminServiceLaundryBloc, AdminServiceLaundryState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AdminServiceLaundryLoading ? null : _addService,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                      ),
                      child: state is AdminServiceLaundryLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Tambah Layanan',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}