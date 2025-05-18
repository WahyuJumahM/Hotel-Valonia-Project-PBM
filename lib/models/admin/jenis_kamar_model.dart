import 'tipe_kasur_model.dart';

class JenisKamar {
  final String idJenisKamar;
  final String deskripsi;
  final double harga;
  final int kapasitas;
  final String? fotoKamar;
  final TipeKasur tipeKasur;

  JenisKamar({
    required this.idJenisKamar,
    required this.deskripsi,
    required this.harga,
    required this.kapasitas,
    this.fotoKamar,
    required this.tipeKasur,
  });

  String get formattedKasur => tipeKasur.tipeKasur.join(', ');
}
