import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:laundry_app/core/constants/colors.dart';

class CustomTabClipper extends CustomClipper<Path> {
  final double borderRadius;

  CustomTabClipper({this.borderRadius = 10.0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, borderRadius);
    path.arcToPoint(Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius), clockwise: true);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius), clockwise: true);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class KeuanganHeader extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const KeuanganHeader({super.key, required this.tabController});

  @override
  State<KeuanganHeader> createState() => _KeuanganHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50.0); 
}

class _KeuanganHeaderState extends State<KeuanganHeader> {
  int _currentTabIndex = 0;
  double _tabWidth = 0;
  List<GlobalKey> _tabKeys = [GlobalKey(), GlobalKey(), GlobalKey()]; 

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.tabController.index;
    widget.tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTabWidth();
    });
  }

  void _onTabChanged() {
    if (!widget.tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = widget.tabController.index;
      });
    }
  }

  void _getTabWidth() {
    if (_tabKeys[0].currentContext != null) {
      final RenderBox renderBox = _tabKeys[0].currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _tabWidth = renderBox.size.width;
      });
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double customTabHeight = 50.0;

    return AppBar(
      title: Text(
        'Manajemen Keuangan Admin',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkNavyBlue,
      foregroundColor: AppColors.white,
      elevation: 0, 
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end, 
        children: [
          Container(
            color: AppColors.darkNavyBlue, 
            height: customTabHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0), 
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: _currentTabIndex == 0
                      ? 0
                      : (_currentTabIndex == 1
                          ? (_tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 3)
                          : (_tabWidth > 0 ? _tabWidth * 2 : (MediaQuery.of(context).size.width / 3) * 2)),
                  width: _tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 3, 
                  top: 0,
                  bottom: -20, 
                  child: ClipPath(
                    clipper: CustomTabClipper(borderRadius: 10.0),
                    child: Container(
                      color: AppColors.backgroundLight, 
                      height: customTabHeight + 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        key: _tabKeys[0],
                        onTap: () {
                          widget.tabController.animateTo(0);
                        },
                        child: Container(
                          height: customTabHeight,
                          alignment: Alignment.center,
                          child: Text(
                            'Kategori Pengeluaran',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: _currentTabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                              color: _currentTabIndex == 0 ? AppColors.darkNavyBlue : AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        key: _tabKeys[1],
                        onTap: () {
                          widget.tabController.animateTo(1);
                        },
                        child: Container(
                          height: customTabHeight,
                          alignment: Alignment.center,
                          child: Text(
                            'Pengeluaran',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: _currentTabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                              color: _currentTabIndex == 1 ? AppColors.darkNavyBlue : AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        key: _tabKeys[2],
                        onTap: () {
                          widget.tabController.animateTo(2);
                        },
                        child: Container(
                          height: customTabHeight,
                          alignment: Alignment.center,
                          child: Text(
                            'Pemasukan',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: _currentTabIndex == 2 ? FontWeight.bold : FontWeight.w500,
                              color: _currentTabIndex == 2 ? AppColors.darkNavyBlue : AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}