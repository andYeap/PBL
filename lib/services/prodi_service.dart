import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/prodi_model.dart';
import 'api_client.dart';

class ProdiService {
  final Dio _dio = ApiClient().dio;

  Future<List<ProdiResponse>> fetchProdi() async {
    try {
      final response = await _dio.get("/api/prodi"); // Sesuaikan endpoint kamu

      // SKENARIO 1: Jika API langsung mengembalikan Array/List: [ {id: 1, ...}, ... ]
      if (response.data is List) {
        final List<dynamic> dataList = response.data;
        return dataList.map((item) => ProdiResponse.fromJson(item)).toList();
      }
      // SKENARIO 2: Jika API mengembalikan Objek bersarang: { "success": true, "data": [ ... ] }
      else if (response.data is Map<String, dynamic>) {
        final mapData = response.data as Map<String, dynamic>;

        // Ambil bagian data-nya
        final dynamic rawData = mapData["data"] ?? mapData["items"];

        List<dynamic> dataList = [];
        if (rawData is List) {
          dataList = rawData;
        } else if (rawData is Map && rawData["items"] != null) {
          dataList = rawData["items"];
        }

        return dataList.map((item) => ProdiResponse.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      debugPrint("Error fetching prodi: $e"); // Sekarang harusnya error hilang
      return [];
    }
  }

  Future<bool> updateProdi(ProdiResponse prodi) async {
    try {
      final response = await _dio.put(
        "/api/prodi/${prodi.id}",
        data: prodi.toJson(),
      );
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error updating prodi: $e");
      return false;
    }
  }

  Future<bool> deleteProdi(int id) async {
    try {
      final response = await _dio.delete("/api/prodi/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error deleting prodi: $e");
      return false;
    }
  }
}
