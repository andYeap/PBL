import 'package:flutter/material.dart';
import '../models/prodi_model.dart';
import '../services/prodi_service.dart';

class ProdiProvider with ChangeNotifier {
  final ProdiService _prodiService = ProdiService();

  bool _isLoading = false;
  List<ProdiResponse> _listProdi = [];
  ProdiResponse? selectedProdi;

  bool get isLoading => _isLoading;
  List<ProdiResponse> get listProdi => _listProdi;

  void setSelectedProdi(ProdiResponse? prodi) {
    selectedProdi = prodi;
    notifyListeners();
  }

  Future<void> fetchProdiData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _listProdi = await _prodiService.fetchProdi();
    } catch (e) {
      debugPrint("Error compiling prodi data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> editProdi(String nama, String jenjang) async {
    if (selectedProdi == null) return false;
    _isLoading = true;
    notifyListeners();

    String formattedName = nama.trim().toLowerCase().replaceAll(' ', '-');

    final updatedData = ProdiResponse(
      id: selectedProdi!.id,
      nama: formattedName,
      jenjang: jenjang,
      jurusanNama: selectedProdi!.jurusanNama,
      jurusanId: selectedProdi!.jurusanId,
    );

    bool isSuccess = await _prodiService.updateProdi(updatedData);
    if (isSuccess) {
      selectedProdi = updatedData;
      int idx = _listProdi.indexWhere(
        (element) => element.id == updatedData.id,
      );
      if (idx != -1) _listProdi[idx] = updatedData;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> removeProdi() async {
    if (selectedProdi == null) return false;
    _isLoading = true;
    notifyListeners();

    bool isSuccess = await _prodiService.deleteProdi(selectedProdi!.id);
    if (isSuccess) {
      _listProdi.removeWhere((element) => element.id == selectedProdi!.id);
      selectedProdi = null;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}
