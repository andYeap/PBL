class Mahasiswa {
  final String mahasiswaId;
  final String name;
  final String email;

  Mahasiswa({
    required this.mahasiswaId,
    required this.name,
    required this.email,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      mahasiswaId: json['mahasiswa_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
