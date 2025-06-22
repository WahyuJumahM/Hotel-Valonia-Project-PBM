// lib/services/cloudinary_foto_view_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryFotoViewService {
  static const String cloudName = 'mycloud-wahyu';
  static const String uploadPreset = 'foto_view';
  static const String baseUrl = 'https://api.cloudinary.com/v1_1/$cloudName';

  // Method untuk upload gambar foto view dengan unsigned upload preset
  Future<String?> uploadFotoViewUnsigned(File imageFile) async {
    try {
      print('Starting foto view upload to Cloudinary...');
      
      if (uploadPreset.isEmpty) {
        throw Exception('Upload preset belum dikonfigurasi dengan benar');
      }

      final url = Uri.parse('$baseUrl/image/upload');
      final request = http.MultipartRequest('POST', url);

      // Field upload preset untuk unsigned upload
      request.fields['upload_preset'] = uploadPreset;

      // Simpan dalam folder 'valonia/FotoView'
      request.fields['folder'] = 'valonia/FotoView';

      // Tambahkan file gambar ke multipart request
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(multipartFile);

      print('Sending foto view request to Cloudinary...');

      // Kirim request ke Cloudinary
      final response = await request.send();

      // Baca response body sebagai string
      final responseBody = await response.stream.bytesToString();

      print('Cloudinary foto view response status: ${response.statusCode}');
      print('Cloudinary foto view response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        final secureUrl = jsonResponse['secure_url'] as String?;
        print('Foto view upload successful, URL: $secureUrl');
        return secureUrl;
      } else {
        print('Cloudinary foto view upload error: ${response.statusCode}');
        print('Response body: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error uploading foto view to Cloudinary: $e');
      return null;
    }
  }

  // Method untuk upload multiple foto view sekaligus
  Future<Map<String, String?>> uploadMultipleFotoView(List<File> imageFiles) async {
    Map<String, String?> results = {};
    
    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final url = await uploadFotoViewUnsigned(imageFiles[i]);
        results['foto_View${i + 1}'] = url;
      } catch (e) {
        print('Error uploading foto view ${i + 1}: $e');
        results['foto_View${i + 1}'] = null;
      }
    }
    
    return results;
  }

  // Method untuk mendapatkan URL transformasi (resize, crop, quality, dll)
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

  // Method untuk mendapatkan thumbnail dengan ukuran square
  String getThumbnailUrl(String originalUrl, {int size = 150}) {
    return getTransformedUrl(
      originalUrl,
      width: size,
      height: size,
      crop: 'fill',
      quality: 'auto',
    );
  }
}