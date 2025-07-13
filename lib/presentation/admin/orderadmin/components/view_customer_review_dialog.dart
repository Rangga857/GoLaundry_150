import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_state.dart';

class ViewCustomerReviewDialog extends StatefulWidget {
  final int orderId;

  const ViewCustomerReviewDialog({super.key, required this.orderId});

  @override
  State<ViewCustomerReviewDialog> createState() => _ViewCustomerReviewDialogState();
}

class _ViewCustomerReviewDialogState extends State<ViewCustomerReviewDialog> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCommentBloc>().add(GetCommentByOrderId(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Ulasan Pelanggan',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavyBlue,
        ),
      ),
      content: BlocBuilder<AdminCommentBloc, AdminCommentState>(
        builder: (context, state) {
          if (state is AdminCommentLoading) {
            return SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
            );
          } else if (state is AdminCommentSuccess) {
            final comment = state.data.data;
            if (comment == null) {
              return Text(
                'Tidak ada ulasan ditemukan untuk pesanan ini.',
                style: GoogleFonts.poppins(color: AppColors.grey),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan ID: ${widget.orderId}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkNavyBlue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Rating: ',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: AppColors.darkNavyBlue)),
                      RatingBarIndicator(
                        rating: comment.rating.toDouble(),
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: AppColors.customColor2),
                        itemCount: 5,
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        ' (${comment.rating.toInt()})',
                        style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Ulasan:',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: AppColors.darkNavyBlue)),
                  const SizedBox(height: 4),
                  Text(
                    comment.commentText,
                    style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Dibuat pada: ${comment.createdAt.toLocal().toString().split(' ')[0]}',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AdminCommentNotFound) {
            return Text(
              state.message,
              style: GoogleFonts.poppins(color: AppColors.grey),
            );
          } else if (state is AdminCommentFailure) {
            return Text(
              'Gagal memuat ulasan: ${state.error}',
              style: GoogleFonts.poppins(color: AppColors.red),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
}