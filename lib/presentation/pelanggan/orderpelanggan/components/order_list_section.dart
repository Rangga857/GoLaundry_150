import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/model/response/orderlaundry/my_order_laundries_response_model.dart' as my_order_res;
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_state.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/add_comment_dialog.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/add_order_screen.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/confirmation_payment_detail_dialog.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/my_comments_page.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_bloc.dart';

class OrderListSection extends StatefulWidget {
  const OrderListSection({super.key});

  @override
  State<OrderListSection> createState() => _OrderListSectionState();
}

class _OrderListSectionState extends State<OrderListSection> {
  bool _hasPendingOrders = false;

  @override
  void initState() {
    super.initState();
    context.read<PelangganOrderBloc>().add(const GetMyOrdersEvent());
  }

  void _checkPendingOrders(List<my_order_res.MyOrder> orders) {
    bool hasPending = false;
    for (var order in orders) {
      if (order.status != 'Selesai') {
        hasPending = true;
        break;
      }
    }
    if (_hasPendingOrders != hasPending) {
      setState(() {
        _hasPendingOrders = hasPending;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pesanan masuk':
        return Colors.blue.shade700;
      case 'menuju lokasi penjemputan':
        return Colors.orange.shade700;
      case 'penimbangan':
        return Colors.purple.shade700;
      case 'proses laundry':
        return Colors.cyan.shade700;
      case 'pengantaran':
        return Colors.green.shade700;
      case 'selesai':
        return Colors.grey.shade600;
      default:
        return Colors.black;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Expanded( 
                child: ElevatedButton(
                  onPressed: _hasPendingOrders
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pesanan Belum Selesai'),
                                content: const Text('Anda tidak dapat membuat pesanan baru karena masih ada pesanan yang belum selesai.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : () {
                          context.push(const AddOrderScreen());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasPendingOrders ? Colors.red : AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    'Buat Pesanan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10), 
              Expanded( 
                child: TextButton(
                  onPressed: () {
                    context.push(const MyCommentsPage());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    foregroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
                  ),
                  child: Text(
                    'Lihat Ulasan Saya',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600), 
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), 

          BlocConsumer<PelangganOrderBloc, PelangganOrderState>(
            listener: (context, state) {
              if (state is PelangganOrderLoaded) {
                _checkPendingOrders(state.ordersList.orders);
              } else if (state is PelangganOrderAdded) {
                context.read<PelangganOrderBloc>().add(const GetMyOrdersEvent());
              }
            },
            builder: (context, state) {
              if (state is PelangganOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PelangganOrderLoaded) {
                if (state.ordersList.orders.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _checkPendingOrders(state.ordersList.orders);
                  });
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/ls_confirm.png',
                            height: 100,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Anda belum memiliki pesanan laundry.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Buat pesanan pertama Anda sekarang!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.grey.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _checkPendingOrders(state.ordersList.orders);
                });
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.ordersList.orders.length,
                  itemBuilder: (context, index) {
                    final my_order_res.MyOrder order = state.ordersList.orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      color: AppColors.white, 
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding / 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${order.serviceTitle} - ${order.jenisPewangiName}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    order.status,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alamat: ${order.pickupAddress}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: AppColors.grey,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.receipt_long, size: 24, color: AppColors.primaryBlue),
                                  tooltip: 'Lihat Detail Pesanan',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return BlocProvider.value(
                                          value: context.read<ConfirmationPaymentPelangganBloc>(),
                                          child: ConfirmationPaymentDetailDialog(orderId: order.id),
                                        );
                                      },
                                    );
                                  },
                                ),
                                if (order.status == 'Selesai')
                                  IconButton(
                                    icon: const Icon(Icons.rate_review, size: 24, color: AppColors.primaryBlueDark),
                                    tooltip: 'Beri Ulasan',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return BlocProvider.value(
                                            value: context.read<CustomerCommentBloc>(),
                                            child: AddCommentDialog(orderId: order.id),
                                          );
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is PelangganOrderError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _checkPendingOrders([]);
                });
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat pesanan: ${state.message}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkPendingOrders([]);
              });
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 60, color: AppColors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada data pesanan untuk ditampilkan.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}