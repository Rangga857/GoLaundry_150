import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_state.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_event.dart'; // <--- IMPORT EVENT
import 'package:laundry_app/presentation/pelanggan/home/components/card_jenis_pewangi.dart';
import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';
import 'package:laundry_app/core/constants/constants.dart';

class JenisPewangiSection extends StatefulWidget {
  const JenisPewangiSection({super.key});

  @override
  State<JenisPewangiSection> createState() => _JenisPewangiSectionState();
}

class _JenisPewangiSectionState extends State<JenisPewangiSection> { 
  @override
  void initState() {
    super.initState();
    context.read<JenisPewangiBloc>().add(GetJenisPewangiAllEvent());
    print('JenisPewangiSection: GetJenisPewangiAllEvent dispatched from initState!'); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              Text(
                'Pilih Pewangi Favoritmu!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        BlocBuilder<JenisPewangiBloc, JenisPewangiState>(
          builder: (context, state) {
            if (state is JenisPewangiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JenisPewangiAllLoaded) {
              if (state.jenisPewangiList.data.isEmpty) {
                return const Center(child: Text('Tidak ada jenis pewangi tersedia.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.jenisPewangiList.data.length,
                itemBuilder: (context, index) {
                  final DatumPewangi pewangi = state.jenisPewangiList.data[index];
                  return CardJenisPewangi(
                    name: pewangi.nama,
                    description: pewangi.deskripsi,
                    id: pewangi.id,
                  );
                },
              );
            } else if (state is JenisPewangiError) {
              return Center(
                child: Text(
                  'Gagal memuat jenis pewangi: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const Center(child: Text('Tekan untuk memuat jenis pewangi.'));
          },
        ),
      ],
    );
  }
}