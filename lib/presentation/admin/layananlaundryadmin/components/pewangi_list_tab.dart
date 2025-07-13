import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/jenispewangi/jenis_pewangi_request_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_state.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/delete_confirmation_dialog.dart';

class PewangiListTab extends StatefulWidget {
  const PewangiListTab({
    super.key,
  });

  @override
  State<PewangiListTab> createState() => _PewangiListTabState();
}

class _PewangiListTabState extends State<PewangiListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEditPewangiDialog(BuildContext context, DatumPewangi pewangi) {
    final TextEditingController namaController = TextEditingController(text: pewangi.nama);
    final TextEditingController deskripsiController = TextEditingController(text: pewangi.deskripsi);
    final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Edit Jenis Pewangi',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavyBlue,
            ),
          ),
          content: SingleChildScrollView(
            child: Form( 
              key: _editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField1(
                    controller: namaController,
                    labelText: 'Nama Pewangi',
                    hintText: 'Masukkan nama pewangi',
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
                    controller: deskripsiController,
                    labelText: 'Deskripsi Pewangi',
                    hintText: 'Masukkan deskripsi pewangi',
                    maxLines: 3,
                    fillColor: AppColors.lightGrey.withOpacity(0.5),
                    enabledBorderColor: AppColors.grey.withOpacity(0.4),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grey, 
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (_editFormKey.currentState!.validate()) {
                  final request = JenisPewangiRequestModel(
                    nama: namaController.text,
                    deskripsi: deskripsiController.text,
                  );
                  context.read<AdminJenisPewangiBloc>().add(UpdateJenisPewangiEvent(id: pewangi.id, request: request));
                  Navigator.of(dialogContext).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CustomTextFormField1(
            controller: _searchController,
            labelText: 'Cari Pewangi',
            hintText: 'Masukkan nama pewangi...',
            fillColor: AppColors.lightGrey.withOpacity(0.5),
            enabledBorderColor: AppColors.grey.withOpacity(0.4),
          ),
        ),
        Expanded(
          child: BlocConsumer<AdminJenisPewangiBloc, AdminJenisPewangiState>(
            listener: (context, state) {
              if (state is JenisPewangiUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pewangi "${state.response.data?.nama ?? 'Terpilih'}" berhasil diperbarui!',
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: AppColors.primaryBlue,
                  ),
                );
                context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
              } else if (state is JenisPewangiDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.response.message,
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: Colors.green, 
                  ),
                );
                context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
              } else if (state is AdminJenisPewangiError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Operasi gagal: ${state.message}',
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminJenisPewangiLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
              } else if (state is AdminJenisPewangiAllLoaded) {
                if (state.jenisPewangiList.data.isEmpty) {
                  return Center(
                      child: Text(
                    'Tidak ada jenis pewangi tersedia.',
                    style: GoogleFonts.poppins(color: AppColors.grey),
                  ));
                }

                final filteredPewangi = state.jenisPewangiList.data.where((pewangi) {
                  return pewangi.nama.toLowerCase().contains(_searchText.toLowerCase());
                }).toList();

                if (filteredPewangi.isEmpty) {
                  return Center(
                      child: Text(
                    'Tidak ada pewangi yang cocok dengan pencarian Anda.',
                    style: GoogleFonts.poppins(color: AppColors.grey),
                  ));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
                  },
                  color: AppColors.primaryBlue, 
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    itemCount: filteredPewangi.length,
                    itemBuilder: (context, index) {
                      final DatumPewangi pewangi = filteredPewangi[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4.0, 
                        color: AppColors.cardBackgroundLight, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), 
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            pewangi.nama,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.black87, 
                            ),
                          ),
                          subtitle: Text(
                            pewangi.deskripsi,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.black87, 
                            ),
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.darkNavyBlue),
                                onPressed: () {
                                  _showEditPewangiDialog(context, pewangi);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  showDeleteConfirmationDialog(
                                    context: context,
                                    title: 'Hapus Pewangi',
                                    content: 'Anda yakin ingin menghapus pewangi "${pewangi.nama}"? Tindakan ini tidak dapat dibatalkan.',
                                    onConfirm: () {
                                      context.read<AdminJenisPewangiBloc>().add(DeleteJenisPewangiEvent(pewangi.id));
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is AdminJenisPewangiError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                  ),
                );
              }
              return Center(
                  child: Text(
                'Geser ke bawah untuk memuat pewangi.',
                style: GoogleFonts.poppins(color: AppColors.grey),
              ));
            },
          ),
        ),
      ],
    );
  }
}