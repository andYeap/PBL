class KhsResponse {
  final bool success;
  final String message;
  final String path;
  final List<KhsData> data;

  KhsResponse({
    required this.success,
    required this.message,
    required this.path,
    required this.data,
  });

  factory KhsResponse.fromJson(Map<String, dynamic> json) {
    return KhsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      path: json['path'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => KhsData.fromJson(item))
          .toList(),
    );
  }
}

class KhsData {
  final String mahasiswaName;
  final int semester;
  final String prodiName;
  final String kelasName;
  final int tahunAkademik;
  final String kurikulumName;
  final double ips;
  final double ipk;
  final List<NilaiMatakuliah> nilai;

  KhsData({
    required this.mahasiswaName,
    required this.semester,
    required this.prodiName,
    required this.kelasName,
    required this.tahunAkademik,
    required this.kurikulumName,
    required this.ips,
    required this.ipk,
    required this.nilai,
  });

  factory KhsData.fromJson(Map<String, dynamic> json) {
    return KhsData(
      mahasiswaName: json['mahasiswa_name'] ?? '',
      semester: json['semester'] ?? 1,
      prodiName: json['prodi_name'] ?? '',
      kelasName: json['kelas_name'] ?? '',
      tahunAkademik: json['tahun_akademik'] ?? 0,
      kurikulumName: json['kurikulum_name'] ?? '',
      ips: (json['ips'] as num?)?.toDouble() ?? 0.0,
      ipk: (json['ipk'] as num?)?.toDouble() ?? 0.0,
      nilai: (json['nilai'] as List? ?? [])
          .map((item) => NilaiMatakuliah.fromJson(item))
          .toList(),
    );
  }
}

class NilaiMatakuliah {
  final String kodeMk;
  final String namaMk;
  final int sks;
  final double nilai;
  final String grade;

  NilaiMatakuliah({
    required this.kodeMk,
    required this.namaMk,
    required this.sks,
    required this.nilai,
    required this.grade,
  });

  factory NilaiMatakuliah.fromJson(Map<String, dynamic> json) {
    return NilaiMatakuliah(
      kodeMk: json['kode_mk'] ?? '',
      namaMk: json['nama_mk'] ?? '',
      sks: json['sks'] ?? 0,
      nilai: (json['nilai'] as num?)?.toDouble() ?? 0.0,
      grade: json['grade'] ?? '-',
    );
  }
}
