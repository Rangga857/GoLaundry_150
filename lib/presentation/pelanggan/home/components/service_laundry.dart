import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_state.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/card_service_laundry.dart';

class ServiceLaundrySection extends StatelessWidget {
  const ServiceLaundrySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredCardWidth = screenWidth * 0.50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              Text(
                'Layanan Laundry',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black87),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/ls_verify.png', 
                height: 100,
              ),
            ],
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        BlocBuilder<ServiceLaundryBloc, ServiceLaundryState>(
          builder: (context, state) {
            if (state is ServiceLaundryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceLaundryAllLoaded) {
              if (state.serviceLaundryList.data.isEmpty) { 
                return const Center(child: Text('Tidak ada layanan laundry tersedia.'));
              }
              return SizedBox(
                height: 200,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: kDefaultPadding / 2,
                    crossAxisSpacing: 0,
                    childAspectRatio: desiredCardWidth / 180,
                  ),
                  itemCount: state.serviceLaundryList.data.length, 
                  itemBuilder: (context, index) {
                    final DatumService service = state.serviceLaundryList.data[index]; 
                    return CardServiceLaundry(serviceLaundry: service);
                  },
                ),
              );
            } else if (state is ServiceLaundryError) {
              return Center(
                child: Text(
                  'Gagal memuat layanan laundry: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const Center(child: Text('Tekan untuk memuat layanan laundry.'));
          },
        ),
      ],
    );
  }
}