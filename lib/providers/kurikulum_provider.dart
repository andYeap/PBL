import 'package:flutter/material.dart';
import '../models/kurikulum_model.dart';
import '../services/kurikulum_service.dart';

class KurikulumProvider with ChangeNotifier {
  final KurikulumService _service = KurikulumService();

  List<KurikulumModel> _listKurikulum = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;

  List<KurikulumModel> get listKurikulum => _listKurikulum;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchInitialData({int perPage = 10}) async {
    _isLoading = true;
    _currentPage = 1;
    _listKurikulum.clear();
    notifyListeners();

    final response = await _service.fetchKurikulum(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listKurikulum = response.items;
      _totalPages = response.totalPages;
      _hasMoreData = _currentPage < _totalPages;
    }

    _isLoading = false;
    notifyListeners();
  }

  

  Future<void> fetchNextPage({int perPage = 10}) async {
    if (_isFetchingMore || !_hasMoreData) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final response = await _service.fetchKurikulum(
      page: _currentPage,
      perPage: perPage,
    );

    if (response != null) {
      _listKurikulum.addAll(response.items);
      _totalPages = response.totalPages;
      _hasMoreData = _currentPage < _totalPages;
    } else {
      _currentPage--;
    }

    _isFetchingMore = false;
    notifyListeners();
  }
}
