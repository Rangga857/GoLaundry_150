import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/colors.dart'; 
import 'package:laundry_app/data/model/request/pengeluaran/pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/request/pengeluaran/put_pengeluaran_request_model.dart';
import 'package:laundry_app/data/model/response/categorypengeluaran/get_all_cateogry_pengeluaran_response_model.dart';
import 'package:laundry_app/data/model/response/pengeluaran/get_all_pengeluaran_response_model.dart' as pengeluaran_model;
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_state.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_event.dart';

class PengeluaranFormDialog extends StatefulWidget {
  final pengeluaran_model.Datum? initialData;

  const PengeluaranFormDialog({
    super.key,
    this.initialData,
  });

  @override
  State<PengeluaranFormDialog> createState() => _PengeluaranFormDialogState();
}

class _PengeluaranFormDialogState extends State<PengeluaranFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jumlahController;
  late TextEditingController _deskripsiController;
  Datum? _selectedCategory;
  List<Datum> _categories = [];

  @override
  void initState() {
    super.initState();
    _jumlahController = TextEditingController(
      text: widget.initialData?.jumlahPengeluaran.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.initialData?.deskripsiPengeluaran ?? '',
    );

    // Memuat kategori saat dialog dibuka
    context.read<CategoryPengeluaranBloc>().add(const GetAllCategoriesPengeluaran());
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Silakan pilih kategori pengeluaran.',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      final int jumlah = int.parse(_jumlahController.text);
      final String deskripsi = _deskripsiController.text;

      if (widget.initialData == null) {
        final requestModel = PengeluaranRequestModel(
          namaKategori: _selectedCategory!.nama,
          jumlahPengeluaran: jumlah,
          deskripsiPengeluaran: deskripsi,
        );
        context.read<PengeluaranBloc>().add(AddPengeluaran(requestModel: requestModel));
      } else {
        final requestModel = PutPengeluaranRequestModel(
          namaKategori: _selectedCategory!.nama,
          jumlahPengeluaran: jumlah,
          deskripsiPengeluaran: deskripsi,
        );
        context.read<PengeluaranBloc>().add(
              UpdatePengeluaran(id: widget.initialData!.id, requestModel: requestModel),
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
        widget.initialData == null ? 'Tambah Pengeluaran Baru' : 'Edit Pengeluaran',
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
              BlocConsumer<CategoryPengeluaranBloc, CategoryPengeluaranState>(
                listener: (context, state) {
                  if (state is CategoryPengeluaranLoaded) {
                    final List<Datum> loadedData = state.categories.data;
                    if (_categories != loadedData || _categories.isEmpty || _selectedCategory == null) {
                      setState(() {
                        _categories = loadedData;
                        if (_categories.isNotEmpty) {
                          if (widget.initialData != null) {
                            _selectedCategory = _categories.firstWhere(
                              (cat) => cat.nama == widget.initialData!.nama,
                              orElse: () {
                                return _categories.first;
                              },
                            );
                          } else {
                            _selectedCategory = _categories.first;
                          }
                        } else {
                          _selectedCategory = null;
                        }
                      });
                    }
                  } else if (state is CategoryPengeluaranError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Gagal memuat kategori: ${state.message}',
                          style: GoogleFonts.poppins(color: AppColors.white),
                        ),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CategoryPengeluaranLoading) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                  } else if (state is CategoryPengeluaranLoaded) {
                    if (_categories.isEmpty) {
                      return Text(
                        'Tidak ada kategori yang tersedia. Tambahkan kategori terlebih dahulu.',
                        style: GoogleFonts.poppins(color: AppColors.grey),
                        textAlign: TextAlign.center,
                      );
                    }
                    if (_selectedCategory == null && _categories.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            if (widget.initialData != null) {
                              _selectedCategory = _categories.firstWhere(
                                (cat) => cat.nama == widget.initialData!.nama,
                                orElse: () => _categories.first,
                              );
                            } else {
                              _selectedCategory = _categories.first;
                            }
                          });
                        }
                      });
                      return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                    }
                    return DropdownButtonFormField<Datum>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Kategori Pengeluaran',
                        labelStyle: GoogleFonts.poppins(color: AppColors.grey),
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
                      ),
                      dropdownColor: AppColors.white,
                      style: GoogleFonts.poppins(color: AppColors.darkNavyBlue, fontSize: 16),
                      iconEnabledColor: AppColors.primaryBlue,
                      items: _categories.map((category) {
                        return DropdownMenuItem<Datum>(
                          value: category,
                          child: Text(
                            category.nama,
                            style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih kategori pengeluaran';
                        }
                        return null;
                      },
                    );
                  } else if (state is CategoryPengeluaranError) {
                    return Center(
                      child: Text(
                        'Error memuat kategori: ${state.message}',
                        style: GoogleFonts.poppins(color: AppColors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'Memuat kategori...',
                      style: GoogleFonts.poppins(color: AppColors.grey),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField1(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                labelText: 'Jumlah Pengeluaran',
                hintText: 'Misal: 50000',
                prefixText: 'Rp ',
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah pengeluaran tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Masukkan jumlah yang valid (angka positif)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField1(
                controller: _deskripsiController,
                maxLines: 3,
                labelText: 'Deskripsi Pengeluaran',
                hintText: 'Contoh: Pembelian sabun cuci',
                fillColor: AppColors.lightGrey.withOpacity(0.5),
                enabledBorderColor: AppColors.grey.withOpacity(0.4),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi pengeluaran tidak boleh kosong';
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