import 'package:flutter/material.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/order_header.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/components/order_list_section.dart';

class OrderBody extends StatelessWidget {
  const OrderBody({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerHeight = 150 + statusBarHeight;
    final double overlapAmount = 10.0; 

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: headerHeight,
            child: OrderHeader(),
          ),
        ),
        Positioned(
          top: headerHeight - overlapAmount,
          left: 0,
          right: 0,
          bottom: 0, 
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            ),
            clipBehavior: Clip.antiAlias, 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.only(
                  top: kDefaultPadding), 
              child: OrderListSection(),
            ),
          ),
        ),
      ],
    );
  }
}