import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart'; 
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_event.dart';

class AddCommentDialog extends StatefulWidget {
  final int orderId;

  const AddCommentDialog({super.key, required this.orderId});

  @override
  State<AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  bool _isCommentEmpty = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    setState(() {
      _isCommentEmpty = _commentController.text.trim().isEmpty;
    });

    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mohon berikan rating bintang terlebih dahulu.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_isCommentEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ulasan tidak boleh kosong.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<CustomerCommentBloc>().add(
          AddNewComment(
            orderId: widget.orderId,
            commentText: _commentController.text.trim(), 
            rating: _rating.toInt(),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), 
      ),
      elevation: 8.0,
      title: Text(
        'Tambah Ulasan',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.primaryBlueDark,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              'Untuk Pesanan ID: ${widget.orderId}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Berikan Rating Anda:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 12), 
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 32.0, 
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded, 
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Tulis Ulasan Anda',
                labelStyle: GoogleFonts.poppins(color: AppColors.grey),
                hintText: 'Misalnya: Pelayanan sangat baik, laundry bersih dan wangi!',
                hintStyle: GoogleFonts.poppins(color: AppColors.lightGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: _isCommentEmpty && _commentController.text.trim().isEmpty
                          ? Colors.red
                          : AppColors.grey.withOpacity(0.7),
                      width: 1),
                ),
                alignLabelWithHint: true,
                errorText: _isCommentEmpty && _commentController.text.trim().isEmpty
                    ? 'Ulasan tidak boleh kosong.'
                    : null,
                errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
              ),
              maxLines: 5, 
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                setState(() {
                  _isCommentEmpty = text.trim().isEmpty;
                });
              },
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(kDefaultPadding),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grey, 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Batal',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          onPressed: (_rating == 0.0 || _commentController.text.trim().isEmpty)
              ? null 
              : _submitComment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue, 
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: AppColors.lightGrey, 
            disabledForegroundColor: AppColors.grey, 
          ),
          child: Text(
            'Kirim Ulasan',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}