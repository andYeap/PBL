import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/jurusan_provider.dart';
import '../providers/prodi_provider.dart';
import '../providers/kelas_provider.dart';
import '../models/jurusan_model.dart';
import '../models/prodi_model.dart';
import '../models/kelas_model.dart';

class KelasScreen extends StatefulWidget {
  const KelasScreen({super.key});

  @override
  State<KelasScreen> createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";

  // State untuk kontrol navigasi 3 tahap
  JurusanModel? _selectedJurusan;
  ProdiResponse? _selectedProdi;

  @override
  void initState() {
    super.initState();

    // Perbaikan pengambilan context yang aman via PostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<JurusanProvider>(context, listen: false).fetchJurusanData();
      Provider.of<ProdiProvider>(context, listen: false).fetchProdiData();
      Provider.of<KelasProvider>(
        context,
        listen: false,
      ).fetchInitialData(perPage: 50);
    });

    // Listener pagination untuk Tahap 3 (Daftar Kelas)
    _scrollController.addListener(() {
      if (_selectedProdi != null &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        // Ambil data halaman berikutnya secara asynchronous tanpa memblokir UI
        Future.microtask(() {
          if (mounted) {
            context.read<KelasProvider>().fetchNextPage(perPage: 50);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_selectedProdi != null) {
      setState(() {
        _selectedProdi = null;
        _searchController.clear();
        _searchQuery = "";
      });
    } else if (_selectedJurusan != null) {
      setState(() {
        _selectedJurusan = null;
        _searchController.clear();
        _searchQuery = "";
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<KelasProvider>();
    debugPrint("JUMLAH KELAS DARI PROVIDER: ${testProvider.listKelas.length}");
    bool isTahapJurusan = _selectedJurusan == null;
    bool isTahapProdi = _selectedJurusan != null && _selectedProdi == null;
    bool isTahapKelas = _selectedProdi != null;

    String currentLabel = isTahapJurusan
        ? "Jurusan"
        : isTahapProdi
        ? "Prodi"
        : "Kelas";

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
                    size: 14,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
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
              "Akademik > Kelas",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // --- Judul Halaman ---
            Text(
              "Kelas",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Kumpulan kelas yang tersedia",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

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
                  hintText: "Cari..",
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

            // --- Label Penunjuk Tahap ---
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                children: [
                  const TextSpan(text: "Pilih "),
                  TextSpan(
                    text: currentLabel,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " yang diinginkan"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Area List Dinamis ---
            Expanded(
              child: _buildDynamicList(
                isTahapJurusan,
                isTahapProdi,
                isTahapKelas,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicList(
    bool isTahapJurusan,
    bool isTahapProdi,
    bool isTahapKelas,
  ) {
    if (isTahapJurusan) {
      // ==========================================
      // TAHAP 1: DAFTAR JURUSAN
      // ==========================================
      final jurusanProvider = context.watch<JurusanProvider>();
      final prodiProvider = context.watch<ProdiProvider>();

      if (jurusanProvider.isLoading && jurusanProvider.listJurusan.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredJurusan = jurusanProvider.listJurusan.where((j) {
        return j.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      if (filteredJurusan.isEmpty)
        return _buildEmptyState("Jurusan tidak ditemukan.");

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: filteredJurusan.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final jurusan = filteredJurusan[index];

          // Memperbaiki validasi pencocokan nama / id prodi ke jurusan
          final prodiCount = prodiProvider.listProdi.where((p) {
            final namaJurusanProdi = p.jurusanNama.toLowerCase().trim();
            return namaJurusanProdi == jurusan.name.toLowerCase().trim() ||
                namaJurusanProdi == jurusan.displayName.toLowerCase().trim();
          }).length;

          return _buildCardTile(
            title: jurusan.displayName,
            subtitle: "$prodiCount Prodi",
            onTap: () {
              setState(() {
                _selectedJurusan = jurusan;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          );
        },
      );
    } else if (isTahapProdi) {
      final prodiProvider = context.watch<ProdiProvider>();
      final kelasProvider = context.watch<KelasProvider>();

      if (prodiProvider.isLoading && prodiProvider.listProdi.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredProdi = prodiProvider.listProdi.where((p) {
        bool matchJurusan = p.jurusanId.toString() == _selectedJurusan!.id.toString();

        bool matchSearch = p.nama.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        return matchJurusan && matchSearch;
      }).toList();

      if (filteredProdi.isEmpty)
        return _buildEmptyState("Prodi tidak ditemukan.");

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: filteredProdi.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final prodi = filteredProdi[index];
          final kelasCount = kelasProvider.listKelas
              .where((k) => k.prodi?.id == prodi.id)
              .length;

          return _buildCardTile(
            title: "Prodi ${prodi.nama.toUpperCase().replaceAll('-', ' ')}",
            subtitle: "$kelasCount Kelas",
            onTap: () {
              setState(() {
                _selectedProdi = prodi;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          );
        },
      );
    } else {
      final kelasProvider = context.watch<KelasProvider>();

      if (kelasProvider.isLoading && kelasProvider.listKelas.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredKelas = kelasProvider.listKelas.where((k) {
        bool matchProdi = k.prodi?.id.toString() == _selectedProdi!.id.toString();
        bool matchSearch = k.name.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        return matchProdi && matchSearch;
      }).toList();

      if (filteredKelas.isEmpty && !kelasProvider.isLoading) {
        return _buildEmptyState("Kelas tidak ditemukan pada prodi ini.");
      }

      return RefreshIndicator(
        onRefresh: () => kelasProvider.fetchInitialData(perPage: 50),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: filteredKelas.length + (kelasProvider.hasMoreData ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == filteredKelas.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: kelasProvider.isFetchingMore
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            }

            final kelas = filteredKelas[index];

            String formatTahun = "-";
            if (kelas.tahunAkademik != null) {
              String taAwal = kelas.tahunAkademik!.tahunAwal;
              String taAkhir = kelas.tahunAkademik!.tahunAkhir;
              if (taAwal.length >= 4 && taAkhir.length >= 4) {
                formatTahun =
                    "${taAwal.substring(0, 4)}/${taAkhir.substring(0, 4)}";
              }
            }

            return _buildCardTile(
              title: "Kelas ${kelas.name.toUpperCase()}",
              subtitle: formatTahun,
              onTap: () {
                Navigator.pushNamed(context, '/detail-kelas', arguments: kelas);
              },
            );
          },
        ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                          fontSize: 14,
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
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13),
      ),
    );
  }
}
