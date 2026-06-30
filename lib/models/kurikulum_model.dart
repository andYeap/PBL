import 'mata_kuliah_model.dart';

// Helper function untuk mengubah "teknik-informatika" menjadi "Teknik Informatika"
String _convertToTitleCase(String text) {
  if (text.isEmpty) return '';
  String spacingText = text.replaceAll(RegExp(r'[-_]'), ' ');
  return spacingText
      .split(' ')
      .map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

class KurikulumJurusan {
  final int id;
  final String name;

  KurikulumJurusan({required this.id, required this.name});

  factory KurikulumJurusan.fromJson(Map<String, dynamic> json) {
    String rawName = json['name'] ?? '';
    return KurikulumJurusan(
      id: json['id'] ?? 0,
      name: _convertToTitleCase(rawName), // Format di sini
    );
  }
}

class KurikulumProdi {
  final int id;
  final String name;
  final String jenjang;
  final KurikulumJurusan jurusan;

  KurikulumProdi({
    required this.id,
    required this.name,
    required this.jenjang,
    required this.jurusan,
  });

  factory KurikulumProdi.fromJson(Map<String, dynamic> json) {
    String rawName = json['name'] ?? '';
    return KurikulumProdi(
      id: json['id'] ?? 0,
      name: _convertToTitleCase(rawName), // Format di sini
      jenjang: json['jenjang'] ?? '',
      jurusan: KurikulumJurusan.fromJson(json['jurusan'] ?? {}),
    );
  }
}

class KurikulumMk {
  final int semester;
  final bool wajib;
  final MataKuliah mataKuliah;

  KurikulumMk({
    required this.semester,
    required this.wajib,
    required this.mataKuliah,
  });

  factory KurikulumMk.fromJson(Map<String, dynamic> json) {
    return KurikulumMk(
      semester: json['semester'] ?? 0,
      wajib: json['wajib'] ?? false,
      mataKuliah: MataKuliah.fromJson(json['mata_kuliah'] ?? {}),
    );
  }
}

class KurikulumModel {
  final String id;
  final String kode;
  final String name;
  final KurikulumProdi prodi;
  final List<KurikulumMk> kurikulumMk;

  KurikulumModel({
    required this.id,
    required this.kode,
    required this.name,
    required this.prodi,
    required this.kurikulumMk,
  });

  factory KurikulumModel.fromJson(Map<String, dynamic> json) {
    var list = json['kurikulum_mk'] as List? ?? [];
    List<KurikulumMk> mkList = list
        .map((i) => KurikulumMk.fromJson(i))
        .toList();

    return KurikulumModel(
      id: json['id'] ?? '',
      kode: json['kode'] ?? '',
      name: json['name'] ?? '',
      prodi: KurikulumProdi.fromJson(json['prodi'] ?? {}),
      kurikulumMk: mkList,
    );
  }
}

class KurikulumPaginationResponse {
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final List<KurikulumModel> items;

  KurikulumPaginationResponse({
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.items,
  });

  factory KurikulumPaginationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final pagination = data['pagination'] ?? {};
    final itemsList = data['items'] as List? ?? [];

    return KurikulumPaginationResponse(
      page: pagination['page'] ?? 1,
      perPage: pagination['per_page'] ?? 10,
      totalItems: pagination['total_items'] ?? 0,
      totalPages: pagination['total_pages'] ?? 0,
      items: itemsList.map((i) => KurikulumModel.fromJson(i)).toList(),
    );
  }
}
