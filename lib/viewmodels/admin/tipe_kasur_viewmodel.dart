// lib/viewmodels/tipe_kasur/tipe_kasur_viewmodel.dart
import 'package:flutter/material.dart';
import '../../models/admin/tipe_kasur_model.dart';
import '../../services/admin/tipe_kasur_service.dart';

class TipeKasurViewModel extends ChangeNotifier {
  List<TipeKasur> _tipeKasurList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TipeKasur> get tipeKasurList => _tipeKasurList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Ambil semua tipe kasur
  Future<bool> fetchAllTipeKasur() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await TipeKasurService.getAllTipeKasur();
      
      if (result['success']) {
        _tipeKasurList = result['data'] ?? [];
        _setLoading(false);
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Tambah tipe kasur baru
  Future<Map<String, dynamic>> addTipeKasur(String namaTipeKasur) async {
    if (namaTipeKasur.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Nama tipe kasur tidak boleh kosong'
      };
    }

    // Cek duplikasi
    bool isDuplicate = _tipeKasurList.any(
      (tipe) => tipe.tipeKasur.toLowerCase() == namaTipeKasur.trim().toLowerCase()
    );

    if (isDuplicate) {
      return {
        'success': false,
        'message': 'Tipe kasur dengan nama "$namaTipeKasur" sudah ada'
      };
    }

    _setLoading(true);
    _setError(null);

    try {
      final newTipeKasur = TipeKasur(
        idTipeKasur: 0, // ID akan di-generate oleh backend
        tipeKasur: namaTipeKasur.trim(),
      );

      final result = await TipeKasurService.createTipeKasur(newTipeKasur);
      
      if (result['success']) {
        // Refresh data setelah berhasil menambah
        await fetchAllTipeKasur();
        return {
          'success': true,
          'message': result['message']
        };
      } else {
        _setError(result['message']);
        _setLoading(false);
        return {
          'success': false,
          'message': result['message']
        };
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Update tipe kasur
  Future<Map<String, dynamic>> updateTipeKasur(int idTipeKasur, String namaTipeKasur) async {
    if (namaTipeKasur.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Nama tipe kasur tidak boleh kosong'
      };
    }

    // Cek duplikasi (kecuali untuk item yang sedang diedit)
    bool isDuplicate = _tipeKasurList.any(
      (tipe) => tipe.idTipeKasur != idTipeKasur && 
                tipe.tipeKasur.toLowerCase() == namaTipeKasur.trim().toLowerCase()
    );

    if (isDuplicate) {
      return {
        'success': false,
        'message': 'Tipe kasur dengan nama "$namaTipeKasur" sudah ada'
      };
    }

    _setLoading(true);
    _setError(null);

    try {
      final updatedTipeKasur = TipeKasur(
        idTipeKasur: idTipeKasur,
        tipeKasur: namaTipeKasur.trim(),
      );

      final result = await TipeKasurService.updateTipeKasur(updatedTipeKasur);
      
      if (result['success']) {
        // Refresh data setelah berhasil update
        await fetchAllTipeKasur();
        return {
          'success': true,
          'message': result['message']
        };
      } else {
        _setError(result['message']);
        _setLoading(false);
        return {
          'success': false,
          'message': result['message']
        };
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Hapus tipe kasur
  Future<Map<String, dynamic>> deleteTipeKasur(int idTipeKasur, String namaTipeKasur) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await TipeKasurService.deleteTipeKasur(idTipeKasur);
      
      if (result['success']) {
        // Refresh data setelah berhasil hapus
        await fetchAllTipeKasur();
        return {
          'success': true,
          'message': result['message']
        };
      } else {
        _setError(result['message']);
        _setLoading(false);
        return {
          'success': false,
          'message': result['message']
        };
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Cari tipe kasur berdasarkan ID
  TipeKasur? getTipeKasurById(int id) {
    try {
      return _tipeKasurList.firstWhere((tipe) => tipe.idTipeKasur == id);
    } catch (e) {
      return null;
    }
  }

  // Reset state
  void reset() {
    _tipeKasurList = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}