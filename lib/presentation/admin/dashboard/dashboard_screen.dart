import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/data/repository/authrepository.dart';
import 'package:laundry_app/presentation/admin/dashboard/components/admin_order_history_section.dart';
import 'package:laundry_app/presentation/admin/dashboard/components/admin_summary_card.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_event.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_event.dart';
import 'package:laundry_app/presentation/auth/login_screen.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_admin.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_event.dart';


class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileAdminBloc>().add(GetProfileAdminEvent());
    context.read<PemasukanBloc>().add(const LoadPemasukan());
    context.read<PengeluaranBloc>().add(const GetAllPengeluaran());
    context.read<AdminOrderBloc>().add(const GetAdminOrdersAllEvent());
  }

  void _handleLogout() async {
    final authRepository = context.read<AuthRepository>();
    final result = await authRepository.logout();

    result.fold(
      (errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout gagal: $errorMessage')),
        );
        print('Logout gagal: $errorMessage');
      },
      (successMessage) {
        print('Logout berhasil: $successMessage');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double kMinAppBarHeight = kToolbarHeight;
    final double kMaxAppBarHeight = MediaQuery.of(context).size.height * 0.35;
    const double desiredOverlap = 50.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/gambar3.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: kMaxAppBarHeight,
                collapsedHeight: kMinAppBarHeight,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).padding.top + kDefaultPadding / 2,
                        right: kDefaultPadding,
                        child: CircleAvatar(
                          backgroundColor: AppColors.black87.withOpacity(0.4),
                          child: IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                            onPressed: _handleLogout,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0.0, -desiredOverlap),
                  child: Container(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.8), // Using 0.8 opacity for a slight see-through effect
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: const AdminSummaryCard(),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: const AdminOrderHistorySection(),
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarAdmin(
        selectedIndex: 0,
      ),
    );
  }
}