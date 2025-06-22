// models/user/user_profile.dart
class UserProfile {
  final int idUser;
  final String namaLengkap;
  final String email;
  final String password;
  final int nik;
  final int noHandphone;
  final String fotoProfil;

  UserProfile({
    required this.idUser,
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.nik,
    required this.noHandphone,
    required this.fotoProfil,
  });

  // Factory constructor untuk parsing dari JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      idUser: json['id_User'] ?? 0,
      namaLengkap: json['nama_Lengkap'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      // Handle parsing untuk bigint - bisa jadi string atau int
      nik: _parseToInt(json['nik']),
      noHandphone: _parseToInt(json['no_Handphone']),
      fotoProfil: json['foto_Profil'] ?? '',
    );
  }

  // Helper method untuk parsing int/bigint
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Method untuk convert ke JSON (jika diperlukan untuk update)
  Map<String, dynamic> toJson() {
    return {
      'id_User': idUser,
      'nama_Lengkap': namaLengkap,
      'email': email,
      'password': password,
      'nik': nik,
      'no_Handphone': noHandphone,
      'foto_Profil': fotoProfil,
    };
  }

  // CopyWith method untuk membuat instance baru dengan beberapa field yang diubah
  UserProfile copyWith({
    int? idUser,
    String? namaLengkap,
    String? email,
    String? password,
    int? nik,
    int? noHandphone,
    String? fotoProfil,
  }) {
    return UserProfile(
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      password: password ?? this.password,
      nik: nik ?? this.nik,
      noHandphone: noHandphone ?? this.noHandphone,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }

  @override
  String toString() {
    return 'UserProfile(idUser: $idUser, namaLengkap: $namaLengkap, email: $email)';
  }
}