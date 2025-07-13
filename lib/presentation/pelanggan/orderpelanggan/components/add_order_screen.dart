import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/components/custom_dropdown.dart';
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/data/model/request/orderlaundry/order_laundries_request_model.dart';
import 'package:laundry_app/data/model/response/jenispewangi/get_all_jenis_pewangi_response_model.dart';
import 'package:laundry_app/data/model/response/servicelaundry/get_all_service_laundry_response_model.dart';
import 'package:laundry_app/presentation/maps/maps_page.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_state.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_state.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_event.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_state.dart';
import 'package:laundry_app/core/components/selection_card.dart';


class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TextEditingController _addressController = TextEditingController();
  DatumPewangi? _selectedJenisPewangi; 
  DatumService? _selectedService;
  double? _pickupLatitude;
  double? _pickupLongitude;

  List<DatumPewangi> _jenisPewangiList = [];
  List<DatumService> _serviceLaundryList = [];

  final _formKey = GlobalKey<FormState>(); 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _selectLocationOnMap() async {
    final result = await context.push<Map<String, dynamic>>(const MapsPage());

    if (result != null) {
      setState(() {
        _addressController.text = result['address'] as String;
        _pickupLatitude = (result['latitude'] is num) ? (result['latitude'] as num).toDouble() : double.tryParse(result['latitude'].toString());
        _pickupLongitude = (result['longitude'] is num) ? (result['longitude'] as num).toDouble() : double.tryParse(result['longitude'].toString());
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lokasi dipilih: ${result['address']}',
            style: GoogleFonts.poppins(color: AppColors.white),
          ),
          backgroundColor: AppColors.darkSlateBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) { 
      if (_selectedJenisPewangi == null || _selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Harap lengkapi semua pilihan dropdown.',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      if (_pickupLatitude == null || _pickupLatitude == 0.0 ||
          _pickupLongitude == null || _pickupLongitude == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Harap pilih lokasi penjemputan dari peta.',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      final request = OrderLaundriesRequestModel(
        jenisPewangiName: _selectedJenisPewangi!.nama,
        serviceName: _selectedService!.title,
        pickupAddress: _addressController.text,
        pickupLatitude: _pickupLatitude!,
        pickupLongitude: _pickupLongitude!,
      );

      context.read<PelangganOrderBloc>().add(AddOrderEvent(request: request));
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Harap lengkapi semua data pesanan.',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Pesanan Baru',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.darkNavyBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
      ),
      body: BlocListener<PelangganOrderBloc, PelangganOrderState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (state is PelangganOrderLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Membuat pesanan...',
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: AppColors.darkNavyBlue.withOpacity(0.8),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is PelangganOrderAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Pesanan berhasil dibuat!",
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            context.read<PelangganOrderBloc>().add(const GetMyOrdersEvent());
            context.pop();
          } else if (state is PelangganOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.message}',
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form( 
            key: _formKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<JenisPewangiBloc, JenisPewangiState>(
                  builder: (context, state) {
                    if (state is JenisPewangiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is JenisPewangiAllLoaded) {
                      _jenisPewangiList = state.jenisPewangiList.data;
                      return CustomSelectionCardDropdown<DatumPewangi>(
                        label: 'Pilih Jenis Pewangi',
                        dialogTitle: 'Pilih Pewangi Favoritmu!',
                        hintText: 'Pilih jenis pewangi',
                        value: _selectedJenisPewangi,
                        items: _jenisPewangiList,
                        selectedDisplayText: _selectedJenisPewangi?.nama, 
                        onChanged: (value) {
                          setState(() {
                            _selectedJenisPewangi = value;
                          });
                        },
                        itemBuilder: (pewangi, isSelected, onTap) {
                          return SelectionCard(
                            title: pewangi.nama,
                            description: pewangi.deskripsi,
                            priceOrDetails: '', 
                            icon: Icons.water_drop_outlined, 
                            isSelected: isSelected,
                            onTap: onTap,
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Jenis pewangi harus dipilih';
                          }
                          return null;
                        },
                      );
                    } else if (state is JenisPewangiError) {
                      return Text(
                        'Error memuat pewangi: ${state.message}',
                        style: GoogleFonts.poppins(color: AppColors.red),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SpaceHeight(24.0),

                BlocBuilder<ServiceLaundryBloc, ServiceLaundryState>(
                  builder: (context, state) {
                    if (state is ServiceLaundryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ServiceLaundryAllLoaded) {
                      _serviceLaundryList = state.serviceLaundryList.data;
                      return CustomSelectionCardDropdown<DatumService>(
                        label: 'Pilih Layanan Laundry',
                        dialogTitle: 'Pilih Layanan Laundry',
                        hintText: 'Pilih layanan laundry',
                        value: _selectedService,
                        items: _serviceLaundryList,
                        selectedDisplayText: _selectedService != null
                            ? '${_selectedService!.title} - Rp${_selectedService!.pricePerKg}/Kg'
                            : null, 
                        onChanged: (value) {
                          setState(() {
                            _selectedService = value;
                          });
                        },
                        itemBuilder: (service, isSelected, onTap) {
                          return SelectionCard(
                            title: service.title,
                            description: service.subTitle,
                            priceOrDetails: 'Rp${service.pricePerKg}/Kg',
                            icon: Icons.local_laundry_service_outlined, 
                            isSelected: isSelected,
                            onTap: onTap,
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Layanan laundry harus dipilih';
                          }
                          return null;
                        },
                      );
                    } else if (state is ServiceLaundryError) {
                      return Text(
                        'Error memuat layanan: ${state.message}',
                        style: GoogleFonts.poppins(color: AppColors.red),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SpaceHeight(24.0),

                Text(
                  'Alamat Penjemputan',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black87,
                  ),
                ),
                const SpaceHeight(8.0),
                TextFormField(
                  controller: _addressController,
                  readOnly: true,
                  style: GoogleFonts.poppins(color: AppColors.black87),
                  decoration: InputDecoration(
                    hintText: 'Pilih alamat dari peta',
                    hintStyle: GoogleFonts.poppins(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map_outlined, color: AppColors.primaryBlue, size: 28),
                      onPressed: _selectLocationOnMap,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat penjemputan harus diisi';
                    }
                    if (_pickupLatitude == null || _pickupLatitude == 0.0 ||
                        _pickupLongitude == null || _pickupLongitude == 0.0) {
                      return 'Harap pilih lokasi yang valid dari peta';
                    }
                    return null;
                  },
                ),
                const SpaceHeight(32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon( 
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavyBlue,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                    ),
                    label: Text(
                      'Buat Pesanan',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}