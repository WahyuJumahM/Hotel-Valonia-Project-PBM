class User {
  final String idUser;
  final String namaLengkap;
  final String email;
  final String nik;
  final String noHandphone;
  final String? fotoProfil;

  User({
    required this.idUser,
    required this.namaLengkap,
    required this.email,
    required this.nik,
    required this.noHandphone,
    this.fotoProfil,
  });
}
