import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KurikulumEditScreen extends StatefulWidget {
  const KurikulumEditScreen({super.key});

  @override
  State<KurikulumEditScreen> createState() => _KurikulumEditScreenState();
}

class _KurikulumEditScreenState extends State<KurikulumEditScreen> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final TextEditingController _namaController = TextEditingController(
    text: "Merdeka",
  );

  String? selectedJurusan = "Teknik Elektro";
  String? selectedProdi = "Teknik Informatika";

  // Data state simulasi baris mata kuliah dinamis sesuai dengan mockup Anda
  List<Map<String, dynamic>> editListMk = [
    {"nama": "Pilih Matakuliah", "status": "Wajib"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        scrolledUnderElevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // --- Tombol Kembali ---
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
              // --- Breadcrumbs ---
              Text(
                "Akademik > Kurikulum > Detail Kurikulum > Edit Kurikulum",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Edit Kurikulum",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pembaharuan data kurikulum",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // --- CARD 1: Form Informasi Kurikulum ---
              _buildFormCard(
                title: "Informasi Kurikulum",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelField("Nama Kurikulum"),
                    TextFormField(
                      controller: _namaController,
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: _buildInputDecoration(
                        "Masukkan nama kurikulum",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabelField("Jurusan"),
                    DropdownButtonFormField<String>(
                      value: selectedJurusan,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      decoration: _buildInputDecoration(""),
                      items: ["Teknik Elektro", "Teknik Mesin", "Akuntansi"]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedJurusan = value),
                    ),
                    const SizedBox(height: 16),
                    _buildLabelField("Prodi"),
                    DropdownButtonFormField<String>(
                      value: selectedProdi,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      decoration: _buildInputDecoration(""),
                      items:
                          [
                                "Teknik Informatika",
                                "Sistem Informasi",
                                "Teknik Komputer",
                              ]
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ),
                              )
                              .toList(),
                      onChanged: (value) =>
                          setState(() => selectedProdi = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- CARD 2: Form Informasi Matakuliah (FIXED LAYOUT) ---
              _buildFormCard(
                title: "Informasi Matakuliah",
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: editListMk.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // 1. Dropdown Matakuliah menggunakan Expanded agar mendapatkan porsi ruang terbesar
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabelField("Matakuliah"),
                                    DropdownButtonFormField<String>(
                                      value: editListMk[index]["nama"],
                                      isExpanded:
                                          true, // Mengamankan teks panjang di dalam internal row dropdown
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                      decoration: _buildInputDecoration(""),
                                      items:
                                          [
                                                "Pilih Matakuliah",
                                                "Metode Numerik",
                                                "Administrasi Database",
                                                "Keamanan Jaringan",
                                              ]
                                              .map(
                                                (label) => DropdownMenuItem(
                                                  value: label,
                                                  child: Text(
                                                    label,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) => setState(
                                        () => editListMk[index]["nama"] = val,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // 2. Kolom Komponen Pilihan Status (Wajib / Pilihan) dengan Ukuran Pasti
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabelField("Status"),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildFixedStatusButton(
                                        "Wajib",
                                        editListMk[index]["status"] == "Wajib",
                                        () {
                                          setState(
                                            () => editListMk[index]["status"] =
                                                "Wajib",
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      _buildFixedStatusButton(
                                        "Pilihan",
                                        editListMk[index]["status"] ==
                                            "Pilihan",
                                        () {
                                          setState(
                                            () => editListMk[index]["status"] =
                                                "Pilihan",
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),

                              // 3. Tombol Hapus (Icon Sampah Merah)
                              InkWell(
                                onTap: () {
                                  if (editListMk.length > 1) {
                                    setState(() => editListMk.removeAt(index));
                                  }
                                },
                                child: Container(
                                  height:
                                      40, // Sejajar sempurna dengan tinggi input field disampingnya
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    // Tombol Tambah Baris Mata Kuliah
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(
                          () => editListMk.add({
                            "nama": "Pilih Matakuliah",
                            "status": "Wajib",
                          }),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black87,
                        size: 16,
                      ),
                      label: Text(
                        "Tambah",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL SIMPAN ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.save, color: Colors.white, size: 18),
                  label: Text(
                    "Simpan",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.black38,
        currentIndex: 1,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Akademik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- Helper Widget Layout ---
  Widget _buildFormCard({required String title, required Widget child}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16.0), child: child),
        ],
      ),
    );
  }

  Widget _buildLabelField(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12),
      ),
    );
  }

  Widget _buildFixedStatusButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 54, // Ukuran pas & efisien untuk teks di layar handphone kecil
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.black26,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
