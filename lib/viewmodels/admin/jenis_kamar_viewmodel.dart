// lib/viewmodels/admin/jenis_kamar_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../models/admin/jenis_kamar_model.dart';
import '../../models/admin/tipe_kasur_model.dart';
import '../../services/admin/jenis_kamar_service.dart';
import '../../services/admin/jenis_kamar_cloudinary_service.dart';

class JenisKamarViewModel extends ChangeNotifier {
  final JenisKamarService _jenisKamarService = JenisKamarService();
  final KamarCloudinaryService _cloudinaryService = KamarCloudinaryService();

  // State variables
  List<JenisKamar> _jenisKamarList = [];
  List<TipeKasur> _tipeKasurList = [];
  JenisKamar? _selectedJenisKamar;
  
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String _errorMessage = '';
  String _successMessage = '';

  // Getters
  List<JenisKamar> get jenisKamarList => _jenisKamarList;
  List<TipeKasur> get tipeKasurList => _tipeKasurList;
  JenisKamar? get selectedJenisKamar => _selectedJenisKamar;
  
  bool get isLoading => _isLoading;
  bool get isUploadingImage => _isUploadingImage;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  // Clear messages
  void clearMessages() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setImageUploading(bool uploading) {
    _isUploadingImage = uploading;
    notifyListeners();
  }

  // Set error message
  void _setError(String message) {
    _errorMessage = message;
    _successMessage = '';
    notifyListeners();
  }

  // Set success message
  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = '';
    notifyListeners();
  }

  // Fetch all jenis kamar
  Future<void> fetchAllJenisKamar() async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _jenisKamarService.getAllJenisKamar();
      
      if (result['success']) {
        _jenisKamarList = result['data'] ?? [];
      } else {
        _setError(result['message'] ?? 'Gagal mengambil data jenis kamar');
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch jenis kamar by id
  Future<void> fetchJenisKamarById(int id) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _jenisKamarService.getJenisKamarById(id);
      
      if (result['success']) {
        _selectedJenisKamar = result['data'];
      } else {
        _setError(result['message'] ?? 'Gagal mengambil data jenis kamar');
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch all tipe kasur
  Future<void> fetchAllTipeKasur() async {
    try {
      final result = await _jenisKamarService.getAllTipeKasur();
      
      if (result['success']) {
        _tipeKasurList = result['data'] ?? [];
        notifyListeners();
      } else {
        _setError(result['message'] ?? 'Gagal mengambil data tipe kasur');
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Upload foto kamar
  Future<String?> uploadFotoKamar(File imageFile) async {
    _setImageUploading(true);
    clearMessages();

    try {
      final imageUrl = await _cloudinaryService.uploadFotoKamar(imageFile);
      
      if (imageUrl != null) {
        _setSuccess('Foto kamar berhasil diupload');
        return imageUrl;
      } else {
        _setError('Gagal mengupload foto kamar');
        return null;
      }
    } catch (e) {
      _setError('Terjadi kesalahan saat upload: ${e.toString()}');
      return null;
    } finally {
      _setImageUploading(false);
    }
  }

  // Create jenis kamar
  Future<bool> createJenisKamar(CreateJenisKamarRequest request) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _jenisKamarService.createJenisKamar(request);
      
      if (result['success']) {
        _setSuccess(result['message'] ?? 'Jenis kamar berhasil ditambahkan');
        // Refresh list after create
        await fetchAllJenisKamar();
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal menambahkan jenis kamar');
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update jenis kamar
  Future<bool> updateJenisKamar(int id, CreateJenisKamarRequest request) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _jenisKamarService.updateJenisKamar(id, request);
      
      if (result['success']) {
        _setSuccess(result['message'] ?? 'Jenis kamar berhasil diupdate');
        // Refresh list after update
        await fetchAllJenisKamar();
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal mengupdate jenis kamar');
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete jenis kamar
  Future<bool> deleteJenisKamar(int id) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _jenisKamarService.deleteJenisKamar(id);
      
      if (result['success']) {
        _setSuccess(result['message'] ?? 'Jenis kamar berhasil dihapus');
        // Refresh list after delete
        await fetchAllJenisKamar();
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal menghapus jenis kamar');
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get tipe kasur name by id
  String getTipeKasurName(int? id) {
    if (id == null) return 'Tidak ada';
    
    final tipeKasur = _tipeKasurList.firstWhere(
      (item) => item.idTipeKasur == id,
      orElse: () => TipeKasur(idTipeKasur: 0, tipeKasur: 'Tidak diketahui'),
    );
    
    return tipeKasur.tipeKasur;
  }

  // Get transformed image URL
  String getTransformedImageUrl(String? originalUrl, {int? width, int? height}) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return '';
    }
    
    return _cloudinaryService.getTransformedUrl(
      originalUrl,
      width: width,
      height: height,
      crop: 'fill',
      quality: 'auto',
    );
  }

  // Set selected jenis kamar
  void setSelectedJenisKamar(JenisKamar? jenisKamar) {
    _selectedJenisKamar = jenisKamar;
    notifyListeners();
  }

  // Clear selected jenis kamar
  void clearSelectedJenisKamar() {
    _selectedJenisKamar = null;
    notifyListeners();
  }
}