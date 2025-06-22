//lib/models/user/user_update_profile.dart
class UserUpdateProfile {
  final String? namaLengkap;
  final String? email;
  final int? nik;
  final int? noHandphone;
  final String? fotoProfil;

  UserUpdateProfile({
    this.namaLengkap,
    this.email,
    this.nik,
    this.noHandphone,
    this.fotoProfil,
  });

  /// Parsing dari JSON ke model
  factory UserUpdateProfile.fromJson(Map<String, dynamic> json) {
    return UserUpdateProfile(
      namaLengkap: json['nama_Lengkap'],
      email: json['email'],
      nik: _parseToInt(json['nik']),
      noHandphone: _parseToInt(json['no_Handphone']),
      fotoProfil: json['foto_Profil'],
    );
  }

  /// Helper untuk parsing dynamic ke int safely
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Convert model ke JSON (lengkap)
  Map<String, dynamic> toJson() {
    return {
      'nama_Lengkap': namaLengkap ?? "",
      'email': email ?? "",
      'nik': nik ?? 0,
      'no_Handphone': noHandphone ?? 0,
      'foto_Profil': fotoProfil ?? "",
    };
  }

  /// Convert model ke JSON (hanya field yang diisi)
  Map<String, dynamic> toJsonOnlyUpdated() {
    final Map<String, dynamic> data = {};
    if (namaLengkap?.isNotEmpty ?? false) data['nama_Lengkap'] = namaLengkap;
    if (email?.isNotEmpty ?? false) data['email'] = email;
    if (nik != null && nik! > 0) data['nik'] = nik;
    if (noHandphone != null && noHandphone! > 0) data['no_Handphone'] = noHandphone;
    if (fotoProfil?.isNotEmpty ?? false) data['foto_Profil'] = fotoProfil;
    return data;
  }

  /// Copy instance existing dengan perubahan
  UserUpdateProfile copyWith({
    String? namaLengkap,
    String? email,
    String? password,
    int? nik,
    int? noHandphone,
    String? fotoProfil,
  }) {
    return UserUpdateProfile(
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      noHandphone: noHandphone ?? this.noHandphone,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }

  @override
  String toString() {
    return 'UserUpdateProfile(namaLengkap: $namaLengkap, email: $email, nik: $nik, noHandphone: $noHandphone, fotoProfil: $fotoProfil)';
  }
}
