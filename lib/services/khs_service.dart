import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/khs_model.dart';
import '../utils/token_manager.dart';

class KhsService {
  final Dio _dio = Dio();

  final String _baseUrl =
      dotenv.env['KELOMPOK_1_BASE_URL'] ?? 'https://be.karlearn.site';

  Future<List<KhsData>> fetchAllKhs() async {
    try {
      String? token = await TokenManager.getAccessToken();

      // Endpoint diarahkan ke baseUrl/api/khs
      final response = await _dio.get(
        '$_baseUrl/api/khs',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final khsResponse = KhsResponse.fromJson(response.data);
        return khsResponse.data;
      }
      return [];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          "Gagal mengambil data KHS: ${e.response?.data['message'] ?? e.message}",
        );
      }
      throw Exception("Koneksi ke server bermasalah.");
    }
  }
}
