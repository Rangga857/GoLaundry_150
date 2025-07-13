import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/components/spaces_height.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';

class BodyProfileAdmin extends StatefulWidget {
  const BodyProfileAdmin({super.key});

  @override
  State<BodyProfileAdmin> createState() => _BodyProfileAdminState();
}

class _BodyProfileAdminState extends State<BodyProfileAdmin> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    context.read<AdminOrderBloc>().add(
          GetAdminOrdersAllEvent(
            searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(kDefaultPadding, 16.0 + topPadding, kDefaultPadding, 12.0),
          height: 180 + topPadding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.deepTeal, AppColors.darkNavyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceHeight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Management',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment, 
                      color: AppColors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: kDefaultPadding,
          right: kDefaultPadding,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: TextFormField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: AppColors.darkNavyBlue),
              decoration: InputDecoration(
                hintText: 'Cari pesanan berdasarkan nama pelanggan',
                hintStyle: GoogleFonts.poppins(color: AppColors.grey), 
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                _triggerSearch();
              },
              onFieldSubmitted: (value) {
                _triggerSearch();
              },
            ),
          ),
        ),
      ],
    );
  }
}