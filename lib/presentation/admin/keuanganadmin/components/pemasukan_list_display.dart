import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/response/pemasukan/get_manual_pemasukan_response_model.dart';

class PemasukanListDisplay extends StatelessWidget {
  final List<Datum> pemasukanList;
  final NumberFormat currencyFormatter;
  final Function(Datum data) onEdit;
  final Function(int id) onDelete;

  const PemasukanListDisplay({
    super.key,
    required this.pemasukanList,
    required this.currencyFormatter,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (pemasukanList.isEmpty) {
      return Center(
        child: Text(
          'Belum ada catatan pemasukan.',
          style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: pemasukanList.length,
      itemBuilder: (context, index) {
        final pemasukan = pemasukanList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 6, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: AppColors.cardBackgroundLight,
          shadowColor: AppColors.black87.withOpacity(0.4), 
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const Icon(Icons.attach_money, color: AppColors.black87),
            title: Text(
              pemasukan.description,
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
                  'Jumlah: ${currencyFormatter.format(pemasukan.amount)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.black87,
                  ),
                ),
                Text(
                  'Tanggal: ${DateFormat('dd MMMM yyyy').format(pemasukan.transactionDate)}',
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
                  onPressed: () => onEdit(pemasukan),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.red),
                  onPressed: () => onDelete(pemasukan.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}