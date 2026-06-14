import 'package:flutter/material.dart';
import '../models/jurusan_model.dart';
import '../services/jurusan_service.dart';

class JurusanProvider with ChangeNotifier {
  final JurusanService _service = JurusanService();

  List<JurusanModel> _listJurusan = [];
  JurusanModel? _selectedJurusan;
  bool _isLoading = false;

  List<JurusanModel> get listJurusan => _listJurusan;
  JurusanModel? get selectedJurusan => _selectedJurusan;
  bool get isLoading => _isLoading;

  void setSelectedJurusan(JurusanModel jurusan) {
    _selectedJurusan = jurusan;
    notifyListeners();
  }

  // Fetch Data
  Future<void> fetchJurusanData() async {
    _isLoading = true;
    notifyListeners();

    _listJurusan = await _service.getAllJurusan();

    _isLoading = false;
    notifyListeners();
  }

  // Edit Data
  Future<bool> editJurusan(String newName) async {
    if (_selectedJurusan == null) return false;

    _isLoading = true;
    notifyListeners();

    // Mengubah string kembali ke format slug url jika dibutuhkan backend (Contoh: Teknik Elektro -> teknik-elektro)
    String formattedName = newName.trim().toLowerCase().replaceAll(' ', '-');

    bool success = await _service.updateJurusan(
      _selectedJurusan!.id,
      formattedName,
    );
    if (success) {
      await fetchJurusanData(); // Refresh list lokal
      // Update data objek yang sedang dipilih saat ini
      _selectedJurusan = JurusanModel(
        id: _selectedJurusan!.id,
        name: formattedName,
      );
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // Remove Data
  Future<bool> removeJurusan() async {
    if (_selectedJurusan == null) return false;

    _isLoading = true;
    notifyListeners();

    bool success = await _service.deleteJurusan(_selectedJurusan!.id);
    if (success) {
      _listJurusan.removeWhere((item) => item.id == _selectedJurusan!.id);
      _selectedJurusan = null;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
