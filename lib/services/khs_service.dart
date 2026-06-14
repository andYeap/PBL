import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/khs_model.dart';
import 'api_client.dart';

class KhsService {
  final Dio _dio = ApiClient().dio;

  Future<List<Khs>> fetchKhs({String? mahasiswaId}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (mahasiswaId != null) {
        queryParams['mahasiswa_id'] = mahasiswaId;
      }

      final response = await _dio.get(
        "/api/khs/",
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((item) => Khs.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching KHS data: $e");
      return [];
    }
  }
}
