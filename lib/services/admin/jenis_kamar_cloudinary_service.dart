// lib/services/admin/jenis_kamar_cloudinary_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KamarCloudinaryService {
  static const String cloudName = 'mycloud-wahyu';
  static const String uploadPreset = 'foto_kamar';
  static const String baseUrl = 'https://api.cloudinary.com/v1_1/$cloudName';

  Future<String?> uploadFotoKamar(File imageFile) async {
    try {
      print('Starting foto kamar upload to Cloudinary...');
      
      if (uploadPreset.isEmpty) {
        throw Exception('Upload preset foto_kamar belum dikonfigurasi');
      }

      final url = Uri.parse('$baseUrl/image/upload');
      final request = http.MultipartRequest('POST', url);

      // Field upload preset untuk unsigned upload
      request.fields['upload_preset'] = uploadPreset;
      
      // Simpan dalam folder valonia/FotoKamar sesuai permintaan
      request.fields['folder'] = 'valonia/FotoKamar';

      // Tambahkan file gambar
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(multipartFile);

      print('Sending foto kamar request to Cloudinary...');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Cloudinary response status: ${response.statusCode}');
      print('Cloudinary response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        final secureUrl = jsonResponse['secure_url'] as String?;
        print('Foto kamar upload successful, URL: $secureUrl');
        return secureUrl;
      } else {
        print('Cloudinary foto kamar upload error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading foto kamar to Cloudinary: $e');
      return null;
    }
  }

  String getTransformedUrl(
    String originalUrl, {
    int? width,
    int? height,
    String? crop,
    String? quality,
  }) {
    if (originalUrl.isEmpty) return originalUrl;

    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (crop != null) transformations.add('c_$crop');
    if (quality != null) transformations.add('q_$quality');

    if (transformations.isEmpty) return originalUrl;

    final transformString = transformations.join(',');

    return originalUrl.replaceAll(
      '/image/upload/',
      '/image/upload/$transformString/',
    );
  }

  String getFotoKamarThumbnail(String originalUrl, {int size = 300}) {
    return getTransformedUrl(
      originalUrl,
      width: size,
      height: size,
      crop: 'fill',
      quality: 'auto',
    );
  }
}