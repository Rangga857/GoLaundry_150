import 'package:flutter/material.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/category_pengeluaran_section.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/keuangan_header.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pengeluaran_section.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/pemasukan_section.dart'; // Import PemasukanSection
import 'package:laundry_app/presentation/components/bottom_nav_bar_admin.dart';

class KeuanganAdminScreen extends StatefulWidget {
  const KeuanganAdminScreen({super.key});

  @override
  State<KeuanganAdminScreen> createState() => _KeuanganAdminScreenState();
}

class _KeuanganAdminScreenState extends State<KeuanganAdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: KeuanganHeader(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CategoryPengeluaranSection(),
          PengeluaranSection(),
          PemasukanSection(), 
        ],
      ),
      bottomNavigationBar: const BottomNavBarAdmin(
        selectedIndex: 2, 
      ),
    );
  }
}
