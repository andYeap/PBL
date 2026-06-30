import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/pengguna_dosen_provider.dart';
import '../utils/app_colors.dart';
import 'pengguna_detail_dosen_screen.dart';

class PenggunaDosenScreen extends StatefulWidget {
  const PenggunaDosenScreen({super.key});

  @override
  State<PenggunaDosenScreen> createState() => _PenggunaDosenScreenState();
}

class _PenggunaDosenScreenState extends State<PenggunaDosenScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PenggunaDosenProvider>().getDosenData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dosenProvider = context.watch<PenggunaDosenProvider>();

    final filteredDosen = dosenProvider.listDosen.where((dosen) {
      return dosen.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
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
              "Pengguna > Dosen",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Dosen",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<PenggunaDosenProvider>().getDosenData(),
                child: dosenProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : dosenProvider.errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          dosenProvider.errorMessage,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      )
                    : filteredDosen.isEmpty
                    ? Center(
                        child: Text(
                          "Data dosen tidak ditemukan.",
                          style: GoogleFonts.poppins(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: filteredDosen.length,
                        itemBuilder: (context, index) {
                          final dosen = filteredDosen[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
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
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PenggunaDetailDosenScreen(dosen: dosen),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFFE5E7EB),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black54,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                dosen.name, // 1. NAMA
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                dosen.email, // 2. EMAIL
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E7FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  dosen.roleName.toUpperCase(), // 3. ROLE NAME
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF4338CA),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
