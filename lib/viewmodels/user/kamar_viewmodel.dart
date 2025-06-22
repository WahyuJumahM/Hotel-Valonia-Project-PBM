// lib/viewmodels/kamar_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../models/user/kamar_model.dart';
import '../../services/user/kamar_service.dart';

class KamarViewModel extends ChangeNotifier {
  final KamarService _kamarService = KamarService();
  
  List<KamarModel> _allKamar = [];
  List<KamarModel> _filteredKamar = []; // Tambahan untuk search
  List<KamarModel> _recommendedKamar = [];
  KamarModel? _selectedKamar;
  bool _isLoading = false;
  String _errorMessage = '';
  int? _selectedKamarId;
  String _searchQuery = ''; // Tambahan untuk search query
  
  // Getters
  List<KamarModel> get allKamar => _searchQuery.isEmpty ? _allKamar : _filteredKamar;
  List<KamarModel> get recommendedKamar => _recommendedKamar;
  KamarModel? get selectedKamar => _selectedKamar;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int? get selectedKamarId => _selectedKamarId;
  String get searchQuery => _searchQuery; // Getter untuk search query
  
  // Load semua kamar untuk list room
  Future<void> loadAllKamar() async {
    _setLoading(true);
    try {
      _allKamar = await _kamarService.getAllKamar();
      _errorMessage = '';
      
      // Re-apply filter if there's an active search
      if (_searchQuery.isNotEmpty) {
        _filterKamar();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _allKamar = [];
      _filteredKamar = [];
    } finally {
      _setLoading(false);
    }
  }
  
  // Load kamar rekomendasi
  Future<void> loadRecommendedKamar() async {
    _setLoading(true);
    try {
      _recommendedKamar = await _kamarService.getKamarByReservation();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _recommendedKamar = [];
    } finally {
      _setLoading(false);
    }
  }
  
  // Load detail kamar berdasarkan ID
  Future<void> loadKamarDetail(int id) async {
    _setLoading(true);
    try {
      _selectedKamar = await _kamarService.getKamarById(id);
      _selectedKamarId = id;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _selectedKamar = null;
    } finally {
      _setLoading(false);
    }
  }
  
  // Search kamar by name - TAMBAHAN BARU
  void searchKamar(String query) {
    _searchQuery = query.toLowerCase().trim();
    
    if (_searchQuery.isEmpty) {
      _filteredKamar = [];
    } else {
      _filterKamar();
    }
    
    notifyListeners();
  }
  
  // Filter kamar based on search query - TAMBAHAN BARU
  void _filterKamar() {
    _filteredKamar = _allKamar.where((kamar) {
      final namaKamar = kamar.namaKamar.toLowerCase();
      final jenisKamar = kamar.namaJenisKamar.toLowerCase();
      
      // Search di nama kamar dan jenis kamar
      return namaKamar.contains(_searchQuery) || 
             jenisKamar.contains(_searchQuery);
    }).toList();
  }
  
  // Clear search - TAMBAHAN BARU
  void clearSearch() {
    _searchQuery = '';
    _filteredKamar = [];
    notifyListeners();
  }
  
  // Set kamar yang dipilih untuk booking
  void setSelectedKamar(KamarModel kamar) {
    _selectedKamar = kamar;
    _selectedKamarId = kamar.idKamar;
    notifyListeners();
  }
  
  // Format harga - DIPERBAIKI untuk handle double dan int
  String formatHarga(dynamic harga) {
    double hargaDouble;
    
    if (harga is int) {
      hargaDouble = harga.toDouble();
    } else if (harga is double) {
      hargaDouble = harga;
    } else {
      hargaDouble = 0.0;
    }
    
    return 'Rp ${hargaDouble.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
  
  // Reset all data - TAMBAHAN BARU (opsional, untuk cleanup)
  void reset() {
    _allKamar = [];
    _filteredKamar = [];
    _recommendedKamar = [];
    _selectedKamar = null;
    _selectedKamarId = null;
    _searchQuery = '';
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}