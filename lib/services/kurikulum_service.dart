import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/kurikulum_model.dart';
import 'api_client.dart'; // Sesuaikan path dengan ApiClient Anda

class KurikulumService {
  final Dio _dio = ApiClient().dio;

  Future<KurikulumPaginationResponse?> fetchKurikulum({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        "/api/kurikulum",
        queryParameters: {"page": page, "per_page": perPage},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return KurikulumPaginationResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching kurikulum: $e");
      return null;
    }
  }

  Future<bool> updateKurikulumRaw({
    required String kode,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _dio.put("/api/kurikulum/$kode", data: payload);
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      return false;
    }
  }
}
