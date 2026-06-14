class MataKuliah {
  final String id;
  final String kode;
  final String name;
  final int sks;

  MataKuliah({
    required this.id,
    required this.kode,
    required this.name,
    required this.sks,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'] ?? '',
      kode: json['kode'] ?? '',
      name: json['name'] ?? '',
      sks: json['sks'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'kode': kode, 'name': name, 'sks': sks};
  }
}

// Tambahkan class baru di bawah ini untuk menangani format Pagination
class MataKuliahPaginationResponse {
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final List<MataKuliah> items;

  MataKuliahPaginationResponse({
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.items,
  });

  factory MataKuliahPaginationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final pagination = data['pagination'] ?? {};
    final itemsList = data['items'] as List? ?? [];

    return MataKuliahPaginationResponse(
      page: pagination['page'] ?? 1,
      perPage: pagination['per_page'] ?? 10,
      totalItems: pagination['total_items'] ?? 0,
      totalPages: pagination['total_pages'] ?? 0,
      items: itemsList.map((i) => MataKuliah.fromJson(i)).toList(),
    );
  }
}
