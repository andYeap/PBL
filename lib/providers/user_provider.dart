import 'dart:io';
import 'package:admin_pegawai/models/user_models.dart';
import 'package:admin_pegawai/services/user_service.dart';
import 'package:admin_pegawai/services/dosen_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final DosenService _dosenService = DosenService();

  bool _isLoading = false;
  int _totalUser = 0;
  int _totalRole = 0;
  int _totalDosen = 0;
  UserResponse? _data;
  File? _profileImage;
  List<UserResponse> _listUser = [];

  bool get isLoading => _isLoading;
  int get totalUser => _totalUser;
  int get totalRole => _totalRole;
  int get totalDosen => _totalDosen;
  UserResponse? get data => _data;
  File? get profileImage => _profileImage;
  List<UserResponse> get listUser => _listUser;

  Future<void> profile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _data = await _userService.profile();
    } catch (e) {
      debugPrint("Fetch Profile Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDashboardUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final responses = await Future.wait([
        _userService.fetchPaginatedUsers(1, 10),
        _userService.fetchTotalRoles(),
        _dosenService.fetchTotalDosen(),
      ]);

      final firstPageResult = responses[0] as UserPaginationResponse?;
      _totalRole = responses[1] as int;
      _totalDosen = responses[2] as int;

      if (firstPageResult != null) {
        _totalUser = firstPageResult.totalItems;
        List<UserResponse> temporaryList = List.from(firstPageResult.users);
        int totalPages = firstPageResult.totalPages;

        if (totalPages > 1) {
          final futures = List.generate(
            totalPages - 1,
            (index) => _userService.fetchPaginatedUsers(index + 2, 10),
          );

          final results = await Future.wait(futures);
          for (var subsequentResult in results) {
            if (subsequentResult != null) {
              temporaryList.addAll(subsequentResult.users);
            }
          }
        }
        _listUser = temporaryList;
      }
    } catch (e) {
      debugPrint("Error fetching dashboard user data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setProfile(File image) async {
    _profileImage = image;
    notifyListeners();
  }

  Future<void> getDataPengguna(String role) async {
    _isLoading = true;
    _listUser = [];
    notifyListeners();

    try {
      _listUser = (await _userService.getDataPengguna(role))!;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Gagal memuat data presensi: $e");
      _listUser = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUserData() {
    _data = null;
    _profileImage = null;
    _listUser = [];
    _totalUser = 0;
    _totalRole = 0;
    _totalDosen = 0;
    notifyListeners();
  }
}
