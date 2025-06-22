class UserModel {
  final int idUser;
  final String namaLengkap;
  final String email;
  final String password;
  final int nik;
  final int noHandphone;
  final String fotoProfil;

  UserModel({
    required this.idUser,
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.nik,
    required this.noHandphone,
    required this.fotoProfil,
  });

  // Factory constructor untuk membuat object dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_User'] ?? 0,
      namaLengkap: json['nama_Lengkap'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nik: json['nik'] ?? 0,
      noHandphone: json['no_Handphone'] ?? 0,
      fotoProfil: json['foto_Profil'] ?? '',
    );
  }

  // Method untuk convert object ke JSON
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
}

// Model untuk request register (tanpa id_User karena akan di-generate oleh backend)
class RegisterRequest {
  final String namaLengkap;
  final String email;
  final String password;
  final int nik;
  final int noHandphone;
  final String fotoProfil;

  RegisterRequest({
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.nik,
    required this.noHandphone,
    this.fotoProfil = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id_User': 0, // Default value sesuai API spec
      'nama_Lengkap': namaLengkap,
      'email': email,
      'password': password,
      'nik': nik,
      'no_Handphone': noHandphone,
      'foto_Profil': fotoProfil,
    };
  }
}