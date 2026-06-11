import 'package:admin_pegawai/models/api_response.dart';
import 'package:admin_pegawai/models/paginate.dart';
import 'package:admin_pegawai/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';

class DosenService {
  final Dio _dio = ApiClient().dio;
  final String _kelompok2Url = ApiClient().kelompok2Url;

  Future<int> fetchTotalDosen() async {
    try {
      final response = await _dio.get(
        "$_kelompok2Url/api/employees/info/count",
      );

      if (response.statusCode == 200) {
        final data = UserCount.fromJson(response.data);
        return data.total;
      }
      return 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
}
