class Khs {
  final String mahasiswaName;
  final int semester;
  final String prodiName;
  final String kelasName;
  final int tahunAkademik;
  final String kurikulumName;
  final double ips;
  final double ipk;
  final List<KhsNilai> listNilai;

  Khs({
    required this.mahasiswaName,
    required this.semester,
    required this.prodiName,
    required this.kelasName,
    required this.tahunAkademik,
    required this.kurikulumName,
    required this.ips,
    required this.ipk,
    required this.listNilai,
  });

  factory Khs.fromJson(Map<String, dynamic> json) {
    var list = json['nilai'] as List?;
    List<KhsNilai> nilaiList = list != null
        ? list.map((i) => KhsNilai.fromJson(i)).toList()
        : [];

    return Khs(
      mahasiswaName: json['mahasiswa_name'] ?? '',
      semester: json['semester'] ?? 1,
      prodiName: json['prodi_name'] ?? '',
      kelasName: json['kelas_name'] ?? '',
      tahunAkademik: json['tahun_akademik'] ?? 0,
      kurikulumName: json['kurikulum_name'] ?? '',
      ips: (json['ips'] ?? 0).toDouble(),
      ipk: (json['ipk'] ?? 0).toDouble(),
      listNilai: nilaiList,
    );
  }
}

class KhsNilai {
  final String kodeMk;
  final String namaMk;
  final int sks;
  final double nilai;
  final String grade;

  KhsNilai({
    required this.kodeMk,
    required this.namaMk,
    required this.sks,
    required this.nilai,
    required this.grade,
  });

  factory KhsNilai.fromJson(Map<String, dynamic> json) {
    return KhsNilai(
      kodeMk: json['kode_mk'] ?? '',
      namaMk: json['nama_mk'] ?? '',
      sks: json['sks'] ?? 0,
      nilai: (json['nilai'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
    );
  }
}
