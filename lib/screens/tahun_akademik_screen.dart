import 'package:admin_pegawai/providers/akademik_provider.dart';
import 'package:admin_pegawai/screens/tahun_akademik_detail_screen.dart';
import 'package:admin_pegawai/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TahunAkademikScreen extends StatefulWidget {
  const TahunAkademikScreen({super.key});

  @override
  State<TahunAkademikScreen> createState() => _TahunAkademikScreenState();
}

class _TahunAkademikScreenState extends State<TahunAkademikScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AkademikProvider>(context, listen: false).fetchAkademikData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<AkademikProvider>();
    final filteredList = userProvider.listTahunAkademik.where((ta) {
      final thnAwal = ta.tahunAwal.toString().split('-')[0];
      final thnAkhir = ta.tahunAkhir.toString().split('-')[0];
      final tipe = ta.tipeSemester.toString().toLowerCase();
      final period = "Tahun $thnAwal/$thnAkhir $tipe".toLowerCase();
      return period.contains(_searchQuery);
    }).toList();

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
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'SABAR',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: userProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
                  const SizedBox(height: 16),
                  Text(
                    "Akademik > Detail Kurikulum", // Sesuai teks di gambar pertama
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tahun Akademik",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Kumpulan tahun akademik sedang berlangsung",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari ...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  filteredList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              "Data tahun akademik tidak ditemukan",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ta = filteredList[index];

                            final thnAwal = ta.tahunAwal.toString().split(
                              '-',
                            )[0];
                            final thnAkhir = ta.tahunAkhir.toString().split(
                              '-',
                            )[0];
                            // Kapitalisasi awal kata (Ganjil/Genap)
                            final tipeSemester =
                                ta.tipeSemester.toString().isNotEmpty
                                ? '${ta.tipeSemester.toString()[0].toUpperCase()}${ta.tipeSemester.toString().substring(1).toLowerCase()}'
                                : '';

                            return _buildTahunAkademikCard(
                              title: "Tahun $thnAwal/$thnAkhir $tipeSemester",
                              tahunMulai: ta.tahunAwal,
                              tahunSelesai: ta.tahunAkhir,
                              status: ta.status,
                              onTap: () {
                                userProvider.setSelectedTahunAkademik(ta);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TahunAkademikDetailScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildTahunAkademikCard({
    required String title,
    required String tahunMulai,
    required String tahunSelesai,
    required String status,
    required VoidCallback onTap,
  }) {
    final isAktif = status.toLowerCase() == 'aktif';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isAktif
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE74C3C),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAktif ? "Aktif" : "Non Aktif",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    "Tahun Mulai",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  ":   $tahunMulai",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    "Tahun Selesai",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  ":   $tahunSelesai",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
