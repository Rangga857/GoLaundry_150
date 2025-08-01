import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/response/orderlaundry/get_all_orders_response_model.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_state.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/admin_order_item.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  String _selectedFilter = 'All';

  final List<String> _statusOptions = const [
    'All',
    'Pending',
    'Menuju Lokasi',
    'Proses Penimbangan',
    'Proses Laundry',
    'Proses Antar Laundry',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminOrderBloc>().add(const GetAdminOrdersAllEvent());
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

  void _fetchOrders() {
    final AdminOrderState currentBlocState = context.read<AdminOrderBloc>().state;
    String? lastSearchQuery;

    if (currentBlocState is AdminOrderAllLoaded) {
      lastSearchQuery = currentBlocState.lastSearchQuery;
    }

    String? statusFilterToSend = _selectedFilter == 'All' ? null : _selectedFilter.toLowerCase();
    print('Fetching orders with statusFilter: $statusFilterToSend');

    context.read<AdminOrderBloc>().add(
          GetAdminOrdersAllEvent(
            searchQuery: lastSearchQuery,
            statusFilter: statusFilterToSend,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceHeight(30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', Icons.list_alt),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', Icons.pending_actions),
                const SizedBox(width: 8),
                _buildFilterChip('Menuju Lokasi', Icons.location_on),
                const SizedBox(width: 8),
                _buildFilterChip('Proses Penimbangan', Icons.scale),
                const SizedBox(width: 8),
                _buildFilterChip('Proses Laundry', Icons.local_laundry_service),
                const SizedBox(width: 8),
                _buildFilterChip('Proses Antar Laundry', Icons.delivery_dining),
                const SizedBox(width: 8),
                _buildFilterChip('Selesai', Icons.check_circle),
              ],
            ),
          ),
        ),
        const SpaceHeight(kDefaultPadding),
        Expanded(
          child: BlocConsumer<AdminOrderBloc, AdminOrderState>(
            listener: (context, state) {
              if (state is AdminOrderStatusUpdated) {
                _showSnackBar('Status pesanan berhasil diperbarui!', backgroundColor: AppColors.primaryBlue);
                _fetchOrders();
              } else if (state is AdminOrderError) {
                _showSnackBar('Error: ${state.message}', backgroundColor: AppColors.red);
              }
              if (state is AdminOrderAllLoaded && state.lastStatusFilter != null) {
                String stateFilter = state.lastStatusFilter!;
                if (_statusOptions.map((e) => e.toLowerCase()).contains(stateFilter.toLowerCase()) || stateFilter == 'all') {
                  setState(() {
                    _selectedFilter = stateFilter == 'all' ? 'All' : stateFilter.substring(0, 1).toUpperCase() + stateFilter.substring(1).toLowerCase();
                  });
                }
              }
            },
            builder: (context, state) {
              if (state is AdminOrderLoading || state is AdminOrderInitial) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
              } else if (state is AdminOrderAllLoaded) {
                final List<Order> orders = state.ordersList.orders;

                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada pesanan laundry yang ditemukan.',
                      style: GoogleFonts.poppins(color: AppColors.grey, fontSize: 16),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchOrders();
                  },
                  color: AppColors.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return AdminOrderItem(order: order);
                    },
                  ),
                );
              } else if (state is AdminOrderError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gagal memuat pesanan: ${state.message}',
                        style: GoogleFonts.poppins(color: AppColors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _fetchOrders();
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
              return Center(
                child: Text(
                  'Geser ke bawah untuk memuat pesanan.',
                  style: GoogleFonts.poppins(color: AppColors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String status, IconData icon) {
    final bool isSelected = _selectedFilter.toLowerCase() == status.toLowerCase();
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
        _fetchOrders();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.lightGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.white : AppColors.darkSlateBlue,
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? AppColors.white : AppColors.darkSlateBlue,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}