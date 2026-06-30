import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/paginate.dart';
import '../models/pengguna_dosen_model.dart';
import 'api_client.dart';

class PenggunaDosenService {
  final Dio _dio = ApiClient().dio;

  Future<List<DosenResponse>?> getDataDosen() async {
    try {
      final response = await _dio.get("/api/users/roles/dosen");

      if (response.statusCode == 200) {
        final parsedData = ApiResponse<Paginate<List<DosenResponse>>>.fromJson(
          response.data,
          (json) => Paginate.fromJson(
            json,
            (item) => (item as List)
                .map((x) => DosenResponse.fromJson(x as Map<String, dynamic>))
                .toList(),
          ),
        );
        return parsedData.data?.items;
      }
      return null;
    } catch (e) {
      debugPrint("Error Fetching Dosen: $e");
      return null;
    }
  }
}
