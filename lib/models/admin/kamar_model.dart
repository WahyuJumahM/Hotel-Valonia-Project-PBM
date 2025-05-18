import 'jenis_kamar_model.dart';

class Kamar {
  final String idKamar;
  final int stok;
  final JenisKamar jenisKamar;

  Kamar({
    required this.idKamar,
    required this.stok,
    required this.jenisKamar,
  });
}
