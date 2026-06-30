class DosenResponse {
  final String id;
  final String name;
  final String email;
  final String roleName;
  final String detailId;
  final String? imageUrl;

  DosenResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.roleName,
    required this.detailId,
    this.imageUrl,
  });

  factory DosenResponse.fromJson(Map<String, dynamic> json) {
    return DosenResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleName: json['role_name'] ?? '',
      detailId: json['detail_id'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
