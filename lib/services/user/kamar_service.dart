// lib/services/kamar_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user/kamar_model.dart';
import '../ipconfig.dart';

class KamarService {
  static const String baseUrl = '${IpConfig.baseUrl}api';

  // Fetch semua kamar untuk list room
  Future<List<KamarModel>> getAllKamar() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Kamar'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => KamarModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load kamar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching kamar: $e');
    }
  }

  // Fetch kamar berdasarkan reservasi untuk rekomendasi
  Future<List<KamarModel>> getKamarByReservation() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Kamar/by-reservation'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => KamarModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended kamar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recommended kamar: $e');
    }
  }

  // Fetch detail kamar berdasarkan ID
  Future<KamarModel> getKamarById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Kamar/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return KamarModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load kamar detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching kamar detail: $e');
    }
  }
}