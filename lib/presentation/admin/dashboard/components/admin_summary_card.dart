import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/core/extensions/build_context_ext.dart';
import 'package:laundry_app/presentation/admin/dashboard/components/admin_profile_input.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_state.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_state.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_state.dart';

class AdminSummaryCard extends StatelessWidget {
  const AdminSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileAdminBloc, ProfileAdminState>(
              builder: (context, state) {
                String adminName = 'Admin';
                String adminAddress = 'Alamat Tidak Diketahui';
                dynamic _currentProfileData; // Variable to hold profile data for navigation

                if (state is ProfileAdminLoading) {
                  adminName = 'Memuat...';
                } else if (state is ProfileAdminLoaded) {
                  adminName = state.profile.data?.name ?? 'Admin';
                  adminAddress = state.profile.data?.address ?? 'Alamat Tidak Diketahui';
                  _currentProfileData = state.profile.data; // Assign loaded profile data
                } else if (state is ProfileAdminError) {
                  adminName = 'Error';
                  adminAddress = 'Gagal memuat alamat';
                }

                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(Icons.person_outline, size: 40, color: AppColors.darkNavyBlue),
                    const SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $adminName',
                            style: GoogleFonts.poppins( // Applied Poppins font
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black87,
                            ),
                          ),
                          Text(
                            adminAddress,
                            style: GoogleFonts.poppins( // Applied Poppins font
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Added IconButton here
                    IconButton(
                      icon: const Icon(Icons.settings, color: AppColors.darkNavyBlue, size: 28),
                      onPressed: () {
                        context.push(
                          AdminProfileInputScreen(
                            initialProfileData: _currentProfileData,
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: kDefaultPadding * 1.5),

            Row(
              children: [
                Expanded(
                  child: _buildFinancialSummaryItem(
                    context: context,
                    label: 'Total Pemasukan',
                    bloc: context.watch<PemasukanBloc>(),
                    builder: (pemasukanState) {
                      if (pemasukanState is PemasukanLoaded) {
                        return currencyFormatter.format(pemasukanState.totalPemasukanData?.grandTotalPemasukan ?? 0.0);
                      } else if (pemasukanState is PemasukanLoading) {
                        return 'Memuat...';
                      }
                      return 'N/A';
                    },
                  ),
                ),
                const SizedBox(width: kDefaultPadding),
                Expanded(
                  child: _buildFinancialSummaryItem(
                    context: context,
                    label: 'Total Pengeluaran',
                    bloc: context.watch<PengeluaranBloc>(),
                    builder: (pengeluaranState) {
                      if (pengeluaranState is PengeluaranLoaded) {
                        double total = pengeluaranState.pengeluaranList.data.fold(0.0, (sum, item) {
                          final num? amount = item.jumlahPengeluaran;
                          return sum + (amount?.toDouble() ?? 0.0);
                        });
                        return currencyFormatter.format(total);
                      } else if (pengeluaranState is PengeluaranLoading) {
                        return 'Memuat...';
                      }
                      return 'N/A';
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryItem<T extends StateStreamable<dynamic>>({
    required BuildContext context,
    required String label,
    required T bloc,
    required String Function(dynamic state) builder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins( // Applied Poppins font
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        BlocBuilder<T, dynamic>(
          bloc: bloc,
          builder: (context, state) {
            return Text(
              builder(state),
              style: GoogleFonts.poppins( // Applied Poppins font
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavyBlue,
              ),
            );
          },
        ),
      ],
    );
  }
}