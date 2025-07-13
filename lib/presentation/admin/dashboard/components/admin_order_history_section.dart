import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_state.dart';

class AdminOrderHistorySection extends StatelessWidget {
  const AdminOrderHistorySection({super.key});

  Map<String, String> _getAllPossibleStatusesForDisplay() {
    return {
      'pending': 'Menunggu Konfirmasi',
      'menuju lokasi': 'Menuju Lokasi',
      'proses penimbangan': 'Proses Penimbangan',
      'proses laundry': 'Proses Laundry',
      'proses antar laundry': 'Proses Antar Laundry',
      'selesai': 'Selesai',
    };
  }

  String _mapBackendStatusToDashboardStatus(String backendStatus) {
    backendStatus = backendStatus.toLowerCase();
    switch (backendStatus) {
      case 'pending':
        return 'pending';
      case 'menuju lokasi':
        return 'menuju lokasi';
      case 'proses penimbangan':
        return 'proses penimbangan';
      case 'proses laundry':
        return 'proses laundry';
      case 'proses antar laundry':
        return 'proses antar laundry';
      case 'selesai':
        return 'selesai';
      default:
        return 'unknown';
    }
  }

  IconData _getIconForDashboardStatus(String dashboardStatus) {
    switch (dashboardStatus.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'menuju lokasi':
        return Icons.directions_car_outlined;
      case 'proses penimbangan':
        return Icons.scale_outlined;
      case 'proses laundry':
        return Icons.local_laundry_service_outlined;
      case 'proses antar laundry':
        return Icons.delivery_dining_outlined;
      case 'selesai':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Order Pelanggan',
          style: GoogleFonts.poppins( // Applied Poppins font
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        Card(
          color: AppColors.deepTeal,
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
              builder: (context, state) {
                if (state is AdminOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminOrderAllLoaded) {
                  final Map<String, int> orderStatusCounts = {
                    'pending': 0,
                    'menuju lokasi': 0,
                    'proses penimbangan': 0,
                    'proses laundry': 0,
                    'proses antar laundry': 0,
                    'selesai': 0,
                  };

                  for (var order in state.ordersList.orders) {
                    final backendRawStatus = order.status;
                    final dashboardStatus = _mapBackendStatusToDashboardStatus(backendRawStatus);
                    if (orderStatusCounts.containsKey(dashboardStatus)) {
                      orderStatusCounts[dashboardStatus] = (orderStatusCounts[dashboardStatus] ?? 0) + 1;
                    }
                  }

                  final List<String> displayOrderKeys = [
                    'pending',
                    'menuju lokasi',
                    'proses penimbangan',
                    'proses laundry',
                    'proses antar laundry',
                    'selesai',
                  ];

                  return Column(
                    children: displayOrderKeys.map((statusKey) {
                      final count = orderStatusCounts[statusKey] ?? 0;
                      if (!_getAllPossibleStatusesForDisplay().containsKey(statusKey)) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(_getIconForDashboardStatus(statusKey), color: const Color.fromARGB(255, 255, 255, 255)),
                            const SizedBox(width: kDefaultPadding / 2),
                            Expanded(
                              child: Text(
                                _getAllPossibleStatusesForDisplay()[statusKey]!,
                                style: GoogleFonts.poppins( // Applied Poppins font
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '$count Order',
                              style: GoogleFonts.poppins( // Applied Poppins font
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is AdminOrderError) {
                  return Center(
                    child: Text(
                      'Gagal memuat order: ${state.message}',
                      style: GoogleFonts.poppins( // Applied Poppins font
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}