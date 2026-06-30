import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/khs_provider.dart';
import '../models/khs_model.dart';
import '../utils/app_colors.dart';

String _formatSlug(String text) {
  if (text.isEmpty) return text;
  return text
      .replaceAll('-', ' ')
      .split(' ')
      .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
      .join(' ');
}

class KhsScreen extends StatefulWidget {
  const KhsScreen({super.key});

  @override
  State<KhsScreen> createState() => _KhsScreenState();
}

class _KhsScreenState extends State<KhsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KhsProvider>().loadKhsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final khsProvider = context.watch<KhsProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: khsProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildBackButton(context),
                  const SizedBox(height: 16),
                  _buildBreadcrumb("Akademik > KHS"),
                  const SizedBox(height: 4),
                  Text(
                    "KHS",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Kumpulan hasil studi mahasiswa",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Pilih Prodi yang diinginkan",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: khsProvider.uniqueProdis.length,
                    itemBuilder: (context, index) {
                      final prodi = khsProvider.uniqueProdis[index];
                      return _buildCardItem(
                        title: "Prodi ${_formatSlug(prodi)}",
                        subtitle: "Lihat Kelas & Mahasiswa",
                        onTap: () {
                          khsProvider.selectedProdi = prodi;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const KhsKelasScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class KhsKelasScreen extends StatelessWidget {
  const KhsKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final khsProvider = context.watch<KhsProvider>();
    final prodi = khsProvider.selectedProdi ?? '';
    final listKelas = khsProvider.getUniqueKelasByProdi(prodi);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBackButton(context),
            const SizedBox(height: 16),
            _buildBreadcrumb("Akademik > KHS > Kelas"),
            const SizedBox(height: 4),
            Text(
              "Kelas - ${_formatSlug(prodi)}",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Pilih Kelas yang diinginkan",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listKelas.length,
              itemBuilder: (context, index) {
                final kelas = listKelas[index];
                return _buildCardItem(
                  title: "Kelas $kelas",
                  subtitle: "Tahun Akademik Berjalan",
                  onTap: () {
                    khsProvider.selectedKelas = kelas;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhsMahasiswaScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class KhsMahasiswaScreen extends StatelessWidget {
  const KhsMahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final khsProvider = context.watch<KhsProvider>();
    final prodi = khsProvider.selectedProdi ?? '';
    final kelas = khsProvider.selectedKelas ?? '';
    final listMahasiswa = khsProvider.getMahasiswaByKelas(prodi, kelas);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBackButton(context),
            const SizedBox(height: 16),
            _buildBreadcrumb("Akademik > KHS > Kelas > Mahasiswa"),
            const SizedBox(height: 4),
            Text(
              "Mahasiswa Kelas $kelas",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Pilih Mahasiswa yang diinginkan",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listMahasiswa.length,
              itemBuilder: (context, index) {
                final studentKhs = listMahasiswa[index];
                return _buildCardItem(
                  title: studentKhs.mahasiswaName,
                  subtitle: "Semester ${studentKhs.semester}",
                  onTap: () {
                    khsProvider.selectedKhsData = studentKhs;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KhsDetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class KhsDetailScreen extends StatelessWidget {
  const KhsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final khsProvider = context.watch<KhsProvider>();
    final data = khsProvider.selectedKhsData;

    if (data == null) {
      return const Scaffold(body: Center(child: Text("Data tidak tersedia")));
    }

    int totalSks = data.nilai.fold(0, (sum, item) => sum + item.sks);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBackButton(context),
            const SizedBox(height: 16),
            _buildBreadcrumb("Akademik > KHS > Detail KHS"),
            const SizedBox(height: 4),
            Text(
              "Detail KHS",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "Informasi lengkap hasil studi mahasiswa",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Informasi Tahun Akademik",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _buildDetailRow("Nama", data.mahasiswaName),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  _buildDetailRow("NIM", "C0320424342"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  _buildDetailRow("Kelas", data.kelasName),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  _buildDetailRow("Prodi", _formatSlug(data.prodiName)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  _buildDetailRow("Matakuliah", "Database"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                "Total SKS $totalSks",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                "IPS ${data.ips.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Mata Kuliah",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "SKS",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Nilai",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Huruf",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.nilai.length,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    itemBuilder: (context, index) {
                      final n = data.nilai[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.namaMk,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    n.kodeMk,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                n.sks.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "4.00",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                n.grade,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      children: [
        const Icon(Icons.school, color: AppColors.primaryColor, size: 30),
        const SizedBox(width: 8),
        Text(
          'SABAR',
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

Widget _buildBackButton(BuildContext context) {
  return InkWell(
    onTap: () => Navigator.pop(context),
    borderRadius: BorderRadius.circular(4),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back_ios, size: 14, color: Colors.black87),
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
  );
}

Widget _buildBreadcrumb(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 11,
      color: Colors.black45,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget _buildCardItem({
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black45),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.black45,
      ),
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
