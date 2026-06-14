import 'package:flutter/material.dart';
import '../models/khs_model.dart';
import '../services/khs_service.dart';

class KhsProvider with ChangeNotifier {
  final KhsService _khsService = KhsService();

  bool _isLoading = false;
  List<Khs> _listKhs = [];
  Khs? _selectedKhs;

  // Getter
  bool get isLoading => _isLoading;
  List<Khs> get listKhs => _listKhs;
  Khs? get selectedKhs => _selectedKhs;

  // Setter untuk memilih KHS tertentu di UI (jika diperlukan)
  void setSelectedKhs(Khs? khs) {
    _selectedKhs = khs;
    notifyListeners();
  }

  /// Fungsi untuk memuat data KHS dari Service ke Provider
  Future<void> fetchKhsData({String? mahasiswaId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _listKhs = await _khsService.fetchKhs(mahasiswaId: mahasiswaId);

      // Jika data berhasil diambil dan tidak kosong, set data pertama sebagai default pilihan
      if (_listKhs.isNotEmpty) {
        _selectedKhs = _listKhs.first;
      } else {
        _selectedKhs = null;
      }
    } catch (e) {
      debugPrint("Error compiling KHS provider data: $e");
      _listKhs = [];
      _selectedKhs = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
