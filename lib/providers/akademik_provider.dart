import 'package:flutter/material.dart';
import '../models/akademik_models.dart';
import '../services/akademik_service.dart';

class AkademikProvider with ChangeNotifier {
  final AkademikService _akademikService = AkademikService();

  bool _isLoading = false;

  // Hanya menyisakan state yang BELUM dibuatkan provider terpisah
  List<TahunAkademik> _listTahunAkademik = [];
  List<Nilai> _listNilai = [];

  TahunAkademik? selectedTahunAkademik;

  // Getter
  bool get isLoading => _isLoading;
  List<TahunAkademik> get listTahunAkademik => _listTahunAkademik;
  List<Nilai> get listNilai => _listNilai;

  void setSelectedTahunAkademik(TahunAkademik? ta) {
    selectedTahunAkademik = ta;
    notifyListeners();
  }

  // Hanya memuat data yang tersisa di provider ini
  Future<void> fetchAkademikData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final responses = await Future.wait([
        _akademikService.fetchTahunAkademik(),
        _akademikService.fetchNilai(),
      ]);

      _listTahunAkademik = responses[0] as List<TahunAkademik>;
      _listNilai = responses[1] as List<Nilai>;
    } catch (e) {
      debugPrint("Error fetching akademik data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> editTahunAkademik(String tahunAwal, String tahunAkhir) async {
    if (selectedTahunAkademik == null) return false;
    _isLoading = true;
    notifyListeners();

    final updatedData = TahunAkademik(
      id: selectedTahunAkademik!.id,
      tipeSemester: selectedTahunAkademik!.tipeSemester,
      tahunAwal: tahunAwal,
      tahunAkhir: tahunAkhir,
      status: selectedTahunAkademik!.status,
    );

    bool isSuccess = await _akademikService.updateTahunAkademik(updatedData);
    if (isSuccess) {
      selectedTahunAkademik = updatedData;
      int idx = _listTahunAkademik.indexWhere(
        (element) => element.id == updatedData.id,
      );
      if (idx != -1) _listTahunAkademik[idx] = updatedData;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> removeTahunAkademik() async {
    if (selectedTahunAkademik == null) return false;
    _isLoading = true;
    notifyListeners();

    bool isSuccess = await _akademikService.deleteTahunAkademik(
      selectedTahunAkademik!.id,
    );
    if (isSuccess) {
      _listTahunAkademik.removeWhere(
        (element) => element.id == selectedTahunAkademik!.id,
      );
      selectedTahunAkademik = null;
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}
