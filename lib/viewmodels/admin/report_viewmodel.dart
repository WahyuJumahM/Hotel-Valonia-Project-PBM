import 'package:flutter/material.dart';
import '../../models/admin/report_model.dart';
import '../../services/admin/report_service.dart';

class ReportViewModel extends ChangeNotifier {
  Report? _report;
  bool _isLoading = false;
  String? _errorMessage;

  Report? get report => _report;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      _report = await ReportService.fetchReport();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}