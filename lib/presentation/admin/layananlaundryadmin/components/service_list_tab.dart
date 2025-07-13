import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/components/custom_text_form_field1.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/servicelaundry/service_laundry_request_model.dart';
import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_state.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/delete_confirmation_dialog.dart';

class ServiceListTab extends StatefulWidget {
  const ServiceListTab({super.key});

  @override
  State<ServiceListTab> createState() => _ServiceListTabState();
}

class _ServiceListTabState extends State<ServiceListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<DatumService> _services = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  void _showEditServiceDialog(BuildContext context, DatumService service) {
    final TextEditingController titleController = TextEditingController(text: service.title);
    final TextEditingController subTitleController = TextEditingController(text: service.subTitle);
    final TextEditingController pricePerKgController = TextEditingController(
      text: service.pricePerKg.toString(),
    );

    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Edit Layanan Laundry',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavyBlue,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField1(
                    controller: titleController,
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
                    controller: subTitleController,
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
                    controller: pricePerKgController,
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
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (dialogFormKey.currentState!.validate()) {
                  final int? priceperkg = int.tryParse(pricePerKgController.text);
                  if (priceperkg == null) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
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
                    title: titleController.text,
                    subtitle: subTitleController.text,
                    priceperkg: priceperkg,
                  );
                  context.read<AdminServiceLaundryBloc>().add(UpdateServiceLaundryEvent(id: service.id, request: request));
                  Navigator.of(dialogContext).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
            labelText: 'Cari Layanan',
            hintText: 'Masukkan nama layanan...',
            fillColor: AppColors.lightGrey.withOpacity(0.5),
            enabledBorderColor: AppColors.grey.withOpacity(0.4),
            prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          ),
        ),
        Expanded(
          child: BlocConsumer<AdminServiceLaundryBloc, AdminServiceLaundryState>(
            listener: (context, state) {
              if (state is AdminServiceLaundryAllLoaded) {
                setState(() {
                  _services = state.serviceLaundryList.data;
                  _errorMessage = null; 
                });
              } else if (state is ServiceLaundryUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Layanan "${state.response.data?.title ?? 'Terpilih'}" berhasil diperbarui!',
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: AppColors.primaryBlue,
                  ),
                );
                context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
              } else if (state is ServiceLaundryDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.response.message,
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: Colors.green, 
                  ),
                );
                context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
              } else if (state is AdminServiceLaundryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error: ${state.message}',
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                if (_services.isEmpty) {
                  setState(() {
                    _errorMessage = state.message;
                  });
                }
              }
            },
            builder: (context, state) {
              if (state is AdminServiceLaundryLoading && _services.isEmpty && _errorMessage == null) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
              } else if (_errorMessage != null) {
                return Center(
                  child: Text(
                    'Gagal memuat layanan laundry: $_errorMessage',
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (_services.isEmpty && state is! AdminServiceLaundryLoading) {
                return Center(
                    child: Text(
                  'Tidak ada layanan laundry tersedia.',
                  style: GoogleFonts.poppins(color: AppColors.grey),
                ));
              }

              final filteredServices = _services.where((service) {
                return service.title.toLowerCase().contains(_searchText.toLowerCase()) ||
                       service.subTitle.toLowerCase().contains(_searchText.toLowerCase()); 
              }).toList();

              if (filteredServices.isEmpty && _searchText.isNotEmpty) {
                return Center(
                    child: Text(
                  'Tidak ada layanan yang cocok dengan pencarian Anda.',
                  style: GoogleFonts.poppins(color: AppColors.grey),
                ));
              } else if (filteredServices.isEmpty && _searchText.isEmpty) {
                return Center(
                    child: Text(
                  'Tidak ada layanan laundry tersedia.',
                  style: GoogleFonts.poppins(color: AppColors.grey),
                ));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
                },
                color: AppColors.primaryBlue, 
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final DatumService service = filteredServices[index];
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
                          service.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.black87, 
                          ),
                        ),
                        subtitle: Text(
                          '${service.subTitle}\nHarga: ${_formatPrice(service.pricePerKg)} / Kg',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.black87,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.black87), 
                              onPressed: () {
                                _showEditServiceDialog(context, service);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent), 
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                  context: context,
                                  title: 'Hapus Layanan',
                                  content: 'Anda yakin ingin menghapus layanan "${service.title}"? Tindakan ini tidak dapat dibatalkan.',
                                  onConfirm: () {
                                    context.read<AdminServiceLaundryBloc>().add(DeleteServiceLaundryEvent(service.id));
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
            },
          ),
        ),
      ],
    );
  }
}