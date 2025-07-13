import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/card_order_track.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/header_home.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/jenis_pewangi.dart';
import 'package:laundry_app/presentation/pelanggan/home/components/service_laundry.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const HeaderHome(),
              const Positioned(
                top: 220,
                left: 0,
                right: 0,
                child: OrderStatusCard(),
              ),
            ],
          ),
          const SizedBox(height: 110),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ServiceLaundrySection(),
                SizedBox(height: kDefaultPadding * 2),
                JenisPewangiSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}