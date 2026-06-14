import 'package:flutter/material.dart';
import '../models/kelas_model.dart';
import '../services/kelas_service.dart';

class KelasProvider with ChangeNotifier {
  final KelasService _service = KelasService();

  List<Kelas> _listKelas = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;

  // Getter
  List<Kelas> get listKelas => _listKelas;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;

  /// Fetch data halaman pertama
  Future<void> fetchInitialData({int perPage = 10}) async {
    _isLoading = true;
    _currentPage = 1;
    _listKelas.clear();
    notifyListeners();

    final response = await _service.fetchKelasPaginated(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listKelas = response.items;
      _totalPages = response.totalPages;
      _hasMoreData = _currentPage < _totalPages;
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Memuat data tambahan saat scroll
  Future<void> fetchNextPage({int perPage = 10}) async {
    if (_isFetchingMore || !_hasMoreData) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final response = await _service.fetchKelasPaginated(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listKelas.addAll(response.items);
      _totalPages = response.totalPages;
      _hasMoreData = _currentPage < _totalPages;
    } else {
      // Rollback jika request error
      _currentPage--;
    }

    _isFetchingMore = false;
    notifyListeners();
  }
}
