import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'viewmodels/auth/user_auth_viewmodel.dart';
import 'viewmodels/user/user_profile_viewmodel.dart';
import 'viewmodels/user/mybooking_riwayat_viewmodel.dart';
import 'viewmodels/user/booking_viewmodel.dart';
import 'viewmodels/user/kamar_viewmodel.dart';
import 'viewmodels/admin/booking_admin_viewmodel.dart';
import 'viewmodels/admin/data_kamar_viewmodel.dart';
import 'viewmodels/admin/jenis_kamar_viewmodel.dart';
import 'viewmodels/admin/tipe_kasur_viewmodel.dart';
import 'viewmodels/admin/admin_profile_viewmodel.dart';
import 'viewmodels/admin/report_viewmodel.dart';
import 'viewmodels/user/update_password_viewmodel.dart';


void main() {
  runApp(const HotelValoniaApp());
}

class HotelValoniaApp extends StatelessWidget {
  const HotelValoniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => UserProfileViewModel()),
        ChangeNotifierProvider(create: (context) => BookingViewModel()),
        ChangeNotifierProvider(create: (context) => DetailBookingViewModel()),
        ChangeNotifierProvider(create: (context) => KamarViewModel()),
        ChangeNotifierProvider(create: (context) => BookingAdminViewModel()),
        ChangeNotifierProvider(create: (context) => DataKamarViewModel()),
        ChangeNotifierProvider(create: (context) => JenisKamarViewModel()),
        ChangeNotifierProvider(create: (context) => TipeKasurViewModel()),
        ChangeNotifierProvider(create: (context) => AdminProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ReportViewModel()),
        ChangeNotifierProvider(create: (_) => UpdatePasswordViewmodel()),

        // tambahkan provider lain jika diperlukan
      ],
      child: MaterialApp(
        title: 'Hotel Valonia',
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // akan ke SplashScreen sesuai routes Anda
        routes: AppRoutes.routes,
      ),
    );
  }
}
