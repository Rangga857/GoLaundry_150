import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/response/pengeluaran/get_all_pengeluaran_response_model.dart' as pengeluaran_model;
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_state.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pengeluaran_form_dialog.dart';

class PengeluaranSection extends StatefulWidget {
  const PengeluaranSection({super.key});

  @override
  State<PengeluaranSection> createState() => _PengeluaranSectionState();
}

class _PengeluaranSectionState extends State<PengeluaranSection> {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    context.read<PengeluaranBloc>().add(const GetAllPengeluaran());
  }

  void _showAddEditDialog({pengeluaran_model.Datum? initialData}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<PengeluaranBloc>(),
            ),
            BlocProvider.value(
              value: context.read<CategoryPengeluaranBloc>(),
            ),
          ],
          child: PengeluaranFormDialog(
            initialData: initialData,
          ),
        );
      },
    );
  }

  void _confirmDelete(int pengeluaranId, String deskripsi) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Konfirmasi Hapus',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavyBlue,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus pengeluaran "$deskripsi"?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.grey,
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
              onPressed: () {
                context.read<PengeluaranBloc>().add(DeletePengeluaran(id: pengeluaranId));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                shadowColor: AppColors.red.withOpacity(0.3),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengeluaranBloc, PengeluaranState>(
      listener: (context, state) {
        if (state is PengeluaranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${state.message}',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.red,
            ),
          );
        } else if (state is PengeluaranAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pengeluaran berhasil ditambahkan!',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.green,
            ),
          );
        } else if (state is PengeluaranUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pengeluaran berhasil diperbarui!',
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.green,
            ),
          );
        } else if (state is PengeluaranDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(color: AppColors.white),
              ),
              backgroundColor: AppColors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PengeluaranLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
        } else if (state is PengeluaranLoaded) {
          if (state.pengeluaranList.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tidak ada data pengeluaran.',
                    style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add, color: AppColors.white),
                    label: Text(
                      'Tambah Pengeluaran',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add, color: AppColors.white),
                    label: Text(
                      'Tambah Pengeluaran Baru',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.pengeluaranList.data.length,
                  itemBuilder: (context, index) {
                    final pengeluaran = state.pengeluaranList.data[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: AppColors.cardBackgroundLight, 
                      shadowColor: AppColors.darkNavyBlue.withOpacity(0.5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const Icon(Icons.money_off, color: AppColors.black87),
                        title: Text(
                          pengeluaran.nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              pengeluaran.deskripsiPengeluaran,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.black87,
                              ),
                            ),
                            Text(
                              'Jumlah: ${currencyFormatter.format(pengeluaran.jumlahPengeluaran)}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.black87,
                              ),
                            ),
                            Text(
                              'Tanggal: ${DateFormat('dd MMMM yyyy').format(pengeluaran.createdAt)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.black87.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.customColor2),
                              onPressed: () {
                                _showAddEditDialog(initialData: pengeluaran);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.red),
                              onPressed: () => _confirmDelete(
                                pengeluaran.id,
                                pengeluaran.deskripsiPengeluaran,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is PengeluaranError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Terjadi kesalahan: ${state.message}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: AppColors.red, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PengeluaranBloc>().add(const GetAllPengeluaran());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Text(
            'Memuat data pengeluaran...',
            style: GoogleFonts.poppins(color: AppColors.grey),
          ),
        );
      },
    );
  }
}