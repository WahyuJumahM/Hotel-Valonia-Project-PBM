// lib/models/admin/jenis_kamar.dart
class JenisKamar {
  final int idJenisKamar;
  final String namaJenisKamar;
  final String deskripsi;
  final double harga;
  final int kapasitas;
  final String? fotoKamar;
  final int? idTipeKasur;

  JenisKamar({
    required this.idJenisKamar,
    required this.namaJenisKamar,
    required this.deskripsi,
    required this.harga,
    required this.kapasitas,
    this.fotoKamar,
    this.idTipeKasur,
  });

  factory JenisKamar.fromJson(Map<String, dynamic> json) {
    return JenisKamar(
      idJenisKamar: json['id_Jenis_Kamar'] ?? 0,
      namaJenisKamar: json['nama_Jenis_Kamar'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
      kapasitas: json['kapasitas'] ?? 0,
      fotoKamar: json['foto_Kamar'],
      idTipeKasur: json['id_Tipe_Kasur'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Jenis_Kamar': idJenisKamar,
      'nama_Jenis_Kamar': namaJenisKamar,
      'deskripsi': deskripsi,
      'harga': harga,
      'kapasitas': kapasitas,
      'foto_Kamar': fotoKamar,
      'id_Tipe_Kasur': idTipeKasur,
    };
  }
}

class CreateJenisKamarRequest {
  final String namaJenisKamar;
  final String deskripsi;
  final double harga;
  final int kapasitas;
  final String? fotoKamar;
  final int? idTipeKasur;

  CreateJenisKamarRequest({
    required this.namaJenisKamar,
    required this.deskripsi,
    required this.harga,
    required this.kapasitas,
    this.fotoKamar,
    this.idTipeKasur,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_Jenis_Kamar': namaJenisKamar,
      'deskripsi': deskripsi,
      'harga': harga,
      'kapasitas': kapasitas,
      'foto_Kamar': fotoKamar,
      'id_Tipe_Kasur': idTipeKasur,
    };
  }
}