import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_event.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_state.dart';
import 'package:laundry_app/presentation/pelanggan/payment/view_payment_screen.dart';
import 'package:laundry_app/presentation/picture/camera_page.dart';

enum PaymentMethod {
  cash('cash'), 
  bankTransfer('bank transfer');

  const PaymentMethod(this.displayName);
  final String displayName;
}

class AddPaymentPage extends StatefulWidget {
  final int confirmationPaymentId;

  const AddPaymentPage({
    super.key,
    required this.confirmationPaymentId,
  });

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  PaymentMethod? _selectedMetodePembayaran;
  File? _buktiPembayaranFile;
  final ImagePicker _picker = ImagePicker();


  Future<void> _takePicture() async {
    final File? capturedFile = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (context) => const CameraPage()),
    );

    if (capturedFile != null) {
      setState(() {
        _buktiPembayaranFile = capturedFile;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiPembayaranFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Input Pembayaran',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavyBlue, 
          ),
        ),
        backgroundColor: AppColors.white, 
        iconTheme: const IconThemeData(color: AppColors.darkNavyBlue), 
        centerTitle: true, 
      ),
      body: BlocListener<PembayaranPelangganBloc, PembayaranPelangganState>(
        listener: (context, state) {
          if (state is PaymentAdded) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Pembayaran berhasil ditambahkan! Menunggu konfirmasi admin.',
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: AppColors.darkNavyBlue, 
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyPaymentsPage()),
            );
          } else if (state is PembayaranError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal menambahkan pembayaran: ${state.message}',
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: AppColors.red, 
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is PembayaranLoading) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Mengirim pembayaran...',
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: AppColors.darkNavyBlue.withOpacity(0.8),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: kDefaultPadding),
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                color: AppColors.darkNavyBlue,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Konfirmasi Pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundLight, 
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ID Konfirmasi: ${widget.confirmationPaymentId}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Metode Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavyBlue,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PaymentMethod>(
                value: _selectedMetodePembayaran,
                decoration: InputDecoration(
                  hintText: 'Pilih Metode Pembayaran',
                  hintStyle: GoogleFonts.poppins(color: AppColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.lightGrey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  fillColor: AppColors.white,
                  filled: true,
                ),
                items: PaymentMethod.values.map((PaymentMethod method) {
                  return DropdownMenuItem<PaymentMethod>(
                    value: method,
                    child: Text(
                      method.displayName,
                      style: GoogleFonts.poppins(color: AppColors.black87),
                    ),
                  );
                }).toList(),
                onChanged: (PaymentMethod? newValue) {
                  setState(() {
                    _selectedMetodePembayaran = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Metode pembayaran harus dipilih.';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: AppColors.black87, fontSize: 16), 
                dropdownColor: AppColors.white, 
                iconEnabledColor: AppColors.primaryBlue,
              ),
              const SizedBox(height: 24),
              Text(
                'Bukti Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavyBlue,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: _buktiPembayaranFile == null
                    ? Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.3), 
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightGrey, width: 2), 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 60, color: AppColors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada bukti pembayaran',
                              style: GoogleFonts.poppins(color: AppColors.grey),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _buktiPembayaranFile!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.camera_alt, color: AppColors.darkNavyBlue),
                  label: Text(
                    'Ambil Foto Bukti Pembayaran',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.darkNavyBlue),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavyBlue.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library, color: AppColors.darkNavyBlue),
                  label: Text(
                    'Pilih dari Galeri',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.darkNavyBlue),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavyBlue.withOpacity(0.1),
                    foregroundColor: AppColors.darkNavyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedMetodePembayaran == null) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Metode pembayaran harus dipilih.',
                            style: GoogleFonts.poppins(color: AppColors.white),
                          ),
                          backgroundColor: AppColors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      return;
                    }
                    if (_buktiPembayaranFile == null) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Bukti pembayaran harus dipilih.',
                            style: GoogleFonts.poppins(color: AppColors.white),
                          ),
                          backgroundColor: AppColors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      return;
                    }

                    context.read<PembayaranPelangganBloc>().add(
                          AddPayment(
                            confirmationPaymentId: widget.confirmationPaymentId,
                            metodePembayaran: _selectedMetodePembayaran!.displayName,
                            buktiPembayaran: _buktiPembayaranFile,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavyBlue, 
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: BlocBuilder<PembayaranPelangganBloc, PembayaranPelangganState>(
                    builder: (context, state) {
                      if (state is PembayaranLoading) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        );
                      }
                      return Text(
                        'Kirim Pembayaran',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}