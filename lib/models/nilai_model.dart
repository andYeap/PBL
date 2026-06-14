class Nilai {
  final int id;
  final double angka;

  Nilai({required this.id, required this.angka});

  factory Nilai.fromJson(Map<String, dynamic> json) {
    return Nilai(id: json['id'] ?? 0, angka: (json['angka'] ?? 0).toDouble());
  }
}
