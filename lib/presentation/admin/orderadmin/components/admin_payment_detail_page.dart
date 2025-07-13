import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/pembayaran/confirm_pembayaran_request_model.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_state.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';

class PaymentDetailPage extends StatefulWidget {
  final int paymentId;

  const PaymentDetailPage({super.key, required this.paymentId});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  String? _selectedPaymentStatus;
  final List<String> _paymentStatusOptions = const [
    'not confirmed',
    'confirmed',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminPaymentBloc>().add(GetPaymentById(paymentId: widget.paymentId));
  }

  void _showSnackBar(String message, {Color backgroundColor = AppColors.primaryBlue}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: AppColors.white),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue, 
      appBar: AppBar(
        title: Text(
          'Detail Pembayaran',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.darkNavyBlue,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkNavyBlue, 
        elevation: 0, 
        centerTitle: true,
      ),
      body: BlocConsumer<AdminPaymentBloc, AdminPaymentState>(
        listener: (context, state) {
          if (state is PaymentDetailLoaded) {
            setState(() {
              _selectedPaymentStatus = _paymentStatusOptions.contains(state.paymentDetail.status.toLowerCase())
                  ? state.paymentDetail.status.toLowerCase()
                  : null;
            });
          } else if (state is PaymentConfirmed) {
            _showSnackBar('Status pembayaran berhasil diperbarui!', backgroundColor: AppColors.primaryBlue);
            Navigator.of(context).pop();
            context.read<AdminOrderBloc>().add(const GetAdminOrdersAllEvent());
          } else if (state is AdminPaymentError) {
            _showSnackBar('Error: ${state.message}', backgroundColor: AppColors.red);
          }
        },
        builder: (context, state) {
          if (state is PaymentDetailLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
          } else if (state is PaymentDetailLoaded) {
            final paymentDetail = state.paymentDetail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Card(
                color: AppColors.white, 
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ID Pembayaran:', '${paymentDetail.id}'),
                      _buildDetailRow('Metode:', paymentDetail.metodePembayaran),
                      _buildDetailRow('Total Harga:', 'Rp ${paymentDetail.totalFullPriceOrder}'),
                      _buildDetailRow('Keterangan:', paymentDetail.keteranganOrder),
                      _buildDetailRow('Pelanggan:', paymentDetail.customerName),
                      _buildDetailRow('Admin:', paymentDetail.adminName),
                      const SizedBox(height: 16),
                      if (paymentDetail.buktiPembayaranUrl.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bukti Pembayaran:',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkNavyBlue),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showSnackBar('Membuka gambar: ${paymentDetail.buktiPembayaranUrl}');
                                },
                                child: Container(
                                  constraints: const BoxConstraints(maxHeight: 250),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.grey.withOpacity(0.5)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      paymentDetail.buktiPembayaranUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                            color: AppColors.primaryBlue,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.broken_image, size: 100, color: AppColors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      Text(
                        'Ubah Status Pembayaran:',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkNavyBlue),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentStatus,
                        style: GoogleFonts.poppins(color: AppColors.darkNavyBlue, fontSize: 14),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.grey.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.grey.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: AppColors.lightGrey.withOpacity(0.3),
                        ),
                        dropdownColor: AppColors.white,
                        items: _paymentStatusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status.toUpperCase(),
                              style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null && newValue != _selectedPaymentStatus) {
                            setState(() {
                              _selectedPaymentStatus = newValue;
                            });
                            context.read<AdminPaymentBloc>().add(
                                  ConfirmPayment(
                                    paymentId: paymentDetail.id,
                                    request: ConfirmPembayaranRequestModel(
                                      status: newValue,
                                    ),
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AdminPaymentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gagal memuat detail pembayaran: ${state.message}',
                    style: GoogleFonts.poppins(color: AppColors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdminPaymentBloc>().add(GetPaymentById(paymentId: widget.paymentId));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Coba Lagi',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.darkNavyBlue),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 15, color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}