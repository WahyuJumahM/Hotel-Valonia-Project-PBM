import 'kamar_model.dart';
import 'user_model.dart';
import 'status_model.dart';

class Booking {
  final String idBooking;
  final String? catatan;
  final DateTime cekIn;
  final DateTime cekOut;
  final User user;
  final Kamar kamar;
  final Status status;

  Booking({
    required this.idBooking,
    this.catatan,
    required this.cekIn,
    required this.cekOut,
    required this.user,
    required this.kamar,
    required this.status,
  });
}
