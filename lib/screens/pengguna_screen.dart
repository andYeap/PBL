import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/pengguna_dosen_provider.dart';
import '../utils/app_colors.dart';
import 'pengguna_dosen_screen.dart';

class PenggunaScreen extends StatefulWidget {
  const PenggunaScreen({super.key});

  @override
  State<PenggunaScreen> createState() => _PenggunaScreenState();
}

class _PenggunaScreenState extends State<PenggunaScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi fetch data Dosen saat halaman diinisialisasi
    Future.microtask(() {
      if (!mounted) return;
      context.read<PenggunaDosenProvider>().getDosenData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memantau state dari PenggunaDosenProvider secara dinamis
    final dosenProvider = context.watch<PenggunaDosenProvider>();

    final int totalDosen = dosenProvider.listDosen.length;
    final bool isLoadingData = dosenProvider.isLoading;

    // Nilai placeholder sementara untuk menu fitur yang dinonaktifkan
    const int totalPegawai = 0;
    const int totalMahasiswa = 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.school,
                color: AppColors.primaryColor,
                size: 30,
              ),
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
      body: RefreshIndicator(
        onRefresh: () => context.read<PenggunaDosenProvider>().getDosenData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Navigasi Kembali
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Kembali",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Pengguna",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Kumpulan Informasi fitur akademik",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Card Menu: Pegawai (Sekarang Dinonaktifkan)
              _buildMenuCard(
                icon: Icons.business_center,
                title: "Pegawai",
                subtitle: "Fitur dinonaktifkan ($totalPegawai)",
                isDisabled: true,
                onTap: () {},
              ),
              const SizedBox(height: 16),

              // Card Menu: Dosen (Sekarang Aktif Mendukung API)
              _buildMenuCard(
                icon: Icons.co_present,
                title: "Dosen",
                subtitle: isLoadingData
                    ? "Memuat data..."
                    : "Terdapat $totalDosen Dosen Aktif",
                isDisabled: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PenggunaDosenScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Card Menu: Mahasiswa (Disabled)
              _buildMenuCard(
                icon: Icons.people,
                title: "Mahasiswa",
                subtitle: "Fitur dinonaktifkan ($totalMahasiswa)",
                isDisabled: true,
                onTap: () {},
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen Reusable Card dengan Indikator Status Aktif / Nonaktif
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDisabled ? 0.02 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDisabled ? Colors.grey.shade400 : Colors.black87,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDisabled
                              ? Colors.grey.shade400
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDisabled
                              ? Colors.grey.shade400
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDisabled ? Colors.grey.shade300 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
