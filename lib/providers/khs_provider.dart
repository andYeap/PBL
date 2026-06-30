import 'package:flutter/material.dart';
import '../models/khs_model.dart';
import '../services/khs_service.dart';

class KhsProvider with ChangeNotifier {
  final KhsService _khsService = KhsService();

  List<KhsData> _allKhsData = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<KhsData> get allKhsData => _allKhsData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // State navigasi alur KHS yang sedang dipilih
  String? selectedProdi;
  String? selectedKelas;
  KhsData? selectedKhsData;

  Future<void> loadKhsData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allKhsData = await _khsService.fetchAllKhs();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mendapatkan daftar Prodi unik berdasarkan data KHS yang masuk
  List<String> get uniqueProdis {
    return _allKhsData.map((e) => e.prodiName).toSet().toList();
  }

  // Mendapatkan daftar Kelas unik di bawah Prodi tertentu
  List<String> getUniqueKelasByProdi(String prodiName) {
    return _allKhsData
        .where((e) => e.prodiName == prodiName)
        .map((e) => e.kelasName)
        .toSet()
        .toList();
  }

  // Mendapatkan daftar mahasiswa di dalam kombinasi Prodi dan Kelas tertentu
  List<KhsData> getMahasiswaByKelas(String prodiName, String kelasName) {
    return _allKhsData
        .where((e) => e.prodiName == prodiName && e.kelasName == kelasName)
        .toList();
  }
}
