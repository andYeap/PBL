import 'package:admin_pegawai/providers/akademik_provider.dart';
import 'package:admin_pegawai/providers/auth_provider.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:admin_pegawai/screens/admin_dashboard_screen.dart';
import 'package:admin_pegawai/screens/akademik_screen.dart';
import 'package:admin_pegawai/screens/auth_screen.dart';
import 'package:admin_pegawai/screens/admin_main_screen.dart';
import 'package:admin_pegawai/screens/admin_super_main_screen.dart';
import 'package:admin_pegawai/screens/detail_kelas_screen.dart';
import 'package:admin_pegawai/screens/detail_kurikulum_screen.dart';
import 'package:admin_pegawai/screens/detail_screen.dart';
import 'package:admin_pegawai/screens/detail_tahun_akademik_screen.dart';
import 'package:admin_pegawai/screens/kelas_screen.dart';
import 'package:admin_pegawai/screens/kurikulum_screen.dart';
import 'package:admin_pegawai/screens/pegawai_screen.dart';
import 'package:admin_pegawai/screens/reset_screen.dart';
import 'package:admin_pegawai/screens/super_dashboard_screen.dart';
import 'package:admin_pegawai/screens/tahun_akademik_screen.dart';
import 'package:admin_pegawai/screens/matakuliah_screen.dart ';
import 'package:admin_pegawai/screens/matakuliah_detail_screen.dart';
import 'package:admin_pegawai/screens/matakuliah_edit_screen.dart';
import 'package:admin_pegawai/utils/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  String? token = await TokenManager.getAccessToken();
  Widget initialScreen = const AuthScreen();

  if (token != null && !JwtDecoder.isExpired(token)) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String role =
          decodedToken['role_name'] ?? decodedToken['role'] ?? 'admin';

      String cleanRole = role
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('_', '')
          .replaceAll('-', '');

      if (cleanRole == 'superadmin') {
        initialScreen = const SuperScreen();
      } else {
        initialScreen = const AdminScreen();
      }
    } catch (e) {
      debugPrint("Error decoding token: $e");
      initialScreen = const AuthScreen();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AkademikProvider()),
      ],
      child: MainApp(screen: initialScreen),
    ),
  );
}

class MainApp extends StatelessWidget {
  final Widget screen;
  const MainApp({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screen,
      routes: {
        "/login": (context) => const AuthScreen(),
        "/dashboard-admin": (context) => const AdminDashboard(),
        "/dashboard-super-admin": (context) => const SuperDashboard(),
        "/detail-akun": (context) => const DetailAkunScreen(),
        "/reset-screen": (context) => ResetScreen(),
        "/akademik": (context) => const AkademikScreen(),
        "/tahun-akademik": (context) => const TahunAkademikScreen(),
        "/detail-tahun-akademik": (context) =>
            const DetailTahunAkademikScreen(),
        "/kurikulum": (context) => const KurikulumScreen(),
        "/detail-kurikulum": (context) => const DetailKurikulumScreen(),
        "/kelas": (context) => const KelasScreen(),
        "/detail-kelas": (context) => const DetailKelasScreen(),

        "/matakuliah": (context) => const MatakuliahListScreen(),
        "/matakuliah-detail": (context) => const MatakuliahDetailScreen(),
        "/matakuliah-edit": (context) => const MatakuliahEditScreen(),
      },
    );
  }
}
