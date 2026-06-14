import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/mata_kuliah_model.dart';
import 'api_client.dart'; // Sesuaikan path ApiClient Anda

class MataKuliahService {
  final Dio _dio = ApiClient().dio;

  Future<MataKuliahPaginationResponse?> fetchMataKuliahPaginated({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        "/api/mata-kuliah",
        queryParameters: {"page": page, "per_page": perPage},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return MataKuliahPaginationResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching mata kuliah: $e");
      return null;
    }
  }
}
