import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry_app/data/repository/authrepository.dart';
import 'package:laundry_app/data/repository/profileadminrepository.dart/profile_admin_repository.dart';
import 'package:laundry_app/presentation/welcome_screen.dart';
import 'package:laundry_app/service/service_http_client.dart';
import 'package:laundry_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:laundry_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:laundry_app/data/repository/profilepelangganrepository/profile_pelanggan_repository.dart';
import 'package:laundry_app/presentation/pelanggan/profilepelanggan/bloc/profile_pelanggan_bloc.dart';
import 'package:laundry_app/presentation/picture/bloc/camera_bloc.dart'; 
import 'package:laundry_app/presentation/picture/bloc/camera_event.dart';
import 'package:laundry_app/presentation/admin/profileadmin/bloc/profile_admin_bloc.dart'; 


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


    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProfilePelangganBloc(
            profilePelangganRepository: profilePelangganRepository,
          ),
        ),
        // --- PENAMBAHAN BLOC BARU UNTUK ADMIN PROFILE ---
        BlocProvider(
          create: (context) => ProfileAdminBloc(
            profileAdminRepository: profileAdminRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CameraBloc()
            ..add(RequestPermissions()) 
            ..add(InitializeCamera()),
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
    );
  }
}
