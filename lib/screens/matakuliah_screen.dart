import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin_pegawai/providers/kurikulum_provider.dart';
import 'package:admin_pegawai/screens/matakuliah_detail_screen.dart'; // Import screen detail

class MatakuliahScreen extends StatefulWidget {
  const MatakuliahScreen({super.key});

  @override
  State<MatakuliahScreen> createState() => _MatakuliahScreenState();
}

class _MatakuliahScreenState extends State<MatakuliahScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // State untuk mengontrol navigasi/alur halaman
  String? _selectedKurikulumName;

  @override
  void initState() {
    super.initState();
    // Tarik data kurikulum saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<KurikulumProvider>();
      if (provider.listKurikulum.isEmpty) {
        provider.fetchInitialData();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_selectedKurikulumName != null) {
      // Jika sedang melihat matakuliah, kembali ke daftar Kurikulum
      setState(() {
        _selectedKurikulumName = null;
        _searchController.clear();
        _searchQuery = "";
      });
    } else {
      // Jika di daftar kurikulum, keluar dari halaman
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KurikulumProvider>();
    bool isSelectingKurikulum = _selectedKurikulumName == null;

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
              'assets/logo/logo.png', // Pastikan path logo sesuai
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // --- Tombol Kembali ---
            InkWell(
              onTap: _handleBack,
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

            // --- Breadcrumbs ---
            Text(
              "Akademik > Matakuliah",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),

            // --- Judul Halaman ---
            Text(
              "Matakuliah",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSelectingKurikulum
                  ? "Kumpulan kurikulum yang tersedia"
                  : "Kumpulan matakuliah dari $_selectedKurikulumName",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // --- Search Bar ---
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
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Cari ...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Label Penunjuk ---
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                children: isSelectingKurikulum
                    ? [
                        const TextSpan(text: "Pilih "),
                        TextSpan(
                          text: "Kurikulum",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " yang diinginkan"),
                      ]
                    : [
                        const TextSpan(text: "Pilih "),
                        TextSpan(
                          text: "matakuliah",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " yang diinginkan"),
                      ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Area List ---
            if (provider.isLoading && provider.listKurikulum.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (provider.listKurikulum.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Data tidak tersedia.",
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                ),
              )
            else
              Expanded(
                child: _buildDynamicList(provider, isSelectingKurikulum),
              ),
          ],
        ),
      ),
    );
  }

  // List Dinamis: Kurikulum (Tahap 1) atau Matakuliah (Tahap 2)
  Widget _buildDynamicList(
    KurikulumProvider provider,
    bool isSelectingKurikulum,
  ) {
    final rawData = provider.listKurikulum;

    if (isSelectingKurikulum) {
      // --- TAHAP 1: Daftar Kurikulum ---
      var kurikulumNames = rawData.map((k) => k.name).toSet().toList();
      kurikulumNames = kurikulumNames
          .where(
            (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: kurikulumNames.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final namaKurikulum = kurikulumNames[index];
          final prodiCount = rawData
              .where((k) => k.name == namaKurikulum)
              .length;

          return _buildCardTile(
            title: namaKurikulum,
            subtitle: "$prodiCount Prodi",
            onTap: () {
              setState(() {
                _selectedKurikulumName = namaKurikulum;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          );
        },
      );
    } else {
      // --- TAHAP 2: Daftar Matakuliah ---
      final kurikulumFiltered = rawData
          .where((k) => k.name == _selectedKurikulumName)
          .toList();

      final Map<dynamic, dynamic> uniqueMk = {};
      for (var k in kurikulumFiltered) {
        for (var mkData in k.kurikulumMk) {
          uniqueMk[mkData.mataKuliah.id] = mkData.mataKuliah;
        }
      }

      var listMatakuliah = uniqueMk.values.toList();
      listMatakuliah = listMatakuliah
          .where(
            (mk) => mk.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      if (listMatakuliah.isEmpty) {
        return Center(
          child: Text(
            "Tidak ada matakuliah di kurikulum ini.",
            style: GoogleFonts.poppins(color: Colors.black54),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: listMatakuliah.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final mk = listMatakuliah[index];

          return _buildCardTile(
            title: mk.name,
            subtitle: "${mk.sks} SKS - Kode: ${mk.kode}",
            onTap: () {
              // Pindah ke MatakuliahDetailScreen dengan membawa data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatakuliahDetailScreen(
                    mataKuliah: mk,
                    namaKurikulum: _selectedKurikulumName ?? "-",
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  // Template Card Item
  Widget _buildCardTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
