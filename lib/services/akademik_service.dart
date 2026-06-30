import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/akademik_models.dart';
import 'api_client.dart';

class AkademikService {
  final Dio _dio = ApiClient().dio;

  Future<List<TahunAkademik>> fetchTahunAkademik() async {
    try {
      final response = await _dio.get("/api/tahun-akademik");
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((item) => TahunAkademik.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching tahun akademik: $e");
      return [];
    }
  }

  Future<KurikulumPaginationResponse?> fetchKurikulum(
    int page,
    int perPage,
  ) async {
    try {
      final response = await _dio.get(
        "/api/kurikulum",
        queryParameters: {"page": page, "perPage": perPage},
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

  Future<List<ProdiResponse>> fetchProdi() async {
    try {
      final response = await _dio.get("/api/prodi");
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"]["items"];
        return data.map((item) => ProdiResponse.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching prodi: $e");
      return [];
    }
  }

  Future<KelasPaginationResponse?> fetchKelasPagination(
    int page,
    int perPage,
  ) async {
    try {
      final response = await _dio.get(
        "/api/kelas",
        queryParameters: {"page": page, "perPage": perPage},
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

  Future<bool> updateKelas(Kelas kelas) async {
    try {
      final response = await _dio.put(
        "/api/kelas/${kelas.id}",
        data: kelas.toJson(),
      );
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error updating kelas: $e");
      return false;
    }
  }

  Future<bool> deleteKelas(String id) async {
    try {
      final response = await _dio.delete("/api/kelas/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error deleting kelas: $e");
      return false;
    }
  }

  Future<List<KhsData>> fetchKhs() async {
    try {
      final response = await _dio.get("/api/khs");
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((item) => KhsData.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching khs: $e");
      return [];
    }
  }

  Future<List<Nilai>> fetchNilai() async {
    try {
      final response = await _dio.get("/api/nilai");
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((item) => Nilai.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching nilai: $e");
      return [];
    }
  }

  Future<List<MataKuliah>> fetchMataKuliah() async {
    try {
      final response = await _dio.get("/api/mata-kuliah");
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"]["items"];
        return data.map((item) => MataKuliah.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching mata kuliah: $e");
      return [];
    }
  }

  Future<bool> updateMataKuliah(MataKuliah mk) async {
    try {
      final response = await _dio.put(
        "/api/mata-kuliah/${mk.id}",
        data: mk.toJson(),
      );
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error updating mata kuliah: $e");
      return false;
    }
  }

  Future<bool> deleteMataKuliah(String id) async {
    try {
      final response = await _dio.delete("/api/mata-kuliah/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error deleting mata kuliah: $e");
      return false;
    }
  }

  Future<bool> updateTahunAkademik(TahunAkademik ta) async {
    try {
      debugPrint("Target URL: /api/tahun-akademik/${ta.id}");
      debugPrint("Payload Body (JSON): ${ta.toJson()}");

      final response = await _dio.put(
        "/api/tahun-akademik/${ta.id}",
        data: ta
            .toJson(),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      if (e is DioException && e.response != null) {
        debugPrint("Server Error Details: ${e.response?.data}");
      } else {
        debugPrint("Error updating tahun akademik: $e");
      }
      return false;
    }
  }

  Future<bool> deleteTahunAkademik(int id) async {
    try {
      final response = await _dio.delete("/api/tahun-akademik/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      debugPrint("Error deleting tahun akademik: $e");
      return false;
    }
  }
}
