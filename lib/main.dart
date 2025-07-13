import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/authrepository.dart';
import 'package:laundry_app/data/repository/category_pengeluaran_repository.dart';
import 'package:laundry_app/data/repository/commentrepository.dart';
import 'package:laundry_app/data/repository/confirmationpaymentsrepository.dart';
import 'package:laundry_app/data/repository/jenis_pewangi_repository.dart';
import 'package:laundry_app/data/repository/order_repository.dart';
import 'package:laundry_app/data/repository/paymentrepository.dart';
import 'package:laundry_app/data/repository/pemasukan_repository.dart';
import 'package:laundry_app/data/repository/pengeluaran_repository.dart';
import 'package:laundry_app/data/repository/profile_admin_repository.dart';
import 'package:laundry_app/data/repository/profile_pelanggan_repository.dart';
import 'package:laundry_app/data/repository/service_laundry_repository.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/comment/admin_comment_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/confirmationpayments/confirmation_payment_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/getpembayaran/admin_payment_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/order/admin_order_bloc.dart';
import 'package:laundry_app/presentation/admin/orderadmin/bloc/profile/profile_admin_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/category_pengeluaran/category_pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pemasukan/pemasukan_bloc.dart';
import 'package:laundry_app/presentation/admin/keuanganadmin/bloc/pengeluaran/pengeluaran_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/jenis_pewangi_admin/admin_jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/admin/layananlaundryadmin/bloc/service_laundry_admin/admin_service_laundry_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/confirmationpelanggan/confirmation_payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/orderpelanggan/bloc/pelangganorder/pelanggan_order_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/comment/customer_comment_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/payment/bloc/payment/payment_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/welcome_screen.dart';
import 'package:laundry_app/service/service_http_client.dart';
import 'package:laundry_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_bloc.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_event.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/jenis_pewangi_pelanggan/jenis_pewangi_event.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_bloc.dart';
import 'package:laundry_app/presentation/pelanggan/home/bloc/service_laundry_pelanggan/service_laundry_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();
    final AuthRepository authRepository = AuthRepository(serviceHttpClient);
    final ProfilePelangganRepository profilePelangganRepository = ProfilePelangganRepositoryImpl(httpClient: serviceHttpClient);
    final ProfileAdminRepository profileAdminRepository = ProfileAdminRepositoryImpl(httpClient: serviceHttpClient);
    final JenisPewangiRepositoryImpl jenisPewangiRepository = JenisPewangiRepositoryImpl(httpClient: serviceHttpClient);
    final ServiceLaundryRepositoryImpl serviceLaundryRepository = ServiceLaundryRepositoryImpl(httpClient: serviceHttpClient);
    final OrderRepositoryImpl orderRepository = OrderRepositoryImpl(httpClient: serviceHttpClient);
    final ConfirmationPaymentsRepositoryImpl confirmationPaymentsRepository = ConfirmationPaymentsRepositoryImpl(httpClient: serviceHttpClient);
    final PembayaranRepositoryImpl pembayaranRepository = PembayaranRepositoryImpl(httpClient: serviceHttpClient);
    final CommentRepository commentRepository = CommentRepository(serviceHttpClient);
    final CategoryPengeluaranRepository categoryPengeluaranRepository = CategoryPengeluaranRepository(serviceHttpClient);
    final PengeluaranRepository pengeluaranRepository = PengeluaranRepository(serviceHttpClient);
    final PemasukanRepository pemasukanRepository = PemasukanRepository(serviceHttpClient);

    return MultiRepositoryProvider( 
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository), 
        RepositoryProvider<ProfilePelangganRepository>.value(value: profilePelangganRepository),
        RepositoryProvider<ProfileAdminRepository>.value(value: profileAdminRepository),
        RepositoryProvider<JenisPewangiRepositoryImpl>.value(value: jenisPewangiRepository),
        RepositoryProvider<ServiceLaundryRepositoryImpl>.value(value: serviceLaundryRepository),
        RepositoryProvider<OrderRepositoryImpl>.value(value: orderRepository),
        RepositoryProvider<ConfirmationPaymentsRepositoryImpl>.value(value: confirmationPaymentsRepository),
        RepositoryProvider<PembayaranRepositoryImpl>.value(value: pembayaranRepository),
        RepositoryProvider<CommentRepository>.value(value: commentRepository),
        RepositoryProvider<CategoryPengeluaranRepository>.value(value: categoryPengeluaranRepository),
        RepositoryProvider<PengeluaranRepository>.value(value: pengeluaranRepository),
        RepositoryProvider<PemasukanRepository>.value(value: pemasukanRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfilePelangganBloc(
              profilePelangganRepository: context.read<ProfilePelangganRepository>(), 
            ),
          ),
          BlocProvider(
            create: (context) => ProfileAdminBloc(
              profileAdminRepository: context.read<ProfileAdminRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CameraBloc()
              ..add(RequestPermissions())
              ..add(InitializeCamera()),
          ),
          BlocProvider(
            create: (context) => JenisPewangiBloc(
              repository: context.read<JenisPewangiRepositoryImpl>(), 
            )..add(GetJenisPewangiAllEvent()),
          ),
          BlocProvider(
            create: (context) => ServiceLaundryBloc(
              repository: context.read<ServiceLaundryRepositoryImpl>(), 
            )..add(GetServiceLaundryAllEvent()),
          ),
          BlocProvider(
            create: (context) => AdminServiceLaundryBloc(
              repository: context.read<ServiceLaundryRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => AdminJenisPewangiBloc(
              repository: context.read<JenisPewangiRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => AdminOrderBloc(
              repository: context.read<OrderRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => PelangganOrderBloc(
              repository: context.read<OrderRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => ConfirmationPaymentAdminBloc(
              confirmationPaymentsRepository: context.read<ConfirmationPaymentsRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => ConfirmationPaymentPelangganBloc(
              confirmationPaymentsRepository: context.read<ConfirmationPaymentsRepositoryImpl>(), 
            ),
          ),
          BlocProvider(
            create: (context) => PembayaranPelangganBloc(
              pembayaranRepository: context.read<PembayaranRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => AdminPaymentBloc(
              pembayaranRepository: context.read<PembayaranRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerCommentBloc(
              commentRepository: context.read<CommentRepository>(), 
            ),
          ),
          BlocProvider(
            create: (context) => AdminCommentBloc(
              commentRepository: context.read<CommentRepository>(), 
            ),
          ),
          BlocProvider(
            create: (context) => CategoryPengeluaranBloc(
              repository: context.read<CategoryPengeluaranRepository>(), 
            ),
          ),
          BlocProvider(
            create: (context) => PengeluaranBloc(
              repository: context.read<PengeluaranRepository>(), 
            ),
          ),
          BlocProvider(
            create: (context) => PemasukanBloc(
              pemasukanRepository: context.read<PemasukanRepository>(), 
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Laundry App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const WelcomeScreen(),
        ),
      ),
    );
  }
}