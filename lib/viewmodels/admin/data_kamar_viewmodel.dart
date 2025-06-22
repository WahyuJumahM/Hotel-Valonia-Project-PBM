// lib/viewmodels/admin/kamar_viewmodel.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/admin/data_kamar_model.dart';
import '../../services/admin/data_kamar_service.dart';
import '../../services/admin/cloudinary_galeri_foto_service.dart';
import 'package:intl/intl.dart';

class DataKamarViewModel extends ChangeNotifier {
  final CloudinaryFotoViewService _cloudinaryService = CloudinaryFotoViewService();

  // State variables
  List<Kamar> _kamarList = [];
  List<JenisKamar> _jenisKamarList = [];
  Kamar? _selectedKamar;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isUploading = false;

  // Getters
  List<Kamar> get kamarList => _kamarList;
  List<JenisKamar> get jenisKamarList => _jenisKamarList;
  Kamar? get selectedKamar => _selectedKamar;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isUploading => _isUploading;

  // Load all kamar
  Future<void> loadAllKamar() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await DataKamarService.getAllKamar();
      
      if (result['success']) {
        _kamarList = result['data'] ?? [];
        _errorMessage = '';
      } else {
        _errorMessage = result['message'] ?? 'Gagal memuat data kamar';
        _kamarList = [];
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _kamarList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load kamar detail by ID
  Future<void> loadKamarDetail(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await DataKamarService.getKamarById(id);
      
      if (result['success']) {
        _selectedKamar = result['data'];
        _errorMessage = '';
      } else {
        _errorMessage = result['message'] ?? 'Gagal memuat detail kamar';
        _selectedKamar = null;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _selectedKamar = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load all jenis kamar untuk dropdown
  Future<void> loadAllJenisKamar() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await DataKamarService.getAllJenisKamar();
      
      if (result['success']) {
        _jenisKamarList = result['data'] ?? [];
        _errorMessage = '';
      } else {
        _errorMessage = result['message'] ?? 'Gagal memuat data jenis kamar';
        _jenisKamarList = [];
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _jenisKamarList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new kamar dengan upload foto
  Future<bool> createKamar({
    required String namaKamar,
    required int lantai,
    required int idJenisKamar,
    File? fotoView1,
    File? fotoView2,
    File? fotoView3,
  }) async {
    _isLoading = true;
    _isUploading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Upload foto ke Cloudinary
      String? urlFotoView1;
      String? urlFotoView2;
      String? urlFotoView3;

      if (fotoView1 != null) {
        urlFotoView1 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView1);
        if (urlFotoView1 == null) {
          _errorMessage = 'Gagal upload foto view 1';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      if (fotoView2 != null) {
        urlFotoView2 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView2);
        if (urlFotoView2 == null) {
          _errorMessage = 'Gagal upload foto view 2';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      if (fotoView3 != null) {
        urlFotoView3 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView3);
        if (urlFotoView3 == null) {
          _errorMessage = 'Gagal upload foto view 3';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      _isUploading = false;
      notifyListeners();

      // Create kamar request
      final request = KamarCreateRequest(
        namaKamar: namaKamar,
        lantai: lantai,
        idJenisKamar: idJenisKamar,
        fotoView1: urlFotoView1,
        fotoView2: urlFotoView2,
        fotoView3: urlFotoView3,
      );

      final result = await DataKamarService.createKamar(request);
      
      if (result['success']) {
        _errorMessage = '';
        // Reload data setelah berhasil create
        await loadAllKamar();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Gagal menambahkan kamar';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      _isUploading = false;
      notifyListeners();
    }
  }

  // Update kamar dengan upload foto
  Future<bool> updateKamar({
    required int id,
    required String namaKamar,
    required int lantai,
    required int idJenisKamar,
    File? fotoView1,
    File? fotoView2,
    File? fotoView3,
    String? existingFotoView1,
    String? existingFotoView2,
    String? existingFotoView3,
  }) async {
    _isLoading = true;
    _isUploading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Upload foto baru ke Cloudinary atau gunakan existing
      String? urlFotoView1 = existingFotoView1;
      String? urlFotoView2 = existingFotoView2;
      String? urlFotoView3 = existingFotoView3;

      if (fotoView1 != null) {
        urlFotoView1 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView1);
        if (urlFotoView1 == null) {
          _errorMessage = 'Gagal upload foto view 1';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      if (fotoView2 != null) {
        urlFotoView2 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView2);
        if (urlFotoView2 == null) {
          _errorMessage = 'Gagal upload foto view 2';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      if (fotoView3 != null) {
        urlFotoView3 = await _cloudinaryService.uploadFotoViewUnsigned(fotoView3);
        if (urlFotoView3 == null) {
          _errorMessage = 'Gagal upload foto view 3';
          _isLoading = false;
          _isUploading = false;
          notifyListeners();
          return false;
        }
      }

      _isUploading = false;
      notifyListeners();

      // Update kamar request
      final request = KamarCreateRequest(
        namaKamar: namaKamar,
        lantai: lantai,
        idJenisKamar: idJenisKamar,
        fotoView1: urlFotoView1,
        fotoView2: urlFotoView2,
        fotoView3: urlFotoView3,
      );

      final result = await DataKamarService.updateKamar(id, request);
      
      if (result['success']) {
        _errorMessage = '';
        // Reload data setelah berhasil update
        await loadAllKamar();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Gagal memperbarui kamar';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      _isUploading = false;
      notifyListeners();
    }
  }

  // Format harga untuk tampilan
  String formatHarga(double? harga) {
    if (harga == null) return 'Rp 0';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(harga);
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Reset selected kamar
  void clearSelectedKamar() {
    _selectedKamar = null;
    notifyListeners();
  }
}