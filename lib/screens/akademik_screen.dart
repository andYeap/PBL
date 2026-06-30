import 'package:admin_pegawai/providers/akademik_provider.dart';
import 'package:admin_pegawai/providers/kelas_provider.dart';
import 'package:admin_pegawai/providers/khs_provider.dart';
import 'package:admin_pegawai/providers/kurikulum_provider.dart';
import 'package:admin_pegawai/providers/mata_kuliah_provider.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:admin_pegawai/providers/prodi_provider.dart';
import 'package:admin_pegawai/providers/jurusan_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pegawai/utils/app_colors.dart';
import 'package:provider/provider.dart';

class AkademikScreen extends StatefulWidget {
  const AkademikScreen({super.key});

  @override
  State<AkademikScreen> createState() => _AkademikScreenState();
}

class _AkademikScreenState extends State<AkademikScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<UserProvider>().fetchDashboardUserData();
      context.read<AkademikProvider>().fetchAkademikData();
      context.read<ProdiProvider>().fetchProdiData();
      context.read<JurusanProvider>().fetchJurusanData();
      context.read<MataKuliahProvider>().fetchInitialData();
      context.read<KurikulumProvider>().fetchInitialData();
      context.read<KelasProvider>().fetchInitialData();
      context.read<KhsProvider>().loadKhsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final akademikProvider = context.watch<AkademikProvider>();
    final prodiProvider = context.watch<ProdiProvider>();
    final jurusanProvider = context.watch<JurusanProvider>();
    final kurikulumProvider = context.watch<KurikulumProvider>();
    final mataKuliahProvider = context.watch<MataKuliahProvider>();
    final kelasProvider = context.watch<KelasProvider>();
    final khsProvider = context.watch<KhsProvider>();

    final int totalTahunAkademik = akademikProvider.listTahunAkademik.length;
    final int totalKurikulum = kurikulumProvider.listKurikulum.length;
    final int totalMataKuliah = mataKuliahProvider.totalItems;
    final int totalProdi = prodiProvider.listProdi.length;
    final int totalJurusan = jurusanProvider.listJurusan.length;
    final int totalKelas = kelasProvider.listKelas.length;
    final int totalKHS = khsProvider.allKhsData.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'SABAR',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Akademik",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Kumpulan informasi fitur akademik",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              _buildMenuTile(
                title: "Tahun Akademik",
                subtitle: "Tersedia $totalTahunAkademik Tahun Akademik",
                icon: Icons.calendar_today_outlined,
                onTap: () => Navigator.pushNamed(context, "/tahun-akademik"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "Kurikulum",
                subtitle: "Tersedia $totalKurikulum Kurikulum",
                icon: Icons.book_outlined,
                onTap: () => Navigator.pushNamed(context, "/kurikulum"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "Matakuliah",
                subtitle: "Terdapat $totalMataKuliah Matakuliah",
                icon: Icons.assignment_outlined,
                onTap: () => Navigator.pushNamed(context, "/matakuliah"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "Kelas",
                subtitle: "Tersedia $totalKelas Kelas",
                icon: Icons.co_present_outlined,
                onTap: () => Navigator.pushNamed(context, "/kelas"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "KHS",
                subtitle: "Terdapat $totalKHS KHS",
                icon: Icons.description_outlined,
                onTap: () => Navigator.pushNamed(context, "/khs"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "Jurusan",
                subtitle: "Terdapat $totalJurusan Jurusan",
                icon: Icons.school_outlined,
                onTap: () => Navigator.pushNamed(context, "/jurusan"),
              ),
              const SizedBox(height: 16),
              _buildMenuTile(
                title: "Prodi",
                subtitle: "Terdapat $totalProdi Prodi",
                icon: Icons.workspace_premium_outlined,
                onTap: () => Navigator.pushNamed(context, "/prodi"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Icon(icon, size: 32, color: const Color(0xFF424242)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
