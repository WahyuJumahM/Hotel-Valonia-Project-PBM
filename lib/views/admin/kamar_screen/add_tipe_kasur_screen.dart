// lib/views/admin/kamar_screen/add_tipe_kasur_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/tipe_kasur_viewmodel.dart';

class AddTipeKasurScreen extends StatefulWidget {
  const AddTipeKasurScreen({super.key});

  @override
  State<AddTipeKasurScreen> createState() => _AddTipeKasurScreenState();
}

class _AddTipeKasurScreenState extends State<AddTipeKasurScreen> {
  final TextEditingController _namaTipeKasurController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TipeKasurViewModel _viewModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TipeKasurViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _namaTipeKasurController.dispose();
    super.dispose();
  }

  Future<void> _saveTipeKasur() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _viewModel.addTipeKasur(_namaTipeKasurController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
          ),
        );

        if (result['success']) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateNamaTipeKasur(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tipe kasur tidak boleh kosong';
    }
    
    if (value.trim().length < 2) {
      return 'Nama tipe kasur minimal 2 karakter';
    }
    
    if (value.trim().length > 50) {
      return 'Nama tipe kasur maksimal 50 karakter';
    }
    
    // Validasi karakter yang diizinkan (huruf, angka, spasi, tanda hubung)
    final RegExp allowedChars = RegExp(r'^[a-zA-Z0-9\s\-]+$', caseSensitive: false);
    if (!allowedChars.hasMatch(value.trim())) {
      return 'Nama tipe kasur hanya boleh mengandung huruf, angka, spasi, dan tanda hubung';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          'Tambah Tipe Kasur',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Tipe Kasur',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _namaTipeKasurController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Tipe Kasur *',
                          hintText: 'Contoh: Single, Double, Queen, King',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.bed),
                        ),
                        validator: _validateNamaTipeKasur,
                        enabled: !_isLoading,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '* Field wajib diisi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(               
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveTipeKasur,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Simpan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Card(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Tips:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Gunakan nama yang jelas dan mudah dipahami\n'
                        '• Contoh nama tipe kasur yang baik: Single, Double, Queen, King\n'
                        '• Pastikan nama belum ada sebelumnya',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}