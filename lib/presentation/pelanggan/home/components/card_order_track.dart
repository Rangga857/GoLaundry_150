import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/response/orderlaundry/my_order_laundries_response_model.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_state.dart';

class OrderStatusCard extends StatefulWidget {
  const OrderStatusCard({super.key});

  @override
  State<OrderStatusCard> createState() => _OrderStatusCardState();
}

class _OrderStatusCardState extends State<OrderStatusCard> {
  final List<Map<String, dynamic>> _statusSteps = const [
    {'status': 'pending', 'label': 'Pesanan Masuk', 'icon': Icons.assignment},
    {'status': 'menuju lokasi', 'label': 'Menuju Lokasi', 'icon': Icons.local_shipping},
    {'status': 'proses penimbangan', 'label': 'Penimbangan', 'icon': Icons.scale},
    {'status': 'proses laundry', 'label': 'Proses Laundry', 'icon': Icons.local_laundry_service},
    {'status': 'proses antar laundry', 'label': 'Pengantaran', 'icon': Icons.delivery_dining},
    {'status': 'selesai', 'label': 'Selesai', 'icon': Icons.check_circle},
  ];

  @override
  void initState() {
    super.initState();
    context.read<PelangganOrderBloc>().add(const GetMyOrdersEvent());
  }

  int _getCurrentStatusIndex(String currentOrderStatus) {
    final lowerCaseStatus = currentOrderStatus.toLowerCase();
    for (int i = 0; i < _statusSteps.length; i++) {
      if (_statusSteps[i]['status'] == lowerCaseStatus) {
        return i;
      }
    }
    return -1;
  }

  Color _getStatusTextColor(String status) {
    return AppColors.primaryBlueDark;
  }

  Color _getStatusBackgroundColor(String status) {
    return AppColors.primaryBlue.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PelangganOrderBloc, PelangganOrderState>(
      listener: (context, state) {
        if (state is PelangganOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is PelangganOrderLoading) {
          return _buildLoadingCard();
        } else if (state is PelangganOrderLoaded) {
          final List<MyOrder> orders = state.ordersList.orders;
          if (orders.isEmpty) {
            return _buildNoOrderCard();
          }

          orders.sort((a, b) => b.id.compareTo(a.id));
          final MyOrder latestOrder = orders.first;

          final currentStatusIndex = _getCurrentStatusIndex(latestOrder.status);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INVOICE #${latestOrder.id}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(latestOrder.status),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        latestOrder.status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: _getStatusTextColor(latestOrder.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_statusSteps.length * 2 - 1, (index) {
                    if (index.isEven) {
                      final stepIndex = index ~/ 2;
                      final isActive = stepIndex <= currentStatusIndex;
                      final isCurrent = stepIndex == currentStatusIndex;

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primaryBlue : AppColors.lightGrey,
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(color: AppColors.primaryBlueDark, width: 2)
                                  : null,
                            ),
                            child: Icon(
                              _statusSteps[stepIndex]['icon'],
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    } else {
                      final prevStepIndex = (index - 1) ~/ 2;
                      final isLineActive = prevStepIndex < currentStatusIndex;

                      return Expanded(
                        child: Container(
                          height: 2,
                          color: isLineActive ? AppColors.primaryBlue : AppColors.lightGrey,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: kDefaultPadding),
                if (latestOrder.pickupAddress.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            latestOrder.pickupAddress,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        } else if (state is PelangganOrderError) {
          return _buildErrorCard(state.message);
        }
        return _buildLoadingCard();
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryBlue),
            const SizedBox(height: 16),
            Text(
              'Memuat status pesanan...',
              style: GoogleFonts.poppins(color: AppColors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOrderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, color: AppColors.grey, size: 40),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan terbaru.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai pesan laundry Anda sekarang!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan: $message',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mohon coba lagi nanti.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.red.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}