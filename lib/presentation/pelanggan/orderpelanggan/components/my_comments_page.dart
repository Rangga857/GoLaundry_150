import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/response/comment/my_comment_response_model.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_event.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_state.dart';

class MyCommentsPage extends StatefulWidget {
  const MyCommentsPage({super.key});

  @override
  State<MyCommentsPage> createState() => _MyCommentsPageState();
}

class _MyCommentsPageState extends State<MyCommentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerCommentBloc>().add(GetMyComments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue, 
      appBar: AppBar(
        title: Text(
          'Ulasan Saya',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.darkNavyBlue,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 2.0,
        iconTheme: const IconThemeData(color: AppColors.darkNavyBlue),
      ),
      body: BlocConsumer<CustomerCommentBloc, CustomerCommentState>(
        listener: (context, state) {
          if (state is CustomerCommentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          } else if (state is CustomerCommentEmpty) {
          }
        },
        builder: (context, state) {
          if (state is CustomerCommentLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.white));
          } else if (state is CustomerCommentSuccess) {
            if (state.data is MyCommentResponseModel) {
              final MyCommentResponseModel commentsResponse = state.data;
              if (commentsResponse.data.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ls_confirm.png', 
                          height: 150,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Anda belum memiliki ulasan.',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white, 
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bagikan pengalaman Anda setelah pesanan selesai!',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.white.withOpacity(0.8), 
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(kDefaultPadding),
                itemCount: commentsResponse.data.length,
                itemBuilder: (context, index) {
                  final Datum comment = commentsResponse.data[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: kDefaultPadding),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), 
                    color: AppColors.white, // Card remains white
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding + 4), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pesanan ID: ${comment.orderId}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17, 
                                  color: AppColors.primaryBlueDark,
                                ),
                              ),
                              if (comment.orderStatus.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkNavyBlue.withOpacity(0.15), // Slightly more opaque
                                    borderRadius: BorderRadius.circular(8), // More rounded status tag
                                  ),
                                  child: Text(
                                    comment.orderStatus,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Laundri: ${comment.customerProfileName}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Rating: ',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.black87),
                              ),
                              RatingBarIndicator(
                                rating: comment.rating.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 24.0, 
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${comment.rating.toInt()})',
                                style: GoogleFonts.poppins(
                                  fontSize: 15, 
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            comment.commentText,
                            style: GoogleFonts.poppins(
                              fontSize: 16, 
                              color: AppColors.black87,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Dibuat pada: ${comment.createdAt.toLocal().toString().split(' ')[0]}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is CustomerCommentEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ls_confirm.png', 
                      height: 150,
                      color: AppColors.white.withOpacity(0.8), 
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Anda belum memiliki ulasan.',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bagikan pengalaman Anda setelah pesanan selesai!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CustomerCommentFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 80, color: AppColors.white),
                    const SizedBox(height: 24),
                    Text(
                      'Terjadi kesalahan saat memuat ulasan:',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 80, color: AppColors.white),
                  const SizedBox(height: 24),
                  Text(
                    'Tekan tombol untuk memuat ulasan Anda.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pastikan koneksi internet Anda stabil.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}