import 'tahun_akademik_model.dart';
import 'kurikulum_model.dart'; // Untuk mendapatkan KurikulumProdi dan KurikulumModel
import 'mahasiswa_model.dart';

class Kelas {
  final String id;
  final String name;
  final int semester;
  final TahunAkademik? tahunAkademik;
  final KurikulumProdi? prodi;
  final KurikulumModel? kurikulum; 
  final List<Mahasiswa> mahasiswa;

  Kelas({
    required this.id,
    required this.name,
    required this.semester,
    this.tahunAkademik,
    this.prodi,
    this.kurikulum, // Gunakan kurikulum di sini
    required this.mahasiswa,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    var listMhs = json['mahasiswa'] as List? ?? [];
    List<Mahasiswa> mhsList = listMhs
        .map((i) => Mahasiswa.fromJson(i))
        .toList();

    return Kelas(
      id: json['id'] ?? '',
      name: json['name'] ?? json['nama'] ?? '',
      semester: json['semester'] ?? 1,
      tahunAkademik: json['tahun_akademik'] != null
          ? TahunAkademik.fromJson(json['tahun_akademik'])
          : null,
      prodi: json['prodi'] != null
          ? KurikulumProdi.fromJson(json['prodi'])
          : null,
      kurikulum: json['kurikulum'] != null
          ? KurikulumModel.fromJson(json['kurikulum'])
          : null,
      mahasiswa: mhsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'tahun_akademik_id': tahunAkademik?.id,
      'prodi_id': prodi?.id,
      'kurikulum_kode': kurikulum?.kode,
    };
  }
}

class KelasPaginationResponse {
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final List<Kelas> items;

  KelasPaginationResponse({
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.items,
  });

  factory KelasPaginationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final pagination = data['pagination'] ?? {};
    final itemsList = data['items'] as List? ?? [];

    return KelasPaginationResponse(
      page: pagination['page'] ?? 1,
      perPage: pagination['per_page'] ?? 10,
      totalItems: pagination['total_items'] ?? 0,
      totalPages: pagination['total_pages'] ?? 0,
      items: itemsList.map((i) => Kelas.fromJson(i)).toList(),
    );
  }
}
