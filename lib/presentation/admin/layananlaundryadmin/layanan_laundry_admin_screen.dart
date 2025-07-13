import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/core/constants/constants.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_event.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/add_pewangi_tab.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/add_service_tab.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/pewangi_list_tab.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/components/service_list_tab.dart';
import 'package:laundry_app/presentation/components/bottom_nav_bar_admin.dart';

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

class LayananLaundryAdminScreen extends StatefulWidget {
  const LayananLaundryAdminScreen({super.key});

  @override
  State<LayananLaundryAdminScreen> createState() => _LayananLaundryAdminScreenState();
}

class _LayananLaundryAdminScreenState extends State<LayananLaundryAdminScreen> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _serviceSubTabController;
  late TabController _pewangiSubTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _serviceSubTabController = TabController(length: 2, vsync: this);
    _pewangiSubTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _serviceSubTabController.dispose();
    _pewangiSubTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Manajemen Admin Layanan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkNavyBlue,
        foregroundColor: AppColors.darkNavyBlue,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 4.0), 
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkNavyBlue, 
              border: Border(
                bottom: BorderSide(
                  color: AppColors.darkNavyBlue,
                  width: 2.0, 
                ),
              ),
            ),
            child: TabBar(
              controller: _mainTabController,
              indicatorColor: AppColors.darkNavyBlue, 
              indicatorWeight: 4.0, 
              indicatorSize: TabBarIndicatorSize.label, 
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white.withOpacity(0.7),
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Layanan Laundry'),
                Tab(text: 'Jenis Pewangi'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          _ServiceLaundryManagementWidget(
            subTabController: _serviceSubTabController,
          ),
          _JenisPewangiManagementWidget(
            subTabController: _pewangiSubTabController,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarAdmin(
        selectedIndex: 3,
      ),
    );
  }
}
class _ServiceLaundryManagementWidget extends StatefulWidget {
  final TabController subTabController;

  const _ServiceLaundryManagementWidget({
    required this.subTabController,
  });

  @override
  State<_ServiceLaundryManagementWidget> createState() => _ServiceLaundryManagementWidgetState();
}

class _ServiceLaundryManagementWidgetState extends State<_ServiceLaundryManagementWidget> {
  int _currentSubTabIndex = 0;
  double _tabWidth = 0;
  final List<GlobalKey> _tabKeys = [GlobalKey(), GlobalKey()];

  void _onSubTabChanged() {
    if (!widget.subTabController.indexIsChanging) {
      setState(() {
        _currentSubTabIndex = widget.subTabController.index;
      });
      if (_currentSubTabIndex == 0) {
        context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSubTabIndex = widget.subTabController.index;
    widget.subTabController.addListener(_onSubTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTabWidth();
    });

    if (_currentSubTabIndex == 0) {
      context.read<AdminServiceLaundryBloc>().add(GetAdminServiceLaundryAllEvent());
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
    widget.subTabController.removeListener(_onSubTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double customTabHeight = 50.0;
    const double blobExtensionHeight = 20.0;

    return Column(
      children: [
        Container(
          color: AppColors.darkNavyBlue,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: customTabHeight, 
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _currentSubTabIndex == 0 ? 0 : (_tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 2 - kDefaultPadding),
                width: _tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 2 - kDefaultPadding,
                top: 0,
                bottom: -blobExtensionHeight,
                child: ClipPath(
                  clipper: CustomTabClipper(borderRadius: 10.0),
                  child: Container(
                    color: AppColors.white,
                    height: customTabHeight + blobExtensionHeight,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      key: _tabKeys[0], 
                      onTap: () {
                        widget.subTabController.animateTo(0);
                      },
                      child: Container(
                        height: customTabHeight,
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            fontWeight: _currentSubTabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                            color: _currentSubTabIndex == 0 ? AppColors.primaryBlue : AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      key: _tabKeys[1], // Key for 'Tambah' tab
                      onTap: () {
                        widget.subTabController.animateTo(1);
                      },
                      child: Container(
                        height: customTabHeight, 
                        alignment: Alignment.center,
                        child: Text(
                          'Tambah',
                          style: GoogleFonts.poppins(
                            fontWeight: _currentSubTabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                            color: _currentSubTabIndex == 1 ? AppColors.primaryBlue : AppColors.white,
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
        Expanded(
          child: TabBarView(
            controller: widget.subTabController,
            children: const [
              ServiceListTab(),
              AddServiceTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _JenisPewangiManagementWidget extends StatefulWidget {
  final TabController subTabController;

  const _JenisPewangiManagementWidget({
    required this.subTabController,
  });

  @override
  State<_JenisPewangiManagementWidget> createState() => _JenisPewangiManagementWidgetState();
}

class _JenisPewangiManagementWidgetState extends State<_JenisPewangiManagementWidget> {
  int _currentSubTabIndex = 0;
  double _tabWidth = 0;
  List<GlobalKey> _tabKeys = [GlobalKey(), GlobalKey()];

  void _onSubTabChanged() {
    if (!widget.subTabController.indexIsChanging) {
      setState(() {
        _currentSubTabIndex = widget.subTabController.index;
      });
      if (_currentSubTabIndex == 0) {
        context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSubTabIndex = widget.subTabController.index;
    widget.subTabController.addListener(_onSubTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTabWidth();
    });

    if (_currentSubTabIndex == 0) {
      context.read<AdminJenisPewangiBloc>().add(GetAdminJenisPewangiAllEvent());
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
    widget.subTabController.removeListener(_onSubTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double customTabHeight = 50.0;
    const double blobExtensionHeight = 20.0;

    return Column(
      children: [
        Container(
          color: AppColors.darkNavyBlue,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: customTabHeight,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _currentSubTabIndex == 0 ? 0 : (_tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 2 - kDefaultPadding),
                width: _tabWidth > 0 ? _tabWidth : MediaQuery.of(context).size.width / 2 - kDefaultPadding,
                top: 0,
                bottom: -blobExtensionHeight,
                child: ClipPath(
                  clipper: CustomTabClipper(borderRadius: 10.0),
                  child: Container(
                    color: AppColors.white,
                    height: customTabHeight + blobExtensionHeight,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      key: _tabKeys[0],
                      onTap: () {
                        widget.subTabController.animateTo(0);
                      },
                      child: Container(
                        height: customTabHeight,
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            fontWeight: _currentSubTabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                            color: _currentSubTabIndex == 0 ? AppColors.primaryBlue : AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      key: _tabKeys[1],
                      onTap: () {
                        widget.subTabController.animateTo(1);
                      },
                      child: Container(
                        height: customTabHeight,
                        alignment: Alignment.center,
                        child: Text(
                          'Tambah',
                          style: GoogleFonts.poppins(
                            fontWeight: _currentSubTabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                            color: _currentSubTabIndex == 1 ? AppColors.primaryBlue : AppColors.white,
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
        Expanded(
          child: TabBarView(
            controller: widget.subTabController,
            children: const [
              PewangiListTab(),
              AddPewangiTab(),
            ],
          ),
        ),
      ],
    );
  }
}