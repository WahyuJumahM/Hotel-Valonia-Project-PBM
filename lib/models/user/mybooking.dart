// lib/models/booking.dart
class Booking {
  final int idBooking;
  final int idUser;
  final int idAdmin;
  final String catatan;
  final DateTime cekIn;
  final DateTime cekOut;
  final double? totalHarga;
  final int idKamar;
  final String namaKamar;
  final int lantai;
  final int jumlahDireservasi;
  final int idJenisKamar;
  final String namaJenisKamar;
  final String deskripsi;
  final double harga;
  final int kapasitas;
  final String fotoKamar;
  final int idTipeKasur;
  final String tipeKasur;
  final int idStatus;
  final String namaStatus;

  Booking({
    required this.idBooking,
    required this.idUser,
    required this.idAdmin,
    required this.catatan,
    required this.cekIn,
    required this.cekOut,
    this.totalHarga,
    required this.idKamar,
    required this.namaKamar,
    required this.lantai,
    required this.jumlahDireservasi,
    required this.idJenisKamar,
    required this.namaJenisKamar,
    required this.deskripsi,
    required this.harga,
    required this.kapasitas,
    required this.fotoKamar,
    required this.idTipeKasur,
    required this.tipeKasur,
    required this.idStatus,
    required this.namaStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      idBooking: json['id_Booking'] ?? 0,
      idUser: json['id_User'] ?? 0,
      idAdmin: json['id_Admin'] ?? 0,
      catatan: json['catatan'] ?? '',
      cekIn: DateTime.parse(json['cek_In'] ?? DateTime.now().toIso8601String()),
      cekOut: DateTime.parse(json['cek_Out'] ?? DateTime.now().toIso8601String()),
      totalHarga: json['total_Harga']?.toDouble(),
      idKamar: json['id_Kamar'] ?? 0,
      namaKamar: json['nama_Kamar'] ?? '',
      lantai: json['lantai'] ?? 0,
      jumlahDireservasi: json['jumlah_Direservasi'] ?? 0,
      idJenisKamar: json['id_Jenis_Kamar'] ?? 0,
      namaJenisKamar: json['nama_Jenis_Kamar'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
      kapasitas: json['kapasitas'] ?? 0,
      fotoKamar: json['foto_Kamar'] ?? '',
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
      'id_Kamar': idKamar,
      'nama_Kamar': namaKamar,
      'lantai': lantai,
      'jumlah_Direservasi': jumlahDireservasi,
      'id_Jenis_Kamar': idJenisKamar,
      'nama_Jenis_Kamar': namaJenisKamar,
      'deskripsi': deskripsi,
      'harga': harga,
      'kapasitas': kapasitas,
      'foto_Kamar': fotoKamar,
      'id_Tipe_Kasur': idTipeKasur,
      'tipe_Kasur': tipeKasur,
      'id_Status': idStatus,
      'nama_Status': namaStatus,
    };
  }
}

class BookingResponse {
  final List<Booking> data;
  final bool success;
  final String message;

  BookingResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Booking.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      success: json['success'] ?? true,
      message: json['message'] ?? '',
    );
  }
}