class PenggunaPegawaiResponse {
  final bool success;
  final String message;
  final int code;
  final List<PegawaiModel> data;

  PenggunaPegawaiResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory PenggunaPegawaiResponse.fromJson(Map<String, dynamic> json) {
    return PenggunaPegawaiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null
          ? List<PegawaiModel>.from(
              json['data'].map((x) => PegawaiModel.fromJson(x)),
            )
          : [],
    );
  }
}

class PegawaiModel {
  final String id;
  final String nip;
  final String nik;
  final String employeeName;
  final String address;
  final String birthPlace;
  final String birthDate;
  final String gender;
  final String phoneNumber;
  final Wilayah village;
  final Wilayah district;
  final Wilayah city;
  final Wilayah province;
  final Citizen citizen;

  PegawaiModel({
    required this.id,
    required this.nip,
    required this.nik,
    required this.employeeName,
    required this.address,
    required this.birthPlace,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.village,
    required this.district,
    required this.city,
    required this.province,
    required this.citizen,
  });

  factory PegawaiModel.fromJson(Map<String, dynamic> json) {
    return PegawaiModel(
      id: json['id'] ?? '',
      nip: json['nip'] ?? '',
      nik: json['nik'] ?? '',
      employeeName: json['employee_name'] ?? '',
      address: json['address'] ?? '',
      birthPlace: json['birth_place'] ?? '',
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      village: Wilayah.fromJson(json['village'] ?? {}),
      district: Wilayah.fromJson(json['district'] ?? {}),
      city: Wilayah.fromJson(json['city'] ?? {}),
      province: Wilayah.fromJson(json['province'] ?? {}),
      citizen: Citizen.fromJson(json['citizen'] ?? {}),
    );
  }
}

class Wilayah {
  final String id;
  final String code;
  final String name;

  Wilayah({required this.id, required this.code, required this.name});

  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Citizen {
  final String id;
  final String name;
  final String code;

  Citizen({required this.id, required this.name, required this.code});

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
