// Flutter Admin Model - DIPERBAIKI
class Admin {
  final int idAdmin;
  final String nama;
  final String email;
  final String noHandphone;
  final String fotoProfil;

  Admin({
    required this.idAdmin,
    required this.nama,
    required this.email,
    required this.noHandphone,
    required this.fotoProfil,
  });

  // PERBAIKAN: Fix parsing dari JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      // PERBAIKAN: Jangan assign nilai 1, ambil dari JSON yang sebenarnya
      idAdmin: json['id_Admin'] ?? json['idAdmin'] ?? 1,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      // PERBAIKAN: Handle berbagai format nomor handphone
      noHandphone: _parsePhoneNumber(json['no_Handphone'] ?? json['noHandphone']),
      fotoProfil: json['foto_Profil'] ?? json['fotoProfil'] ?? '',
    );
  }

  // Helper method untuk parse nomor handphone
  static String _parsePhoneNumber(dynamic phoneValue) {
    if (phoneValue == null) return '';
    
    // Jika sudah string, return langsung
    if (phoneValue is String) return phoneValue;
    
    // Jika number, convert ke string
    if (phoneValue is num) return phoneValue.toString();
    
    return phoneValue.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Admin': idAdmin,
      'nama': nama,
      'email': email,
      // PERBAIKAN: Kirim sebagai string untuk konsistensi
      'no_Handphone': noHandphone,
      'foto_Profil': fotoProfil,
    };
  }

  Admin copyWith({
    int? idAdmin,
    String? nama,
    String? email,
    String? noHandphone,
    String? fotoProfil,
  }) {
    return Admin(
      idAdmin: idAdmin ?? this.idAdmin,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHandphone: noHandphone ?? this.noHandphone,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }

  @override
  String toString() {
    return 'Admin{idAdmin: $idAdmin, nama: $nama, email: $email, noHandphone: $noHandphone, fotoProfil: $fotoProfil}';
  }
}

// Request model untuk update password
class UpdatePasswordRequest {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}