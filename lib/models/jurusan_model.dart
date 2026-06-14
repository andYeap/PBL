class JurusanModel {
  final int id;
  final String name;

  JurusanModel({required this.id, required this.name});

  factory JurusanModel.fromJson(Map<String, dynamic> json) {
    return JurusanModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  String get displayName {
    if (name.isEmpty) return '';
    return name
        .split('-')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }
}
