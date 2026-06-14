class ProdiResponse {
  final int id;
  final String nama;
  final String jenjang;
  final String jurusanNama;
  final int jurusanId; // Tambahkan properti ID Jurusan

  ProdiResponse({
    required this.id,
    required this.nama,
    required this.jenjang,
    required this.jurusanNama,
    required this.jurusanId, // Masukkan ke constructor
  });

  factory ProdiResponse.fromJson(Map<String, dynamic> json) {
    // Parsing data relasi objek 'jurusan' dengan aman
    final jurusanData = json['jurusan'] as Map<String, dynamic>?;
    final namaJurusan = jurusanData != null
        ? (jurusanData['name'] ?? json['jurusan_nama'] ?? '')
        : '';
    final idJurusan = jurusanData != null ? (jurusanData['id'] ?? 0) : 0;

    return ProdiResponse(
      id: json['id'] ?? 0,
      nama: json['name'] ?? json['nama'] ?? '',
      jenjang: json['jenjang'] ?? '',
      jurusanNama: namaJurusan,
      jurusanId: idJurusan, // Ikat ID di sini
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'jenjang': jenjang,
      'jurusan_nama': jurusanNama,
      'jurusan_id': jurusanId,
    };
  }
}
