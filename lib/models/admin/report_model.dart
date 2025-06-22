class Report {
  final int totalBooking;
  final int bookingSukses;
  final int bookingCancel;
  final int totalKamar;
  final int totalJenisKamar;
  final String kamarTerbanyakDipesan;
  final int totalPendapatan;

  Report({
    required this.totalBooking,
    required this.bookingSukses,
    required this.bookingCancel,
    required this.totalKamar,
    required this.totalJenisKamar,
    required this.kamarTerbanyakDipesan,
    required this.totalPendapatan,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
  return Report(
    totalBooking: (json['totalBooking'] ?? 0).toInt(),
    bookingSukses: (json['totalBookingSukses'] ?? 0).toInt(),
    bookingCancel: (json['totalBookingCancel'] ?? 0).toInt(),
    totalKamar: (json['totalKamar'] ?? 0).toInt(),
    totalJenisKamar: (json['totalJenisKamar'] ?? 0).toInt(),
    kamarTerbanyakDipesan: json['kamarPalingBanyakDireservasi'] ?? '-',
    totalPendapatan: (json['totalPendapatan'] ?? 0).toInt(),
    );
  }
}