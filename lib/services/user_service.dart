import 'package:admin_pegawai/models/api_response.dart';
import 'package:admin_pegawai/models/paginate.dart';
import 'package:admin_pegawai/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';

class UserService {
  final Dio _dio = ApiClient().dio;

  Future<UserResponse?> profile() async {
    try {
      final response = await _dio.get("/api/me");
      debugPrint("Hit api: ${response.data}");

      if (response.statusCode == 200) {
        final result = ApiResponse<UserResponse>.fromJson(
          response.data,
          (item) => UserResponse.fromJson(item),
        );
        debugPrint(result.data.toString());
        return result.data;
      }
      debugPrint("samting wong");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<int> fetchTotalRoles() async {
    try {
      final response = await _dio.get("/api/roles");

      if (response.statusCode == 200) {
        final data = RolePaginationResponse.fromJson(response.data);
        return data.totalRoles;
      }
      return 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<UserPaginationResponse?> fetchPaginatedUsers(
    int page,
    int perPage,
  ) async {
    try {
      final response = await _dio.get(
        "/api/users",
        queryParameters: {"page": page, "perPage": perPage},
      );

      if (response.statusCode == 200) {
        return UserPaginationResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint("Error pagination: $e");
      return null;
    }
  }

  Future<List<UserResponse>?> getDataPengguna(String role) async {
    try {
      final response = await _dio.get("/api/users/roles/$role");

      if (response.statusCode == 200) {
        final data = ApiResponse<Paginate<List<UserResponse>>>.fromJson(
          response.data,
          (json) => Paginate.fromJson(
            json,
            (item) => (item as List)
                .map(
                  (item) => UserResponse.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
          ),
        );
        return data.data!.items;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
