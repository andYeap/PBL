import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pegawai/utils/app_colors.dart';

class DetailKelasScreen extends StatefulWidget {
  const DetailKelasScreen({super.key});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Ambil argumen objek Kelas dari navigator dengan aman
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: const Center(child: Text("Data kelas tidak ditemukan.")),
      );
    }

    final kelas = args as dynamic;

    // 2. Ekstraksi Data Kelas dari API Response
    final String namaKelas = (kelas.name ?? "-").toString().toUpperCase();

    // Proteksi pembacaan objek prodi & jurusan
    final String namaProdi = kelas.prodi != null
        ? (kelas.prodi.name ?? "-").toString()
        : "-";
    final String namaJurusan =
        (kelas.prodi != null && kelas.prodi.jurusan != null)
        ? (kelas.prodi.jurusan.name ?? "-").toString()
        : "-";

    // 3. Handle data Semester (Konversi angka ke teks Ganjil/Genap jika diperlukan)
    final String semesterRaw = (kelas.semester ?? "-").toString();
    String semesterFormatted = semesterRaw;
    if (semesterRaw.toLowerCase() == "genap" ||
        semesterRaw.toLowerCase() == "ganjil") {
      semesterFormatted =
          semesterRaw.substring(0, 1).toUpperCase() +
          semesterRaw.substring(1).toLowerCase();
    } else {
      final int? semAngka = int.tryParse(semesterRaw);
      if (semAngka != null) {
        semesterFormatted = semAngka % 2 == 0 ? "Genap" : "Ganjil";
      }
    }

    // 4. Handle Format Tahun Akademik dari objek Map/Class tahun_akademik
    String tahunAkademikFormatted = "-";
    if (kelas.tahunAkademik != null) {
      try {
        // Menggabungkan tahun_awal/tahun_akhir atau nama jika tersedia
        final String thnAwal = kelas.tahunAkademik.tahunAwal != null
            ? DateTime.parse(
                kelas.tahunAkademik.tahunAwal.toString(),
              ).year.toString()
            : "";
        final String thnAkhir = kelas.tahunAkademik.tahunAkhir != null
            ? DateTime.parse(
                kelas.tahunAkademik.tahunAkhir.toString(),
              ).year.toString()
            : "";

        if (thnAwal.isNotEmpty && thnAkhir.isNotEmpty) {
          tahunAkademikFormatted = "$thnAwal/$thnAkhir $semesterFormatted";
        } else {
          tahunAkademikFormatted =
              "${kelas.tahunAkademik.name ?? kelas.tahunAkademik.id ?? "-"} $semesterFormatted";
        }
      } catch (_) {
        tahunAkademikFormatted = "-";
      }
    }

    // 5. Ambil list Mahasiswa
    final List<dynamic> listMahasiswa = kelas.mahasiswa ?? [];
    final String totalMahasiswaText = "${listMahasiswa.length} Mahasiswa";

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
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.school,
                color: AppColors.primaryColor,
                size: 35,
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tombol Kembali ---
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
              "Akademik > Kelas > Detail Kelas",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Detail Kelas",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "Informasi lengkap kelas beserta mahasiswa",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // --- KARTU 1: INFORMASI KELAS ---
            _buildSectionHeader("Informasi Kelas"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildBoxDecoration(),
              child: Column(
                children: [
                  _buildDetailRow("Nama", namaKelas),
                  _buildCardDivider(),
                  _buildDetailRow("Jurusan", namaJurusan),
                  _buildCardDivider(),
                  _buildDetailRow("Prodi", namaProdi),
                  _buildCardDivider(),
                  _buildDetailRow("Tahun Akademik", tahunAkademikFormatted),
                  _buildCardDivider(),
                  _buildDetailRow("Semester", semesterFormatted),
                  _buildCardDivider(),
                  _buildDetailRow("Total Mahasiswa", totalMahasiswaText),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- KARTU 2: INFORMASI MAHASISWA ---
            _buildSectionHeader("Informasi Mahasiswa"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _buildBoxDecoration(),
              child: listMahasiswa.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          "Belum ada mahasiswa di kelas ini",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listMahasiswa.length,
                      separatorBuilder: (context, index) => _buildCardDivider(),
                      itemBuilder: (context, index) {
                        final mhs = listMahasiswa[index];

                        // Ekstraksi data mahasiswa sesuai dengan Response API baru
                        final String studentName = (mhs.name ?? "-").toString();
                        final String studentEmail = (mhs.email ?? "-")
                            .toString();

                        return _buildStudentRow(studentName, studentEmail);
                      },
                    ),
            ),
            const SizedBox(height: 24),

            // --- TOMBOL AKSI BERDAMPINGAN ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Tambahkan aksi edit di sini
                      },
                      icon: const Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        "Edit",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Tambahkan aksi hapus di sini
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        "Hapus",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENT WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C4DA7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }

  Widget _buildCardDivider() {
    return const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE));
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          ),
        ),
        Text(
          ":",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentRow(String name, String email) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            email,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.end,
            overflow: TextOverflow
                .ellipsis, // Mencegah crash overflow jika email terlalu panjang
          ),
        ),
      ],
    );
  }
}
