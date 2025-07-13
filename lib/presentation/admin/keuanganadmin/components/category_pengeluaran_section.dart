import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/colors.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_event.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_state.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/components/category_pengeluaran_form_dialog.dart';

class CategoryPengeluaranSection extends StatefulWidget {
  const CategoryPengeluaranSection({super.key});

  @override
  State<CategoryPengeluaranSection> createState() => _CategoryPengeluaranSectionState();
}

class _CategoryPengeluaranSectionState extends State<CategoryPengeluaranSection> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryPengeluaranBloc>().add(const GetAllCategoriesPengeluaran());
  }

  void _showAddEditDialog({int? categoryId, String? initialName}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<CategoryPengeluaranBloc>(),
          child: CategoryPengeluaranFormDialog(
            categoryId: categoryId,
            initialName: initialName,
          ),
        );
      },
    );
  }

  void _confirmDelete(int categoryId, String categoryName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Konfirmasi Hapus',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavyBlue,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus kategori "$categoryName"?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grey,
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CategoryPengeluaranBloc>().add(DeleteCategoryPengeluaran(id: categoryId));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                shadowColor: AppColors.red.withOpacity(0.3),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryPengeluaranBloc, CategoryPengeluaranState>(
      listener: (context, state) {
        if (state is CategoryPengeluaranError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        } else if (state is CategoryPengeluaranAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kategori "${state.newCategory.data.nama}" berhasil ditambahkan!')),
          );
        } else if (state is CategoryPengeluaranUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kategori "${state.updatedCategory.nama}" berhasil diperbarui!')),
          );
        } else if (state is CategoryPengeluaranDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kategori berhasil dihapus!')),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoryPengeluaranLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
        } else if (state is CategoryPengeluaranLoaded) {
          if (state.categories.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tidak ada kategori pengeluaran.',
                    style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Tambah Kategori',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Tambah Kategori',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.categories.data.length,
                  itemBuilder: (context, index) {
                    final category = state.categories.data[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: AppColors.cardBackgroundLight,
                      shadowColor: AppColors.darkNavyBlue.withOpacity(0.5),
                      child: ListTile(
                        leading: const Icon(Icons.category, color: AppColors.black87),
                        title: Text(
                          category.nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black87,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${category.pengeluaranCategoryId}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.black87,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.darkNavyBlue),
                              onPressed: () => _showAddEditDialog(
                                categoryId: category.pengeluaranCategoryId,
                                initialName: category.nama,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.red),
                              onPressed: () => _confirmDelete(
                                category.pengeluaranCategoryId,
                                category.nama,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is CategoryPengeluaranError) {
          return Center(
            child: Text(
              'Gagal memuat kategori: ${state.message}',
              style: GoogleFonts.poppins(color: AppColors.red),
            ),
          );
        }
        return Center(
          child: Text(
            'Tekan tombol tambah untuk menambah kategori.',
            style: GoogleFonts.poppins(color: AppColors.grey),
          ),
        );
      },
    );
  }
}