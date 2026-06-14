import 'package:flutter/material.dart';
import '../models/mata_kuliah_model.dart';
import '../services/mata_kuliah_service.dart';

class MataKuliahProvider with ChangeNotifier {
  final MataKuliahService _service = MataKuliahService();

  List<MataKuliah> _listMataKuliah = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  bool _hasMoreData = true;

  // Getter
  List<MataKuliah> get listMataKuliah => _listMataKuliah;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;
  int get totalItems => _totalItems;

  /// Memuat data pertama kali (Page 1)
  Future<void> fetchInitialData({int perPage = 10}) async {
    _isLoading = true;
    _currentPage = 1;
    _listMataKuliah.clear();
    notifyListeners();

    final response = await _service.fetchMataKuliahPaginated(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listMataKuliah = response.items;
      _totalPages = response.totalPages;
      _totalItems = response.totalItems;
      _hasMoreData = _currentPage < _totalPages;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Memuat halaman berikutnya (Pagination)
  Future<void> fetchNextPage({int perPage = 10}) async {
    if (_isFetchingMore || !_hasMoreData) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final response = await _service.fetchMataKuliahPaginated(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listMataKuliah.addAll(response.items);
      _totalPages = response.totalPages;
      _hasMoreData = _currentPage < _totalPages;
    } else {
      _currentPage--;
    }

    _isFetchingMore = false;
    notifyListeners();
  }
}
