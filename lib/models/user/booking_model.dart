// lib/models/booking_model.dart - FIXED VERSION
class BookingModel {
  final int? idBooking;
  final int? idUser;
  final int? idAdmin;
  final String? catatan;
  final DateTime cekIn;
  final DateTime cekOut;
  final double? totalHarga;
  final int idKamar;
  final String? namaKamar;
  final int? lantai;
  final int? jumlahDireservasi;
  final int? idJenisKamar;
  final String? namaJenisKamar;
  final String? deskripsi;
  final double? harga;
  final int? kapasitas;
  final String? fotoKamar;
  final int? idTipeKasur;
  final String? tipeKasur;
  final int? idStatus;
  final String? namaStatus;

  BookingModel({
    this.idBooking,
    this.idUser,
    this.idAdmin,
    this.catatan,
    required this.cekIn,
    required this.cekOut,
    this.totalHarga,
    required this.idKamar,
    this.namaKamar,
    this.lantai,
    this.jumlahDireservasi,
    this.idJenisKamar,
    this.namaJenisKamar,
    this.deskripsi,
    this.harga,
    this.kapasitas,
    this.fotoKamar,
    this.idTipeKasur,
    this.tipeKasur,
    this.idStatus,
    this.namaStatus,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Helper function untuk parsing DateTime dengan error handling
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing DateTime: $value - $e');
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    // Helper function untuk parsing double dengan error handling
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          print('Error parsing double: $value - $e');
          return null;
        }
      }
      return null;
    }

    // Helper function untuk parsing int dengan error handling
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('Error parsing int: $value - $e');
          return null;
        }
      }
      return null;
    }

    // Helper function untuk parsing string dengan null safety
    String? parseString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    try {
      return BookingModel(
        idBooking: parseInt(json['id_Booking']),
        idUser: parseInt(json['id_User']),
        idAdmin: parseInt(json['id_Admin']),
        catatan: parseString(json['catatan']),
        cekIn: parseDateTime(json['cek_In']),
        cekOut: parseDateTime(json['cek_Out']),
        totalHarga: parseDouble(json['total_Harga']),
        idKamar: parseInt(json['id_Kamar']) ?? 0, // Default to 0 if null
        namaKamar: parseString(json['nama_Kamar']),
        lantai: parseInt(json['lantai']),
        jumlahDireservasi: parseInt(json['jumlah_Direservasi']),
        idJenisKamar: parseInt(json['id_Jenis_Kamar']),
        namaJenisKamar: parseString(json['nama_Jenis_Kamar']),
        deskripsi: parseString(json['deskripsi']),
        harga: parseDouble(json['harga']),
        kapasitas: parseInt(json['kapasitas']),
        fotoKamar: parseString(json['foto_Kamar']),
        idTipeKasur: parseInt(json['id_Tipe_Kasur']),
        tipeKasur: parseString(json['tipe_Kasur']),
        idStatus: parseInt(json['id_Status']),
        namaStatus: parseString(json['nama_Status']),
      );
    } catch (e) {
      print('Error creating BookingModel from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'cek_In': cekIn.toIso8601String(),
      'cek_Out': cekOut.toIso8601String(),
      'id_Kamar': idKamar,
    };
  }
}

// Model untuk request booking (yang akan dikirim ke API)
class BookingRequest {
  final DateTime cekIn;
  final DateTime cekOut;
  final int idKamar;

  BookingRequest({
    required this.cekIn,
    required this.cekOut,
    required this.idKamar,
  });

  Map<String, dynamic> toJson() {
    return {
      'cek_In': cekIn.toIso8601String(),
      'cek_Out': cekOut.toIso8601String(),
      'id_Kamar': idKamar,
    };
  }
}

// Model untuk response availability
class RoomAvailabilityModel {
  final bool isAvailable;
  final String message;

  RoomAvailabilityModel({
    required this.isAvailable,
    required this.message,
  });

  factory RoomAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return RoomAvailabilityModel(
      isAvailable: json['isAvailable'] ?? false,
      message: json['message']?.toString() ?? '', // Convert to string safely
    );
  }
}