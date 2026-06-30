import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/kurikulum_model.dart'; // <--- PASTIKAN PATH MODEL ANDA BENAR
import '../services/kurikulum_service.dart';

class KurikulumEditScreen extends StatefulWidget {
  final dynamic kurikulum; // Menerima objek KurikulumModel atau Map JSON mentah

  const KurikulumEditScreen({super.key, required this.kurikulum});

  @override
  State<KurikulumEditScreen> createState() => _KurikulumEditScreenState();
}

class _KurikulumEditScreenState extends State<KurikulumEditScreen> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final KurikulumService _kurikulumService = KurikulumService();
  bool _isLoading = false;

  late TextEditingController _namaController;
  String? selectedJurusan;
  String? selectedProdi;

  // Value murni menggunakan format slug (huruf kecil & strip) agar pas dengan payload API
  final List<String> _listJurusanOpsi = [
    "teknik-elektro",
    "teknik-mesin",
    "akuntansi",
  ];

  final List<String> _listProdiOpsi = [
    "teknik-informatika",
    "sistem-informasi-kota-cerdas",
    "teknik-komputer",
  ];

  List<Map<String, dynamic>> editListMk = [];

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller teks nama kurikulum
    _namaController = TextEditingController(text: widget.kurikulum?.name ?? "");

    // Deteksi tipe data parameter input (Objek Model vs Map JSON)
    String rawJurusan = "";
    String rawProdi = "";

    if (widget.kurikulum is KurikulumModel) {
      rawJurusan = widget.kurikulum.prodi.jurusan.name;
      rawProdi = widget.kurikulum.prodi.name;
    } else {
      rawJurusan = widget.kurikulum?['prodi']?['jurusan']?['name'] ?? "";
      rawProdi = widget.kurikulum?['prodi']?['name'] ?? "";
    }

    // Normalisasikan string input awal dari database menjadi standard slug
    selectedJurusan = _convertToSlug(rawJurusan);
    selectedProdi = _convertToSlug(rawProdi);

    // Inisialisasi daftar mata kuliah
    final dynamic mkListRaw = widget.kurikulum is KurikulumModel
        ? widget.kurikulum.kurikulumMk
        : widget.kurikulum?['kurikulum_mk'];

    if (mkListRaw != null) {
      final List<dynamic> mkList = mkListRaw;
      editListMk = List<Map<String, dynamic>>.from(
        mkList.map((mk) {
          final mataKuliah = mk?.mataKuliah;
          String statusMk = "Wajib";
          if (mk?.wajib == false) {
            statusMk = "Pilihan";
          }

          return {
            "id": mataKuliah?.id ?? "",
            "kode": mataKuliah?.kode ?? "-",
            "nama": mataKuliah?.name ?? "Tanpa Nama",
            "status": statusMk,
          };
        }),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  // Mengubah variasi text (Spasi / Kapital) -> Standard Slug ("teknik-informatika")
  String _convertToSlug(String text) {
    return text.toLowerCase().trim().replaceAll(" ", "-").replaceAll("_", "-");
  }

  // Mengubah slug -> Title Case untuk tampilan Dropdown UI ("Teknik Informatika")
  String _formatDisplay(String text) {
    if (text.isEmpty) return "";
    return text
        .replaceAll("-", " ")
        .replaceAll("_", " ")
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Pengaman Dropdown: Jika value tidak terdaftar di opsi list, paksa pilih item pertama agar layar tidak merah/crash
    if (selectedJurusan == null ||
        !_listJurusanOpsi.contains(selectedJurusan)) {
      selectedJurusan = _listJurusanOpsi.first;
    }
    if (selectedProdi == null || !_listProdiOpsi.contains(selectedProdi)) {
      selectedProdi = _listProdiOpsi.first;
    }

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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Akademik > Kurikulum > Detail Kurikulum > Edit Kurikulum",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Text(
                "Edit Kurikulum",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // CARD 1: Informasi Kurikulum
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
                      decoration: _buildInputDecoration("Pilih Jurusan"),
                      items: _listJurusanOpsi
                          .map(
                            (slugValue) => DropdownMenuItem(
                              value: slugValue,
                              child: Text(_formatDisplay(slugValue)),
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
                      decoration: _buildInputDecoration("Pilih Prodi"),
                      items: _listProdiOpsi
                          .map(
                            (slugValue) => DropdownMenuItem(
                              value: slugValue,
                              child: Text(_formatDisplay(slugValue)),
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

              // CARD 2: Informasi Matakuliah
              _buildFormCard(
                title: "Informasi Matakuliah",
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: editListMk.length,
                  itemBuilder: (context, index) {
                    final item = editListMk[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelField("Matakuliah"),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Text(
                                    "${item["nama"]} (${item["kode"]})",
                                    style: GoogleFonts.poppins(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelField("Status"),
                              Row(
                                children: [
                                  _buildFixedStatusButton(
                                    "Wajib",
                                    item["status"] == "Wajib",
                                    () => setState(
                                      () =>
                                          editListMk[index]["status"] = "Wajib",
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildFixedStatusButton(
                                    "Pilihan",
                                    item["status"] == "Pilihan",
                                    () => setState(
                                      () => editListMk[index]["status"] =
                                          "Pilihan",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () =>
                                setState(() => editListMk.removeAt(index)),
                            child: Container(
                              height: 40,
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
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN KE SERVER
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpanDataKeApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Simpan Perubahan",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Eksekusi PUT Request ke Backend ---
  Future<void> _simpanDataKeApi() async {
    setState(() => _isLoading = true);

    String idKurikulumUrl = "";

    // MENGGUNAKAN ID (UUID) SEBAGAI PARAMETER RUTE URL
    if (widget.kurikulum is KurikulumModel) {
      idKurikulumUrl = widget.kurikulum.id;
    } else {
      idKurikulumUrl = (widget.kurikulum?["id"] ?? "").toString().trim();
    }

    if (idKurikulumUrl.isEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mendapatkan ID kurikulum!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Pembuatan payload data
    Map<String, dynamic> payload = {
      "name": _namaController.text,
      "jurusan": selectedJurusan,
      "prodi": selectedProdi,
      "mata_kuliah": editListMk
          .map(
            (mk) => {
              "id": mk["id"],
              "kode": mk["kode"],
              "wajib": mk["status"] == "Wajib",
            },
          )
          .toList(),
    };

    // Mengirimkan ID (UUID) ke service API, bukan lagi string 'kur-mer-TI'
    bool success = await _kurikulumService.updateKurikulumRaw(
      kode: idKurikulumUrl,
      payload: payload,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Data kurikulum berhasil diperbarui!",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 600));
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal menyimpan. Coba cek validitas data di server.",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // --- UI Layout Helpers ---
  Widget _buildFormCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
        width: 54,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          border: Border.all(color: isSelected ? primaryColor : Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
