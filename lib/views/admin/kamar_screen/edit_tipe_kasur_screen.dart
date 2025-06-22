// lib/views/admin/kamar_screen/edit_tipe_kasur_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/tipe_kasur_viewmodel.dart';
import '../../../models/admin/tipe_kasur_model.dart';

class EditTipeKasurScreen extends StatefulWidget {
  final TipeKasur tipeKasur;

  const EditTipeKasurScreen({
    super.key,
    required this.tipeKasur,
  });

  @override
  State<EditTipeKasurScreen> createState() => _EditTipeKasurScreenState();
}

class _EditTipeKasurScreenState extends State<EditTipeKasurScreen> {
  final TextEditingController _namaTipeKasurController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TipeKasurViewModel _viewModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TipeKasurViewModel>(context, listen: false);
    _namaTipeKasurController.text = widget.tipeKasur.tipeKasur;
  }

  @override
  void dispose() {
    _namaTipeKasurController.dispose();
    super.dispose();
  }

  Future<void> _updateTipeKasur() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Cek apakah ada perubahan
    if (_namaTipeKasurController.text.trim() == widget.tipeKasur.tipeKasur) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada perubahan yang disimpan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _viewModel.updateTipeKasur(
        widget.tipeKasur.idTipeKasur,
        _namaTipeKasurController.text,
      );

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
    final RegExp allowedChars = RegExp(r'^[a-zA-Z0-9\s\-]+$');
    if (!allowedChars.hasMatch(value.trim())) {
      return 'Nama tipe kasur hanya boleh mengandung huruf, angka, spasi, dan tanda hubung';
    }
    
    return null;
  }

  void _showDiscardChangesDialog() {
    // Cek apakah ada perubahan
    if (_namaTipeKasurController.text.trim() == widget.tipeKasur.tipeKasur) {
      Navigator.of(context).pop();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin membatalkan perubahan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close screen
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          'Edit Tipe Kasur',
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
                        'Edit Informasi Tipe Kasur',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: ${widget.tipeKasur.idTipeKasur}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
                      onPressed: _isLoading ? null : _showDiscardChangesDialog,
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
                      onPressed: _isLoading ? null : _updateTipeKasur,
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
                          : const Text('Ubah'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Card(
                color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Perhatian:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Pastikan nama tipe kasur tidak sama dengan yang sudah ada\n'
                        '• Perubahan akan mempengaruhi semua kamar yang menggunakan tipe kasur ini\n'
                        '• Gunakan nama yang jelas dan mudah dipahami',
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