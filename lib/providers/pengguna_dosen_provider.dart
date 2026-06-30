import 'package:flutter/material.dart';
import '../models/pengguna_dosen_model.dart';
import '../services/pengguna_dosen_service.dart';

class PenggunaDosenProvider with ChangeNotifier {
  final PenggunaDosenService _service = PenggunaDosenService();

  List<DosenResponse> _listDosen = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<DosenResponse> get listDosen => _listDosen;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getDosenData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await _service.getDataDosen();
      if (data != null) {
        _listDosen = data;
      } else {
        _errorMessage = "Gagal mendapatkan data dosen dari server.";
      }
    } catch (e) {
      _errorMessage = "Terjadi kesalahan jaringan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
