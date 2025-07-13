import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/jenispewangi/jenis_pewangi_request_model.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_state.dart';

class AddPewangiTab extends StatefulWidget {
  const AddPewangiTab({super.key});

  @override
  State<AddPewangiTab> createState() => _AddPewangiTabState();
}

class _AddPewangiTabState extends State<AddPewangiTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _addPewangi() {
    if (_formKey.currentState!.validate()) {
      final request = JenisPewangiRequestModel(
        nama: _namaController.text,
        deskripsi: _deskripsiController.text,
      );
      context.read<AdminJenisPewangiBloc>().add(AddJenisPewangiEvent(request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminJenisPewangiBloc, AdminJenisPewangiState>(
      listener: (context, state) {
        if (state is JenisPewangiAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pewangi "${state.response.data?.nama ?? 'Baru'}" berhasil ditambahkan!',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
          _namaController.clear();
          _deskripsiController.clear();
          context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
        } else if (state is AdminJenisPewangiError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal menambahkan pewangi: ${state.message}',
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
                'Tambah Jenis Pewangi Baru',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavyBlue,
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              CustomTextFormField1(
                controller: _namaController,
                labelText: 'Nama Pewangi',
                hintText: 'Misal: Lavender, Ocean Breeze',
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding),
              CustomTextFormField1(
                controller: _deskripsiController,
                labelText: 'Deskripsi Pewangi',
                hintText: 'Misal: Aroma bunga yang menenangkan',
                maxLines: 4, 
                fillColor: AppColors.lightGrey.withOpacity(0.5), 
                enabledBorderColor: AppColors.grey.withOpacity(0.4), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 2.5),

              Center(
                child: BlocBuilder<AdminJenisPewangiBloc, AdminJenisPewangiState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AdminJenisPewangiLoading ? null : _addPewangi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                      ),
                      child: state is AdminJenisPewangiLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Tambah Pewangi',
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