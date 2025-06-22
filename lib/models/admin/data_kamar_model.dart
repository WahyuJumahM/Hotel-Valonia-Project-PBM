// lib/models/admin/kamar_model.dart
class Kamar {
  final int idKamar;
  final String namaKamar;
  final int lantai;
  final int? jumlahDireservasi;
  final String? fotoView1;
  final String? fotoView2;
  final String? fotoView3;
  final int? idJenisKamar;
  final String? namaJenisKamar;
  final String? fotoKamar;
  final String? deskripsi;
  final double? harga;
  final int? kapasitas;
  final int? idTipeKasur;
  final String? tipeKasur;

  Kamar({
    required this.idKamar,
    required this.namaKamar,
    required this.lantai,
    this.jumlahDireservasi,
    this.fotoView1,
    this.fotoView2,
    this.fotoView3,
    this.idJenisKamar,
    this.namaJenisKamar,
    this.fotoKamar,
    this.deskripsi,
    this.harga,
    this.kapasitas,
    this.idTipeKasur,
    this.tipeKasur,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    return Kamar(
      idKamar: json['id_Kamar'] ?? 0,
      namaKamar: json['nama_Kamar'] ?? '',
      lantai: json['lantai'] ?? 0,
      jumlahDireservasi: json['jumlah_Direservasi'],
      fotoView1: json['foto_View1'],
      fotoView2: json['foto_View2'],
      fotoView3: json['foto_View3'],
      idJenisKamar: json['id_Jenis_Kamar'],
      namaJenisKamar: json['nama_Jenis_Kamar'],
      fotoKamar: json['foto_Kamar'],
      deskripsi: json['deskripsi'],
      harga: json['harga']?.toDouble(),
      kapasitas: json['kapasitas'],
      idTipeKasur: json['id_Tipe_Kasur'],
      tipeKasur: json['tipe_Kasur'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Kamar': idKamar,
      'nama_Kamar': namaKamar,
      'lantai': lantai,
      'jumlah_Direservasi': jumlahDireservasi,
      'foto_View1': fotoView1,
      'foto_View2': fotoView2,
      'foto_View3': fotoView3,
      'id_Jenis_Kamar': idJenisKamar,
      'nama_Jenis_Kamar': namaJenisKamar,
      'foto_Kamar': fotoKamar,
      'deskripsi': deskripsi,
      'harga': harga,
      'kapasitas': kapasitas,
      'id_Tipe_Kasur': idTipeKasur,
      'tipe_Kasur': tipeKasur,
    };
  }
}

class KamarCreateRequest {
  final String namaKamar;
  final int lantai;
  final String? fotoView1;
  final String? fotoView2;
  final String? fotoView3;
  final int idJenisKamar;

  KamarCreateRequest({
    required this.namaKamar,
    required this.lantai,
    this.fotoView1,
    this.fotoView2,
    this.fotoView3,
    required this.idJenisKamar,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_Kamar': namaKamar,
      'lantai': lantai,
      'foto_View1': fotoView1,
      'foto_View2': fotoView2,
      'foto_View3': fotoView3,
      'id_Jenis_Kamar': idJenisKamar,
    };
  }
}

class JenisKamar {
  final int idJenisKamar;
  final String namaJenisKamar;


  JenisKamar({
    required this.idJenisKamar,
    required this.namaJenisKamar,

  });

  factory JenisKamar.fromJson(Map<String, dynamic> json) {
    return JenisKamar(
      idJenisKamar: json['id_Jenis_Kamar'] ?? 0,
      namaJenisKamar: json['nama_Jenis_Kamar'] ?? '',
    );
  }
}