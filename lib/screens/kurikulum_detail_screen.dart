import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kurikulum_edit_screen.dart';

class KurikulumDetailScreen extends StatefulWidget {
  const KurikulumDetailScreen({super.key});

  @override
  State<KurikulumDetailScreen> createState() => _KurikulumDetailScreenState();
}

class _KurikulumDetailScreenState extends State<KurikulumDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Color cardHeaderColor = const Color(0xFF1E3A8A);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic kurikulumModel = ModalRoute.of(context)?.settings.arguments;

    if (kurikulumModel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F7FB),
        appBar: AppBar(title: const Text("Detail Kurikulum")),
        body: const Center(child: Text("Data kurikulum tidak ditemukan.")),
      );
    }

    final List<dynamic> listMk = kurikulumModel.kurikulumMk ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school, color: Color(0xFF1E3A8A), size: 40),
            ),
            const SizedBox(width: 8),
            Text(
              'SABAR',
              style: GoogleFonts.poppins(
                color: const Color(0xFF1E3A8A),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Kembali",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Akademik > Kurikulum > Detail Kurikulum",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Detail Kurikulum",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Informasi lengkap kurikulum beserta mata kuliah",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // CARD 1: Informasi Kurikulum
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardHeaderColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Informasi Kurikulum",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildInfoRow("Nama", kurikulumModel.name ?? '-'),
                          const Divider(height: 24, color: Colors.black12),
                          _buildInfoRow(
                            "Jurusan",
                            kurikulumModel.prodi?.jurusan?.name ?? '-',
                          ),
                          const Divider(height: 24, color: Colors.black12),
                          _buildInfoRow(
                            "Prodi",
                            "${kurikulumModel.prodi?.name ?? '-'} (${kurikulumModel.prodi?.jenjang ?? '-'})",
                          ),
                          const Divider(height: 24, color: Colors.black12),
                          _buildInfoRow("Tahun Akademik", "2024-2025"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CARD 2: Informasi Mata Kuliah (Tabel)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardHeaderColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Informasi Mata Kuliah",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (listMk.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            "Belum ada data mata kuliah.",
                            style: GoogleFonts.poppins(color: Colors.black54),
                          ),
                        ),
                      )
                    else
                      Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            dataTextStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            horizontalMargin: 16,
                            columnSpacing: 38,
                            columns: const [
                              DataColumn(label: Text('Nama Mata Kuliah')),
                              DataColumn(label: Text('Kode MK')),
                              DataColumn(label: Text('SKS')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: listMk.map((mkData) {
                              final name = mkData?.mataKuliah?.name ?? '-';
                              final kode = mkData?.mataKuliah?.kode ?? '-';
                              final sks = "${mkData?.mataKuliah?.sks ?? 0} SKS";

                              String statusText = "Wajib";
                              Color statusColor = const Color(0xFF10B981);

                              try {
                                if (mkData?.wajib == false) {
                                  statusText = "Pilihan";
                                  statusColor = const Color(0xFFF59E0B);
                                } else if (mkData
                                    .toString()
                                    .toLowerCase()
                                    .contains('pilihan')) {
                                  statusText = "Pilihan";
                                  statusColor = const Color(0xFFF59E0B);
                                }
                              } catch (_) {
                                final strData = mkData.toString().toLowerCase();
                                if (strData.contains('pilihan')) {
                                  statusText = "Pilihan";
                                  statusColor = const Color(0xFFF59E0B);
                                }
                              }

                              return DataRow(
                                cells: [
                                  DataCell(Text(name)),
                                  DataCell(Text(kode)),
                                  DataCell(Text(sks)),
                                  DataCell(
                                    Text(
                                      statusText,
                                      style: GoogleFonts.poppins(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL EDIT DENGAN LOGIKA REFRESH ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Menunggu kembalian dari KurikulumEditScreen
                    final isUpdated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KurikulumEditScreen(kurikulum: kurikulumModel),
                      ),
                    );

                    // Jika bernilai true (artinya data berhasil diubah), refresh halaman detail
                    if (isUpdated == true) {
                      setState(() {
                        // Memaksa widget membangun ulang UI dengan nilai model yang baru updated
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.edit_square,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    "Edit",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardHeaderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // ... bottomNavigationBar tetap sama ...
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
