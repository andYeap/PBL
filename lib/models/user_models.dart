class UserResponse {
  final String id;
  final String name;
  final String email;
  final String roleName;
  final String? detailId;
  final String? imageUrl;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.roleName,
    this.imageUrl,
    this.detailId,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      roleName: json["role_name"] ?? '',
      detailId: json["detail_id"]?.toString(),
      imageUrl: json["image_url"],
    );
  }
}

class UserPaginationResponse {
  final int totalItems;
  final int totalPages;
  final List<UserResponse> users;

  UserPaginationResponse({
    required this.totalItems,
    required this.totalPages,
    required this.users,
  });

  factory UserPaginationResponse.fromJson(Map<String, dynamic> json) {
    final rootData = json['data'] ?? {};
    final pagination = rootData['pagination'] ?? {};
    final listItems = rootData['items'] as List? ?? [];

    return UserPaginationResponse(
      totalItems: pagination['total_items'] ?? 0,
      totalPages: pagination['total_pages'] ?? 0,
      users: listItems.map((e) => UserResponse.fromJson(e)).toList(),
    );
  }
}

class RolePaginationResponse {
  final int totalRoles;

  RolePaginationResponse({required this.totalRoles});

  factory RolePaginationResponse.fromJson(Map<String, dynamic> json) {
    final rootData = json['data'] ?? {};
    return RolePaginationResponse(totalRoles: rootData['total_items'] ?? 0);
  }
}

class UserCount {
  final int total;

  UserCount({required this.total});

  factory UserCount.fromJson(Map<String, dynamic> json) {
    final rootData = json['data'] ?? {};
    return UserCount(total: rootData['total_employee'] ?? 0);
  }
}
