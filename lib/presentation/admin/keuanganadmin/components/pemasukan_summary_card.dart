import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/core/constants/colors.dart';

class PemasukanSummaryCard extends StatelessWidget {
  final int totalOffline;
  final int totalOnline;
  final int grandTotal;
  final NumberFormat currencyFormatter;
  final VoidCallback onDownloadReport;

  const PemasukanSummaryCard({
    super.key,
    required this.totalOffline,
    required this.totalOnline,
    required this.grandTotal,
    required this.currencyFormatter,
    required this.onDownloadReport,
  });

  Widget _buildSummaryRow(String label, int amount, {bool isBold = false, bool isGrandTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isGrandTotal ? 17 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.darkNavyBlue,
            ),
          ),
          Text(
            currencyFormatter.format(amount),
            style: GoogleFonts.poppins(
              fontSize: isGrandTotal ? 17 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.darkNavyBlue, 
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.white, 
      shadowColor: AppColors.primaryBlue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Pemasukan',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavyBlue, 
              ),
            ),
            Divider(color: AppColors.grey.withOpacity(0.4), thickness: 1.5),
            const SizedBox(height: 10),
            _buildSummaryRow(
              'Total Pemasukan Offline',
              totalOffline,
            ),
            _buildSummaryRow(
              'Total Pemasukan Online',
              totalOnline,
            ),
            _buildSummaryRow(
              'Grand Total Pemasukan',
              grandTotal,
              isBold: true,
              isGrandTotal: true,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onDownloadReport,
                icon: const Icon(Icons.download, color: AppColors.white),
                label: Text(
                  'Unduh Laporan PDF',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  elevation: 3,
                  shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}