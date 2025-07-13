import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/request/orderlaundry/put_order_laundies_request_model.dart';
import 'package:laundry_app/data/model/response/orderlaundry/get_all_orders_response_model.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_state.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/admin_payment_detail_page.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/confirmation_payment_dialog.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/view_confirmation_payment_dialog.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/view_customer_review_dialog.dart';

class AdminOrderItem extends StatefulWidget {
  final Order order;
  final bool isUpdating;

  const AdminOrderItem({
    super.key,
    required this.order,
    this.isUpdating = false,
  });

  @override
  State<AdminOrderItem> createState() => _AdminOrderItemState();
}

class _AdminOrderItemState extends State<AdminOrderItem> {
  String? _selectedStatus;
  final List<String> _statusOptions = const [
    'pending',
    'menuju lokasi',
    'proses penimbangan',
    'proses laundry',
    'proses antar laundry',
    'selesai',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _statusOptions.contains(widget.order.status.toLowerCase())
        ? widget.order.status.toLowerCase()
        : null;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange; 
      case 'menuju lokasi':
        return Colors.blue; 
      case 'proses penimbangan':
        return Colors.purple; 
      case 'proses laundry':
        return Colors.indigo;
      case 'proses antar laundry':
        return Colors.teal; 
      case 'selesai':
        return Colors.green; 
      default:
        return Colors.grey;
    }
  }

  void _showCreateConfirmationPaymentDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateConfirmationPaymentDialog(orderId: orderId);
      },
    );
  }

  void _showViewConfirmationPaymentDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<ConfirmationPaymentAdminBloc>(context),
          child: BlocConsumer<ConfirmationPaymentAdminBloc, ConfirmationPaymentAdminState>(
            listener: (context, state) {
              if (state is SingleConfirmationPaymentLoaded) {
                Navigator.of(dialogContext).pop();
                showDialog(
                  context: context,
                  builder: (_) => ViewConfirmationPaymentDialog(confirmationPayment: state.confirmationPayment),
                );
              } else if (state is SingleConfirmationPaymentError) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: GoogleFonts.poppins(color: AppColors.white),
                    ),
                    backgroundColor: AppColors.red, 
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SingleConfirmationPaymentLoading) {
                return AlertDialog(
                  backgroundColor: AppColors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primaryBlue), 
                      const SizedBox(height: 16),
                      Text(
                        "Memuat detail pembayaran...",
                        style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );

    context.read<ConfirmationPaymentAdminBloc>().add(
          GetSingleConfirmationPaymentForAdmin(orderId: orderId),
        );
  }

  void _showCustomerReviewDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<AdminCommentBloc>(context),
          child: ViewCustomerReviewDialog(orderId: orderId),
        );
      },
    );
  }

  bool _shouldShowPaymentNotification() {
    return widget.order.profileName != 'belum ada';
  }

  @override
  Widget build(BuildContext context) {
    final currentOrderStatus = widget.order.status.toLowerCase();
    final bool canCreatePayment = currentOrderStatus == 'proses penimbangan';
    final bool canViewPayment = [
      'proses penimbangan',
      'proses laundry',
      'proses antar laundry',
      'selesai'
    ].contains(currentOrderStatus);

    final bool canViewReview = currentOrderStatus == 'selesai';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: kDefaultPadding), 
      elevation: 6.0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), 
      color: AppColors.white,
      shadowColor: AppColors.primaryBlue.withOpacity(0.3), 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID Pesanan: ${widget.order.id}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkNavyBlue,
                  ),
                ),
                if (widget.isUpdating)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                    ),
                  ),
                if (_shouldShowPaymentNotification())
                  IconButton(
                    icon: const Icon(Icons.credit_card_sharp, color: AppColors.customColor2), 
                    tooltip: 'Lihat Detail Pembayaran',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDetailPage(paymentId: widget.order.id),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pelanggan: ${widget.order.profileName}',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.darkNavyBlue), 
            ),
            const SizedBox(height: 4),
            Text(
              'Layanan: ${widget.order.serviceTitle} - ${widget.order.jenisPewangiName}',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.darkNavyBlue), 
            ),
            const SizedBox(height: 4),
            Text(
              'Alamat Penjemputan: ${widget.order.pickupAddress}',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey), 
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Status:',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkNavyBlue), // Menggunakan GoogleFonts
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _getStatusColor(_selectedStatus ?? 'default')),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _getStatusColor(_selectedStatus ?? 'default')),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _getStatusColor(_selectedStatus ?? 'default'), width: 2),
                      ),
                      fillColor: AppColors.lightGrey.withOpacity(0.2),
                      filled: true,
                    ),
                    dropdownColor: AppColors.white, 
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status.toUpperCase(),
                          style: GoogleFonts.poppins( 
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null && newValue != _selectedStatus) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                        context.read<AdminOrderBloc>().add(
                              UpdateOrderStatusEvent(
                                id: widget.order.id,
                                request: PutOrdesLaundriesRequestModel(status: newValue),
                              ),
                            );
                      }
                    },
                  ),
                ),
              ],
            ),
            if (canCreatePayment || canViewPayment || canViewReview)
              Padding(
                padding: const EdgeInsets.only(top: 16.0), 
                child: Wrap( 
                  spacing: 10.0, 
                  runSpacing: 10.0, 
                  children: [
                    if (canCreatePayment)
                      ElevatedButton.icon(
                        onPressed: () {
                          _showCreateConfirmationPaymentDialog(context, widget.order.id);
                        },
                        icon: const Icon(Icons.add_card, color: AppColors.white),
                        label: Text('Buat Pembayaran', style: GoogleFonts.poppins(color: AppColors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
                    if (canViewPayment)
                      ElevatedButton.icon(
                        onPressed: () {
                          _showViewConfirmationPaymentDialog(context, widget.order.id);
                        },
                        icon: const Icon(Icons.receipt_long, color: AppColors.white),
                        label: Text('Lihat Confirm Pay', style: GoogleFonts.poppins(color: AppColors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue, 
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
                    if (canViewReview) 
                      ElevatedButton.icon(
                        onPressed: () {
                          _showCustomerReviewDialog(context, widget.order.id);
                        },
                        icon: const Icon(Icons.star, color: AppColors.white), 
                        label: Text('Lihat Review', style: GoogleFonts.poppins(color: AppColors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.customColor2,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}