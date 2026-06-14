class TahunAkademik {
  final dynamic
  id;
  final String tipeSemester;
  final String tahunAwal;
  final String tahunAkhir;
  final String status;

  TahunAkademik({
    required this.id,
    required this.tipeSemester,
    required this.tahunAwal,
    required this.tahunAkhir,
    required this.status,
  });

  factory TahunAkademik.fromJson(Map<String, dynamic> json) {
    return TahunAkademik(
      id: json["id"],
      tipeSemester: json["tipee_semester"] ?? json["tipe_semester"] ?? '',
      tahunAwal: json["tahun_awal"] ?? '',
      tahunAkhir: json["tahun_akhir"] ?? '',
      status: json["status"] ?? '',
    );
  }

  // Tambahkan fungsi toJson agar konversi payload ke service lebih rapi
  Map<String, dynamic> toJson() {
    return {
      "tipe_semester": tipeSemester,
      "tahun_awal": tahunAwal,
      "tahun_akhir": tahunAkhir,
      "status": status,
    };
  }
}
