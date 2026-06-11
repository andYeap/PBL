import 'package:admin_pegawai/utils/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  late final String kelompok1Url;
  late final String kelompok2Url;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    kelompok1Url = dotenv.get("KELOMPOK_1_BASE_URL");
    kelompok2Url = dotenv.get("KELOMPOK_2_BASE_URL");

    dio = Dio(
      BaseOptions(
        baseUrl: kelompok1Url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await TokenManager.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }
}
