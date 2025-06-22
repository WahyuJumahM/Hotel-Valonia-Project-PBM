// lib/models/admin/booking_model.dart
class BookingAdminDetail {
  // Booking data
  final int idBooking;
  final int idUser;
  final int? idAdmin;
  final String? catatan;
  final DateTime cekIn;
  final DateTime cekOut;
  final double? totalHarga;

  // User data
  final String namaLengkap;
  final String email;
  final int nik;
  final int noHandphone;

  // Kamar data
  final int idKamar;
  final String namaKamar;
  final int lantai;
  final int? jumlahDireservasi;

  // Jenis Kamar data
  final int idJenisKamar;
  final String namaJenisKamar;
  final double harga;
  final int kapasitas;
  final String? fotoKamar;

  // Tipe Kasur data
  final int idTipeKasur;
  final String tipeKasur;

  // Status data
  final int idStatus;
  final String namaStatus;

  BookingAdminDetail({
    required this.idBooking,
    required this.idUser,
    this.idAdmin,
    this.catatan,
    required this.cekIn,
    required this.cekOut,
    this.totalHarga,
    required this.namaLengkap,
    required this.email,
    required this.nik,
    required this.noHandphone,
    required this.idKamar,
    required this.namaKamar,
    required this.lantai,
    this.jumlahDireservasi,
    required this.idJenisKamar,
    required this.namaJenisKamar,
    required this.harga,
    required this.kapasitas,
    this.fotoKamar,
    required this.idTipeKasur,
    required this.tipeKasur,
    required this.idStatus,
    required this.namaStatus,
  });

  factory BookingAdminDetail.fromJson(Map<String, dynamic> json) {
    return BookingAdminDetail(
      idBooking: json['id_Booking'] ?? 0,
      idUser: json['id_User'] ?? 0,
      idAdmin: json['id_Admin'],
      catatan: json['catatan'],
      cekIn: DateTime.parse(json['cek_In']),
      cekOut: DateTime.parse(json['cek_Out']),
      totalHarga: json['total_Harga']?.toDouble(),
      namaLengkap: json['nama_Lengkap'] ?? '',
      email: json['email'] ?? '',
      nik: json['nik'] ?? 0,
      noHandphone: json['no_Handphone'] ?? 0,
      idKamar: json['id_Kamar'] ?? 0,
      namaKamar: json['nama_Kamar'] ?? '',
      lantai: json['lantai'] ?? 0,
      jumlahDireservasi: json['jumlah_Direservasi'],
      idJenisKamar: json['id_Jenis_Kamar'] ?? 0,
      namaJenisKamar: json['nama_Jenis_Kamar'] ?? '',
      harga: json['harga']?.toDouble() ?? 0.0,
      kapasitas: json['kapasitas'] ?? 0,
      fotoKamar: json['foto_Kamar'],
      idTipeKasur: json['id_Tipe_Kasur'] ?? 0,
      tipeKasur: json['tipe_Kasur'] ?? '',
      idStatus: json['id_Status'] ?? 0,
      namaStatus: json['nama_Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Booking': idBooking,
      'id_User': idUser,
      'id_Admin': idAdmin,
      'catatan': catatan,
      'cek_In': cekIn.toIso8601String(),
      'cek_Out': cekOut.toIso8601String(),
      'total_Harga': totalHarga,
      'nama_Lengkap': namaLengkap,
      'email': email,
      'nik': nik,
      'no_Handphone': noHandphone,
      'id_Kamar': idKamar,
      'nama_Kamar': namaKamar,
      'lantai': lantai,
      'jumlah_Direservasi': jumlahDireservasi,
      'id_Jenis_Kamar': idJenisKamar,
      'nama_Jenis_Kamar': namaJenisKamar,
      'harga': harga,
      'kapasitas': kapasitas,
      'foto_Kamar': fotoKamar,
      'id_Tipe_Kasur': idTipeKasur,
      'tipe_Kasur': tipeKasur,
      'id_Status': idStatus,
      'nama_Status': namaStatus,
    };
  }

  BookingAdminDetail copyWith({
    int? idBooking,
    int? idUser,
    int? idAdmin,
    String? catatan,
    DateTime? cekIn,
    DateTime? cekOut,
    double? totalHarga,
    String? namaLengkap,
    String? email,
    int? nik,
    int? noHandphone,
    int? idKamar,
    String? namaKamar,
    int? lantai,
    int? jumlahDireservasi,
    int? idJenisKamar,
    String? namaJenisKamar,
    double? harga,
    int? kapasitas,
    String? fotoKamar,
    int? idTipeKasur,
    String? tipeKasur,
    int? idStatus,
    String? namaStatus,
  }) {
    return BookingAdminDetail(
      idBooking: idBooking ?? this.idBooking,
      idUser: idUser ?? this.idUser,
      idAdmin: idAdmin ?? this.idAdmin,
      catatan: catatan ?? this.catatan,
      cekIn: cekIn ?? this.cekIn,
      cekOut: cekOut ?? this.cekOut,
      totalHarga: totalHarga ?? this.totalHarga,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      noHandphone: noHandphone ?? this.noHandphone,
      idKamar: idKamar ?? this.idKamar,
      namaKamar: namaKamar ?? this.namaKamar,
      lantai: lantai ?? this.lantai,
      jumlahDireservasi: jumlahDireservasi ?? this.jumlahDireservasi,
      idJenisKamar: idJenisKamar ?? this.idJenisKamar,
      namaJenisKamar: namaJenisKamar ?? this.namaJenisKamar,
      harga: harga ?? this.harga,
      kapasitas: kapasitas ?? this.kapasitas,
      fotoKamar: fotoKamar ?? this.fotoKamar,
      idTipeKasur: idTipeKasur ?? this.idTipeKasur,
      tipeKasur: tipeKasur ?? this.tipeKasur,
      idStatus: idStatus ?? this.idStatus,
      namaStatus: namaStatus ?? this.namaStatus,
    );
  }
}