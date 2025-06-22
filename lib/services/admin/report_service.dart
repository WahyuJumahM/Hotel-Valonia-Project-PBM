import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/admin/report_model.dart';
import '../ipconfig.dart';

class ReportService {
  static Future<Report> fetchReport() async {
    final response = await http.get(Uri.parse('${IpConfig.baseUrl}api/Report/summary'));

    if (response.statusCode == 200) {
      return Report.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat data laporan');
    }
  }
}