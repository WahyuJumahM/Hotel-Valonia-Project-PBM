// services/cloudinary_profile_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'mycloud-wahyu';

  static const String uploadPreset = 'profile_pictures';

  static const String baseUrl = 'https://api.cloudinary.com/v1_1/$cloudName';

  Future<String?> uploadImageUnsigned(File imageFile) async {
    try {
      print('Starting image upload to Cloudinary...');
      
      if (uploadPreset.isEmpty) {
        throw Exception('Upload preset belum dikonfigurasi dengan benar');
      }

      final url = Uri.parse('$baseUrl/image/upload');
      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = uploadPreset;

      request.fields['folder'] = 'user_profiles';

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(multipartFile);

      print('Sending request to Cloudinary...');

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      print('Cloudinary response status: ${response.statusCode}');
      print('Cloudinary response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        final secureUrl = jsonResponse['secure_url'] as String?;
        print('Upload successful, URL: $secureUrl');
        return secureUrl;
      } else {
        print('Cloudinary upload error: ${response.statusCode}');
        print('Response body: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
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

    // Insert transformation ke URL Cloudinary
    return originalUrl.replaceAll(
      '/image/upload/',
      '/image/upload/$transformString/',
    );
  }

  // Method untuk mendapatkan thumbnail dengan ukuran square (default 150x150)
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
