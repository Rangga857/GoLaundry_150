import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart';
import 'package:intl/intl.dart';

class ViewConfirmationPaymentDialog extends StatelessWidget {
  final Datum confirmationPayment;

  const ViewConfirmationPaymentDialog({super.key, required this.confirmationPayment});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Detail Konfirmasi Pembayaran',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavyBlue,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID Konfirmasi:', '${confirmationPayment.id}'),
            _buildDetailRow('ID Pesanan:', '${confirmationPayment.orderId}'),
            _buildDetailRow('Nama Pelanggan:', confirmationPayment.customerName),
            _buildDetailRow('Nama Laundry:', confirmationPayment.laundryName),
            _buildDetailRow('Alamat Penjemputan:', confirmationPayment.pickupAddress),
            _buildDetailRow('Total Berat:', '${confirmationPayment.totalWeight} kg'),
            _buildDetailRow('Total Harga:', 'Rp ${NumberFormat.decimalPattern('id').format(confirmationPayment.totalPrice)}'),
            _buildDetailRow('Total Ongkir:', 'Rp ${NumberFormat.decimalPattern('id').format(confirmationPayment.totalOngkir)}'),
            _buildDetailRow('Total Keseluruhan:', 'Rp ${NumberFormat.decimalPattern('id').format(confirmationPayment.totalFullPrice)}', isBoldValue: true), // Total keseluruhan lebih menonjol
            _buildDetailRow('Keterangan:', confirmationPayment.keterangan),
            _buildDetailRow('Dibuat Pada:', DateFormat('dd MMM yyyy HH:mm').format(confirmationPayment.createdAt)),
            _buildDetailRow('Diperbarui Pada:', DateFormat('dd MMM yyyy HH:mm').format(confirmationPayment.updatedAt)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, 
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, 
                color: AppColors.darkNavyBlue, 
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: isBoldValue ? AppColors.primaryBlue : AppColors.grey, 
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}