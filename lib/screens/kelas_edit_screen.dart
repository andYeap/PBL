import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pegawai/utils/app_colors.dart';

class KelasEditScreen extends StatefulWidget {
  const KelasEditScreen({super.key});

  @override
  State<KelasEditScreen> createState() => _KelasEditScreenState();
}

class _KelasEditScreenState extends State<KelasEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form input text controllers
  final TextEditingController _namaKelasController = TextEditingController();
  final TextEditingController _namaMahasiswaController =
      TextEditingController();
  final TextEditingController _emailMahasiswaController =
      TextEditingController();

  // State value penampung dropdown pilihan
  String? _selectedJurusan;
  String? _selectedProdi;
  String? _selectedTahunAkademik;
  String? _selectedSemester;

  // Master lists dummy data untuk Dropdown item (sesuaikan dengan isi master database)
  final List<String> _listJurusan = [
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
  ];
  final List<String> _listProdi = [
    'Teknik Informatika',
    'Teknik Listrik',
    'Teknik Elektronika',
  ];
  final List<String> _listTahunAkademik = [
    '2024/2025 Ganjil',
    '2024/2025 Genap',
    '2025/2026 Ganjil',
  ];
  final List<String> _listSemester = ['Ganjil', 'Genap'];

  // Kunci pengaman agar data tidak terus menerus reset saat user mengetik textfield
  bool _isDataInitialized = false;

  @override
  void dispose() {
    _namaKelasController.dispose();
    _namaMahasiswaController.dispose();
    _emailMahasiswaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tangkap argumen data kelas yang dikirim oleh Navigator dari DetailKelasScreen
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && !_isDataInitialized) {
      final kelas = args as dynamic;

      // Auto-fill nama kelas ke textfield
      _namaKelasController.text = (kelas.name ?? "").toString().toUpperCase();

      // Ambil String nama prodi dan jurusan
      final String prodiName = kelas.prodi != null
          ? (kelas.prodi.name ?? "").toString()
          : "";
      final String jurusanName =
          (kelas.prodi != null && kelas.prodi.jurusan != null)
          ? (kelas.prodi.jurusan.name ?? "").toString()
          : "";

      // Sinkronisasi data ke variabel pilihan Dropdown Jurusan
      if (jurusanName.isNotEmpty) {
        _selectedJurusan = _listJurusan.firstWhere(
          (e) =>
              e.toLowerCase() == jurusanName.toLowerCase().replaceAll('-', ' '),
          orElse: () => _listJurusan.first,
        );
      }

      // Sinkronisasi data ke variabel pilihan Dropdown Prodi
      if (prodiName.isNotEmpty) {
        _selectedProdi = _listProdi.firstWhere(
          (e) =>
              e.toLowerCase() == prodiName.toLowerCase().replaceAll('-', ' '),
          orElse: () => _listProdi.first,
        );
      }

      // Sinkronisasi data Semester
      final String semRaw = (kelas.semester ?? "").toString().toLowerCase();
      if (semRaw == "5" || semRaw == "ganjil") {
        _selectedSemester = "Ganjil";
      } else {
        _selectedSemester = "Genap";
      }

      _selectedTahunAkademik = _listTahunAkademik.first;

      // Ambil index ke-0 mahasiswa sebagai sampel data pengisian form
      final List<dynamic> mahasiswaList = kelas.mahasiswa ?? [];
      if (mahasiswaList.isNotEmpty) {
        _namaMahasiswaController.text = (mahasiswaList[0].name ?? "")
            .toString();
        _emailMahasiswaController.text = (mahasiswaList[0].email ?? "")
            .toString(); // Field Email pengganti NIM
      }

      // Kunci data agar pengisian otomatis ini hanya berjalan sekali saja
      _isDataInitialized = true;
    }

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
        child: Form(
          key: _formKey,
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
                "Akademik > Kelas > Detail Kelas > Edit Kelas",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Edit Kelas",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Pembaharuan data kelas",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // --- FORM KARTU 1: DATA INFORMASI KELAS ---
              _buildSectionHeader("Informasi Kelas"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _buildBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Nama"),
                    _buildTextField(
                      _namaKelasController,
                      "Masukkan Nama Kelas",
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Jurusan"),
                    _buildDropdownField(_selectedJurusan, _listJurusan, (
                      value,
                    ) {
                      setState(() => _selectedJurusan = value);
                    }),
                    const SizedBox(height: 16),
                    _buildLabel("Prodi"),
                    _buildDropdownField(_selectedProdi, _listProdi, (value) {
                      setState(() => _selectedProdi = value);
                    }),
                    const SizedBox(height: 16),
                    _buildLabel("Tahun Akademik"),
                    _buildDropdownField(
                      _selectedTahunAkademik,
                      _listTahunAkademik,
                      (value) {
                        setState(() => _selectedTahunAkademik = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Semester"),
                    _buildDropdownField(_selectedSemester, _listSemester, (
                      value,
                    ) {
                      setState(() => _selectedSemester = value);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL SUBMIT SIMPAN ---
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Masukkan fungsi integrasi API PUT/PATCH kamu disini
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menyimpan perubahan data kelas...'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save, color: Colors.white, size: 20),
                  label: Text(
                    "Simpan",
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGET FORM HELPERS ---

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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.black26, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bagian ini tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.black26, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(value: val, child: Text(val));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
