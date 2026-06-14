import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/kurikulum_provider.dart'; // Sesuaikan path ini
import '../utils/app_colors.dart'; // Sesuaikan path ini

class KurikulumScreen extends StatefulWidget {
  const KurikulumScreen({super.key});

  @override
  State<KurikulumScreen> createState() => _KurikulumScreenState();
}

class _KurikulumScreenState extends State<KurikulumScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // State untuk mengontrol navigasi di dalam satu halaman
  String? _selectedKurikulumName;
  String? _selectedJurusanName;

  @override
  void initState() {
    super.initState();
    // Tarik data saat halaman pertama kali dibuka (jika belum ada)
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
    if (_selectedJurusanName != null) {
      setState(() {
        _selectedJurusanName = null;
        _searchController.clear();
        _searchQuery = "";
      });
    } else if (_selectedKurikulumName != null) {
      setState(() {
        _selectedKurikulumName = null;
        _searchController.clear();
        _searchQuery = "";
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantau perubahan data dari provider
    final provider = context.watch<KurikulumProvider>();

    bool isSelectingKurikulum = _selectedKurikulumName == null;
    bool isSelectingJurusan =
        _selectedKurikulumName != null && _selectedJurusanName == null;
    // isSelectingProdi berlaku jika keduanya tidak null

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Atau Colors.grey[50]
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png', // Sesuaikan path logo
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school, color: AppColors.primaryColor, size: 40),
            ),
            const SizedBox(width: 8),
            Text(
              'SABAR',
              style: GoogleFonts.poppins(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
            GestureDetector(
              onTap: _handleBack,
              child: Row(
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
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              isSelectingKurikulum
                  ? "Akademik > Kurikulum"
                  : isSelectingJurusan
                  ? "Akademik > Kurikulum > $_selectedKurikulumName"
                  : "Akademik > Kurikulum > $_selectedJurusanName",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
            ),
            const SizedBox(height: 4),

            Text(
              isSelectingKurikulum
                  ? "Kurikulum"
                  : isSelectingJurusan
                  ? "Jurusan"
                  : "Program Studi",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Pilih dari daftar yang tersedia",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Cari...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black38),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (provider.isLoading && provider.listKurikulum.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (provider.listKurikulum.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Data kurikulum belum tersedia.",
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                ),
              )
            else
              Expanded(
                child: _buildDynamicList(
                  provider,
                  isSelectingKurikulum,
                  isSelectingJurusan,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicList(
    KurikulumProvider provider,
    bool isSelectingKurikulum,
    bool isSelectingJurusan,
  ) {
    final rawData = provider.listKurikulum;

    if (isSelectingKurikulum) {
      var kurikulumNames = rawData.map((k) => k.name).toSet().toList();
      kurikulumNames = kurikulumNames
          .where(
            (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      return ListView.separated(
        itemCount: kurikulumNames.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    } else if (isSelectingJurusan) {
      final kurikulumFiltered = rawData
          .where((k) => k.name == _selectedKurikulumName)
          .toList();
      var jurusanNames = kurikulumFiltered
          .map((k) => k.prodi.jurusan.name)
          .toSet()
          .toList();

      jurusanNames = jurusanNames
          .where(
            (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      return ListView.separated(
        itemCount: jurusanNames.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final namaJurusan = jurusanNames[index];
          final prodiCount = kurikulumFiltered
              .where((k) => k.prodi.jurusan.name == namaJurusan)
              .length;

          return _buildCardTile(
            title: namaJurusan,
            subtitle: "$prodiCount Prodi",
            onTap: () {
              setState(() {
                _selectedJurusanName = namaJurusan;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          );
        },
      );
    } else {
      var finalModels = rawData
          .where(
            (k) =>
                k.name == _selectedKurikulumName &&
                k.prodi.jurusan.name == _selectedJurusanName,
          )
          .toList();

      finalModels = finalModels
          .where(
            (k) =>
                k.prodi.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      return ListView.separated(
        itemCount: finalModels.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final kurikulumModel = finalModels[index];
          final totalMk = kurikulumModel.kurikulumMk.length;

          return _buildCardTile(
            title: "Prodi ${kurikulumModel.prodi.name}",
            subtitle:
                "$totalMk Matakuliah - Jenjang ${kurikulumModel.prodi.jenjang}",
            onTap: () {
              // --- PERUBAHAN DI SINI ---
              // Menavigasi ke halaman detail saat prodi diklik
              Navigator.pushNamed(
                context,
                '/kurikulum-detail',
                // Opsional: Anda bisa mengirim data kurikulumModel ke halaman detail
                // jika halaman detail membutuhkannya nanti.
                arguments: kurikulumModel,
              );
            },
          );
        },
      );
    }
  }

  Widget _buildCardTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
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
