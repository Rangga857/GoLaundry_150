import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart'; 
import 'package:laundry_app/core/constants/constants.dart'; 
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart' as confirm_res;
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_state.dart';
import 'package:laundry_app/presentation/pelanggan/payment/components/add_payment_page.dart';
import 'package:intl/intl.dart'; 

class ConfirmationPaymentDetailDialog extends StatelessWidget {
  final int orderId;

  const ConfirmationPaymentDetailDialog({
    super.key,
    required this.orderId,
  });

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp',
      decimalDigits: 0, 
    );
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfirmationPaymentPelangganBloc>().add(
            GetSingleConfirmationPaymentForPelanggan(orderId: orderId),
          );
    });

    return BlocConsumer<ConfirmationPaymentPelangganBloc, ConfirmationPaymentPelangganState>(
      listener: (context, state) {
        if (state is SingleConfirmationPaymentPelangganError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SingleConfirmationPaymentPelangganLoading) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primaryBlue),
                const SizedBox(height: 20),
                Text(
                  'Memuat detail konfirmasi pembayaran...',
                  style: GoogleFonts.poppins(fontSize: 16, color: AppColors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (state is SingleConfirmationPaymentPelangganLoaded) {
          final confirm_res.Datum confirmation = state.confirmationPayment;
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Detail Konfirmasi Pembayaran',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primaryBlueDark,
              ),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('ID Order:', '${confirmation.orderId}', isBold: true),
                  _buildDetailRow('Nama Pengirim:', confirmation.laundryName),
                  _buildDetailRow('Nama Customer:', confirmation.customerName),
                  _buildDetailRow('Alamat Penjemputan:', confirmation.pickupAddress),
                  _buildDetailRow('Jumlah Berat:', '${confirmation.totalWeight.toStringAsFixed(0)} kg'),
                  _buildDetailRow('Harga Pencucian:', _formatCurrency(confirmation.totalPrice.toDouble())),
                  _buildDetailRow('Total Ongkir:', _formatCurrency(confirmation.totalOngkir.toDouble())),
                  _buildDetailRow('Jumlah Dibayar:', _formatCurrency(confirmation.totalFullPrice.toDouble()), isHighlight: true),
                  _buildDetailRow('Detail Item Laundry:', confirmation.keterangan, isMultiline: true),
                  _buildDetailRow('Tanggal Konfirmasi:', DateFormat('dd MMMM yyyy').format(confirmation.updatedAt.toLocal())),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddPaymentPage(
                              confirmationPaymentId: confirmation.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: Text(
                        'Buat Pembayaran',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.grey),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ),
            ],
          );
        } else {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Detail Konfirmasi Pembayaran',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primaryBlueDark,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, size: 60, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  'Ketuk ikon lagi jika detail tidak muncul atau terjadi kesalahan.',
                  style: GoogleFonts.poppins(fontSize: 15, color: AppColors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.grey),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isHighlight = false, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120, 
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: AppColors.black87,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: isBold ? FontWeight.w700 : (isHighlight ? FontWeight.w800 : FontWeight.normal),
                fontSize: isHighlight ? 16 : 14,
                color: isHighlight ? AppColors.primaryBlueDark : AppColors.black87,
              ),
              maxLines: isMultiline ? null : 2, 
              overflow: isMultiline ? TextOverflow.clip : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}