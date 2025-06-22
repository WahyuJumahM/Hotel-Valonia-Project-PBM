// lib/models/kamar_model.dart
class KamarModel {
  final int idKamar;
  final String namaKamar;
  final int lantai;
  final int? jumlahDireservasi;
  final String? fotoView1;  // Changed to nullable
  final String? fotoView2;  // Changed to nullable
  final String? fotoView3;  // Changed to nullable
  final int idJenisKamar;
  final String namaJenisKamar;
  final String? fotoKamar;  // Changed to nullable
  final String deskripsi;
  final double harga;
  final int kapasitas;
  final int idTipeKasur;
  final String tipeKasur;

  KamarModel({
    required this.idKamar,
    required this.namaKamar,
    required this.lantai,
    this.jumlahDireservasi,
    this.fotoView1,  // Now optional
    this.fotoView2,  // Now optional
    this.fotoView3,  // Now optional
    required this.idJenisKamar,
    required this.namaJenisKamar,
    this.fotoKamar,  // Now optional
    required this.deskripsi,
    required this.harga,
    required this.kapasitas,
    required this.idTipeKasur,
    required this.tipeKasur,
  });

  factory KamarModel.fromJson(Map<String, dynamic> json) {
    return KamarModel(
      idKamar: json['id_Kamar'],
      namaKamar: json['nama_Kamar'],
      lantai: json['lantai'],
      jumlahDireservasi: json['jumlah_Direservasi'],
      fotoView1: json['foto_View1'],  // Can be null
      fotoView2: json['foto_View2'],  // Can be null
      fotoView3: json['foto_View3'],  // Can be null
      idJenisKamar: json['id_Jenis_Kamar'],
      namaJenisKamar: json['nama_Jenis_Kamar'],
      fotoKamar: json['foto_Kamar'],  // Can be null
      deskripsi: json['deskripsi'],
      harga: json['harga'].toDouble(),
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

  // Helper methods for safe photo access
  String get safeMainPhoto => fotoKamar ?? '';
  List<String> get safePhotoList {
    return [fotoView1, fotoView2, fotoView3]
        .where((photo) => photo != null && photo.isNotEmpty)
        .cast<String>()
        .toList();
  }
  
  bool get hasMainPhoto => fotoKamar != null && fotoKamar!.isNotEmpty;
  bool get hasAnyPhoto => hasMainPhoto || safePhotoList.isNotEmpty;
}