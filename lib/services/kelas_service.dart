import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/kelas_model.dart';
import 'api_client.dart'; // Sesuaikan dengan lokasi ApiClient Anda

class KelasService {
  final Dio _dio = ApiClient().dio;

  Future<KelasPaginationResponse?> fetchKelasPaginated({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        "/api/kelas",
        queryParameters: {"page": page, "per_page": perPage},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return KelasPaginationResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching kelas pagination: $e");
      return null;
    }
  }
}
