import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/response/confirmationpaymetns/get_all_confirmation_payment_response_model.dart' as confirm_res;
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_state.dart';

class ConfirmationNotificationScreen extends StatefulWidget {
  const ConfirmationNotificationScreen({super.key});

  @override
  State<ConfirmationNotificationScreen> createState() => _ConfirmationNotificationScreenState();
}

class _ConfirmationNotificationScreenState extends State<ConfirmationNotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConfirmationPaymentPelangganBloc>().add(GetConfirmationPaymentsByPelanggan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Konfirmasi Pembayaran'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
      ),
      body: BlocBuilder<ConfirmationPaymentPelangganBloc, ConfirmationPaymentPelangganState>(
        builder: (context, state) {
          if (state is ConfirmationPaymentPelangganLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConfirmationPaymentPelangganLoaded) {
            if (state.confirmationPayments.data.isEmpty) {
              return const Center(child: Text('Tidak ada notifikasi konfirmasi pembayaran saat ini.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: state.confirmationPayments.data!.length,
              itemBuilder: (context, index) {
                final confirm_res.Datum confirmation = state.confirmationPayments.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Konfirmasi Pembayaran dari ${confirmation.laundryName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text('Order ID: ${confirmation.orderId}'),
                        Text('Jumlah: Rp${confirmation.totalFullPrice.toStringAsFixed(0)}'),
                        Text('Tanggal: ${confirmation.updatedAt.toLocal().toIso8601String().split('T')[0]}'),
                        const SizedBox(height: 8),
                        Text(
                          'Catatan: Konfirmasi pembayaran ini telah diterima. Silakan periksa detail pesanan Anda.', // Teks tambahan
                          style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ConfirmationPaymentPelangganError) {
            return Center(
              child: Text(
                'Gagal memuat notifikasi: ${state.message}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(child: Text('Muat ulang untuk melihat notifikasi.'));
        },
      ),
    );
  }
}