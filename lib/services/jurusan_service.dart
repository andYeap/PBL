import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/jurusan_model.dart';
import 'api_client.dart'; // Pastikan path ini sesuai

class JurusanService {
  // Menggunakan ApiClient yang sama dengan KelasService dan ProdiService
  final Dio _dio = ApiClient().dio;

  Future<List<JurusanModel>> getAllJurusan() async {
    try {
      final response = await _dio.get('/api/jurusan');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> listData = data['data'];
          return listData.map((item) => JurusanModel.fromJson(item)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint("DioError fetching jurusan: $e");
      return [];
    } catch (e) {
      debugPrint("Error fetching jurusan: $e");
      return [];
    }
  }

  Future<bool> updateJurusan(int id, String name) async {
    try {
      final response = await _dio.put('/api/jurusan/$id', data: {'name': name});
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("Error updating jurusan: $e");
      return false;
    }
  }

  Future<bool> deleteJurusan(int id) async {
    try {
      final response = await _dio.delete('/api/jurusan/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("Error deleting jurusan: $e");
      return false;
    }
  }
}
