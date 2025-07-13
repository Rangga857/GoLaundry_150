import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_pelanggan.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_state.dart';
import 'package:laundry_app/data/model/response/pembayaran/get_my_pembayaran_response_model.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/presentation/pelanggan/payment/components/payment_card_header.dart';
import 'package:laundry_app/presentation/pelanggan/payment/components/payment_section.dart';
import 'package:laundry_app/core/constants/constants.dart';

class MyPaymentsPage extends StatefulWidget {
  const MyPaymentsPage({super.key});

  @override
  State<MyPaymentsPage> createState() => _MyPaymentsPageState();
}

class _MyPaymentsPageState extends State<MyPaymentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PembayaranPelangganBloc>().add(const GetMyPayments());
  }

  String _formatCurrency(num amount) {
    return 'Rp${NumberFormat('#,##0', 'id_ID').format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackgroundLight, 
      appBar: AppBar(
        title: Text(
          'Daftar Pembayaran Saya',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.darkNavyBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
      ),
      body: BlocBuilder<PembayaranPelangganBloc, PembayaranPelangganState>(
        builder: (context, state) {
          if (state is PembayaranLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.white));
          } else if (state is MyPaymentsLoaded) {
            if (state.payments.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, size: 80, color: AppColors.grey),
                    SizedBox(height: kDefaultPadding),
                    Text(
                      'Belum ada riwayat pembayaran.',
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Lakukan pembayaran pertama Anda!',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: state.payments.data.length,
              itemBuilder: (context, index) {
                final DatumMyPembayaran payment = state.payments.data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: kDefaultPadding),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultPadding)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentCardHeader(
                        status: payment.status,
                        metodePembayaran: payment.metodePembayaran,
                        createdAt: payment.createdAt,
                      ),
                      const Divider(height: 1, indent: kDefaultPadding, endIndent: kDefaultPadding, color: AppColors.lightGrey),
                      PaymentSection(
                        title: 'ID Konfirmasi',
                        value: payment.confirmationPaymentId.toString(),
                      ),
                      PaymentSection(
                        title: 'Total Harga Order',
                        value: _formatCurrency(payment.totalFullPriceOrder),
                        valueColor: AppColors.primaryBlue,
                      ),
                      if (payment.buktiPembayaranUrl.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                          child: Text(
                            'Bukti Pembayaran:',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              payment.buktiPembayaranUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: AppColors.lightGrey,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.broken_image, color: AppColors.grey, size: 40),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Gagal memuat gambar bukti pembayaran',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(color: AppColors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: kDefaultPadding / 2),
                    ],
                  ),
                );
              },
            );
          } else if (state is PembayaranError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: kDefaultPadding),
                    Text(
                      'Terjadi kesalahan saat memuat data pembayaran.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.white),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Pesan error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.white),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PembayaranPelangganBloc>().add(const GetMyPayments());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Coba Lagi',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Text(
              'Silakan muat pembayaran Anda.',
              style: GoogleFonts.poppins(fontSize: 16, color: AppColors.white),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBarPelanggan(selectedIndex: 2),
    );
  }
}