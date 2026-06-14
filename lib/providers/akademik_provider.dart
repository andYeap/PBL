import 'package:flutter/material.dart';
import '../models/akademik_models.dart';
import '../services/akademik_service.dart';

class AkademikProvider with ChangeNotifier {
  final AkademikService _akademikService = AkademikService();

  bool _isLoading = false;

  // Menyisakan state yang BELUM dibuatkan provider terpisah
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

  /// Fungsi untuk menarik data segar murni dari server API
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
    } finally {
      // Amankan loading state menggunakan block finally agar tidak stuck
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fungsi Edit yang sudah diperbaiki agar sinkron penuh dengan server backend
  Future<bool> editTahunAkademik(String tahunAwal, String tahunAkhir) async {
    if (selectedTahunAkademik == null) return false;

    _isLoading = true;
    notifyListeners();

    // Mengonstruksi objek baru dengan menyuntikkan input modifikasi dari form teks UI
    final updatedData = TahunAkademik(
      id: selectedTahunAkademik!.id,
      tipeSemester: selectedTahunAkademik!.tipeSemester,
      tahunAwal: tahunAwal,
      tahunAkhir: tahunAkhir,
      status: selectedTahunAkademik!.status,
    );

    try {
      bool isSuccess = await _akademikService.updateTahunAkademik(updatedData);

      if (isSuccess) {
        // Jika server sukses mengubah data, sinkronisasikan objek selected lokal saat ini
        selectedTahunAkademik = updatedData;

        // LANGKAH KRUSIAL: Tarik data murni terbaru dari database server
        // Ini menjamin data UI di dashboard dan halaman list 100% akurat dengan backend
        final freshData = await _akademikService.fetchTahunAkademik();
        if (freshData.isNotEmpty) {
          _listTahunAkademik = freshData;
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error inside provider editTahunAkademik: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fungsi Hapus yang sudah distandarisasi penanganan loading-nya
  Future<bool> removeTahunAkademik() async {
    if (selectedTahunAkademik == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _akademikService.deleteTahunAkademik(
        selectedTahunAkademik!.id,
      );

      if (isSuccess) {
        _listTahunAkademik.removeWhere(
          (element) => element.id == selectedTahunAkademik!.id,
        );
        selectedTahunAkademik = null;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error inside provider removeTahunAkademik: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
