import 'package:admin_pegawai/providers/akademik_provider.dart';
import 'package:admin_pegawai/providers/auth_provider.dart';
import 'package:admin_pegawai/providers/kelas_provider.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:admin_pegawai/providers/prodi_provider.dart';
import 'package:admin_pegawai/providers/jurusan_provider.dart';
import 'package:admin_pegawai/providers/khs_provider.dart';
import 'package:admin_pegawai/providers/kurikulum_provider.dart';
import 'package:admin_pegawai/providers/mata_kuliah_provider.dart';
import 'package:admin_pegawai/screens/admin_dashboard_screen.dart';
import 'package:admin_pegawai/screens/akademik_screen.dart';
import 'package:admin_pegawai/screens/auth_screen.dart';
import 'package:admin_pegawai/screens/admin_main_screen.dart'; // File AdminScreen Anda
import 'package:admin_pegawai/screens/admin_super_main_screen.dart'; // File SuperScreen Anda
import 'package:admin_pegawai/screens/kelas_detail_screen.dart';
import 'package:admin_pegawai/screens/kelas_edit_screen.dart';
import 'package:admin_pegawai/screens/kurikulum_detail_screen.dart';
import 'package:admin_pegawai/screens/detail_screen.dart';
import 'package:admin_pegawai/screens/detail_tahun_akademik_screen.dart';
import 'package:admin_pegawai/screens/kelas_screen.dart';
import 'package:admin_pegawai/screens/kurikulum_screen.dart';
import 'package:admin_pegawai/screens/matakuliah_edit_screen.dart';
import 'package:admin_pegawai/screens/reset_screen.dart';
import 'package:admin_pegawai/screens/super_dashboard_screen.dart';
import 'package:admin_pegawai/screens/tahun_akademik_screen.dart';
import 'package:admin_pegawai/screens/matakuliah_screen.dart';
import 'package:admin_pegawai/screens/prodi_screen.dart';
import 'package:admin_pegawai/screens/prodi_detail_screen.dart';
import 'package:admin_pegawai/screens/prodi_edit_screen.dart';
import 'package:admin_pegawai/screens/jurusan_screen.dart';
import 'package:admin_pegawai/screens/jurusan_detail_screen.dart';
import 'package:admin_pegawai/screens/jurusan_edit_screen.dart';
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
      initialScreen = const AuthScreen();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MataKuliahProvider()),
        ChangeNotifierProvider(create: (_) => AkademikProvider()),
        ChangeNotifierProvider(create: (_) => ProdiProvider()),
        ChangeNotifierProvider(create: (_) => JurusanProvider()),
        ChangeNotifierProvider(create: (_) => KhsProvider()),
        ChangeNotifierProvider(create: (_) => KurikulumProvider()),
        ChangeNotifierProvider(create: (_) => KelasProvider()),
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
        "/dashboard-admin": (context) =>
            const AdminDashboard(), // AMAN: Tidak lagi error karena parameter opsional
        "/dashboard-super-admin": (context) => const SuperDashboard(),
        "/detail-akun": (context) => const DetailAkunScreen(),
        "/reset-screen": (context) => ResetScreen(),

        // --- ROUTE AKADEMIK ---
        "/akademik": (context) => const AkademikScreen(),
        "/tahun-akademik": (context) => const TahunAkademikScreen(),
        "/detail-tahun-akademik": (context) =>
            const DetailTahunAkademikScreen(),

        // --- ROUTE KURIKULUM ---
        "/kurikulum": (context) => const KurikulumScreen(),
        "/kurikulum-detail": (context) => const KurikulumDetailScreen(),

        // --- ROUTE KELAS ---
        "/kelas": (context) => const KelasScreen(),
        "/detail-kelas": (context) => const DetailKelasScreen(),
        "/kelas-edit": (context) => const KelasEditScreen(),

        // --- ROUTE MATAKULIAH ---
        "/matakuliah": (context) => const MatakuliahScreen(),
        "/matakuliah-edit": (context) => const MatakuliahEditScreen(),

        // --- ROUTE PRODI ---
        "/prodi": (context) => const ProdiScreen(),
        "/prodi-detail": (context) => const ProdiDetailScreen(),
        "/prodi-edit": (context) => const ProdiEditScreen(),

        // --- ROUTE JURUSAN ---
        "/jurusan": (context) => const JurusanScreen(),
        "/jurusan-detail": (context) => const JurusanDetailScreen(),
        "/jurusan-edit": (context) => const JurusanEditScreen(),
      },
    );
  }
}
