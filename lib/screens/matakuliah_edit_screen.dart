import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mata_kuliah_model.dart'; // <--- Pastikan import model ini ada

class MatakuliahEditScreen extends StatefulWidget {
  const MatakuliahEditScreen({super.key});

  @override
  State<MatakuliahEditScreen> createState() => _MatakuliahEditScreenState();
}

class _MatakuliahEditScreenState extends State<MatakuliahEditScreen> {
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  int _selectedSks = 3;
  bool _isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isDataInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        // Casting argument eksplisit ke objek MataKuliah model
        final MataKuliah? mataKuliah = args['mataKuliah'] as MataKuliah?;

        if (mataKuliah != null) {
          // --- PERBAIKAN DI SINI: Mengakses field objek menggunakan tanda titik (.) ---
          _kodeController.text = mataKuliah.kode;
          _namaController.text = mataKuliah.name;
          _selectedSks = mataKuliah.sks;
        }
      }
      _isDataInitialized = true;
    }
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pembaharuan data matakuliah berhasil disimpan!"),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String namaKurikulum = args?['namaKurikulum'] ?? 'Kurikulum';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.school, color: Color(0xFF1E3A8A), size: 40),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              "Akademik > matakuliah > detail matakuliah > edit matakuliah",
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Text(
              "Edit Matakuliah",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Pembaharuan data kurikulum untuk $namaKurikulum",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF26428B),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Informasi Matakuliah",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Kode Matakuliah"),
                        _buildTextField(_kodeController),
                        const SizedBox(height: 16),
                        _buildLabel("Matakuliah"),
                        _buildTextField(_namaController),
                        const SizedBox(height: 16),
                        _buildLabel("SKS"),
                        _buildSksSelector(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleSimpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26428B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Simpan",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: " *",
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF26428B)),
        ),
      ),
    );
  }

  Widget _buildSksSelector() {
    final sksOptions = [2, 3, 4];
    return Row(
      children: sksOptions.map((sks) {
        bool isSelected = _selectedSks == sks;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSks = sks),
            child: Container(
              margin: EdgeInsets.only(right: sks == 4 ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color(0xFF26428B) : Colors.black26,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? const Color(0xFF26428B).withOpacity(0.05)
                    : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                sks.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF26428B) : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
