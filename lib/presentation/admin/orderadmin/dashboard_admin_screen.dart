import 'package:flutter/material.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/admin_order_screen.dart';
import 'package:laundry_app/presentation/admin/orderadmin/components/headerdashboard.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_admin.dart';

class OrderAdminScreen extends StatefulWidget {
  const OrderAdminScreen({super.key});

  @override
  State<OrderAdminScreen> createState() => _OrderAdminScreenScreenState();
}

class _OrderAdminScreenScreenState extends State<OrderAdminScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: const Column( 
          children: [
            BodyProfileAdmin(),
            Expanded(
              child: AdminOrderScreen(),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBarAdmin(
          selectedIndex: 1,
        ),
      );
  }
}