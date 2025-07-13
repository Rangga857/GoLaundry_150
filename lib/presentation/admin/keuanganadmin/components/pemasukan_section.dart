import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_manual_pemasukan_response_model.dart' as pemasukan_model;
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_state.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pemasukan_form_dialog.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pemasukan_list_display.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pemasukan_summary_card.dart';
import 'package:open_filex/open_filex.dart'; 

class PemasukanSection extends StatefulWidget {
  const PemasukanSection({super.key});

  @override
  State<PemasukanSection> createState() => _PemasukanSectionState();
}

class _PemasukanSectionState extends State<PemasukanSection> {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    context.read<PemasukanBloc>().add(const LoadPemasukan());
  }

  void _showPemasukanFormDialog({pemasukan_model.Datum? initialData}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<PemasukanBloc>(),
          child: PemasukanFormDialog(initialData: initialData),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int id, String description) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
            'Apakah Anda yakin ingin menghapus pemasukan "$description"?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
                context.read<PemasukanBloc>().add(DeletePemasukanEvent(id));
                Navigator.of(dialogContext).pop();
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
    return BlocConsumer<PemasukanBloc, PemasukanState>(
      listener: (context, state) {
        if (state is PemasukanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}', style: GoogleFonts.poppins(color: AppColors.white))),
          );
        } else if (state is PemasukanLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!, style: GoogleFonts.poppins(color: AppColors.white))),
          );
        } else if (state is PemasukanPdfDownloaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Laporan PDF berhasil diunduh ke: ${state.filePath}', style: GoogleFonts.poppins(color: AppColors.white))),
          );
          OpenFilex.open(state.filePath);
        } else if (state is PemasukanPdfError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunduh laporan PDF: ${state.message}', style: GoogleFonts.poppins(color: AppColors.white))),
          );
        }
      },
      builder: (context, state) {
        if (state is PemasukanLoading || state is PemasukanPdfDownloading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
        } else if (state is PemasukanLoaded) {
          final int totalPemasukanOffline = (state.totalPemasukanData?.totalPemasukanOfflineTercatat ?? 0.0).toInt();
          final int totalPemasukanOnline = (state.totalPemasukanData?.totalPemasukanOnlineTerkonfirmasi ?? 0.0).toInt();
          final int grandTotalPemasukan = (state.totalPemasukanData?.grandTotalPemasukan ?? 0.0).toInt();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PemasukanSummaryCard(
                totalOffline: totalPemasukanOffline,
                totalOnline: totalPemasukanOnline,
                grandTotal: grandTotalPemasukan,
                currencyFormatter: currencyFormatter,
                onDownloadReport: () {
                  context.read<PemasukanBloc>().add(const DownloadPemasukanPdfReport());
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showPemasukanFormDialog(),
                  icon: const Icon(Icons.add, color: AppColors.white),
                  label: Text(
                    'Tambah Pemasukan Baru',
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
              Expanded(
                child: PemasukanListDisplay(
                  pemasukanList: state.pemasukanList,
                  currencyFormatter: currencyFormatter,
                  onEdit: (pemasukan_model.Datum pemasukan) {
                    _showPemasukanFormDialog(initialData: pemasukan);
                  },
                  onDelete: (int id) {
                    final pemasukan = state.pemasukanList.firstWhere((e) => e.id == id);
                    _confirmDelete(context, pemasukan.id, pemasukan.description);
                  },
                ),
              ),
            ],
          );
        } else if (state is PemasukanError) {
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
                    context.read<PemasukanBloc>().add(const LoadPemasukan());
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
            'Memuat data pemasukan...',
            style: GoogleFonts.poppins(color: AppColors.grey),
          ),
        );
      },
    );
  }
}