// lib/views/admin/kamar_screen/edit_jenis_kamar_screen.dart
// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../viewmodels/admin/jenis_kamar_viewmodel.dart';
import '../../../models/admin/jenis_kamar_model.dart';

class EditJenisKamarScreen extends StatefulWidget {
  final JenisKamar jenisKamar;

  const EditJenisKamarScreen({super.key, required this.jenisKamar});

  @override
  State<EditJenisKamarScreen> createState() => _EditJenisKamarScreenState();
}

class _EditJenisKamarScreenState extends State<EditJenisKamarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaJenisKamarController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kapasitasController = TextEditingController();

  int? _selectedTipeKasurId;
  File? _selectedImage;
  String? _currentImageUrl;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<JenisKamarViewModel>(context, listen: false);
      viewModel.fetchAllTipeKasur();
    });
  }

  void _initializeData() {
    _namaJenisKamarController.text = widget.jenisKamar.namaJenisKamar;
    _deskripsiController.text = widget.jenisKamar.deskripsi;
    _hargaController.text = widget.jenisKamar.harga.toString();
    _kapasitasController.text = widget.jenisKamar.kapasitas.toString();
    _selectedTipeKasurId = widget.jenisKamar.idTipeKasur;
    _currentImageUrl = widget.jenisKamar.fotoKamar;
    
    // Debug: Print initial values
    debugPrint('=== Initial Data ===');
    debugPrint('ID: ${widget.jenisKamar.idJenisKamar}');
    debugPrint('Nama: ${widget.jenisKamar.namaJenisKamar}');
    debugPrint('Deskripsi: ${widget.jenisKamar.deskripsi}');
    debugPrint('Harga: ${widget.jenisKamar.harga}');
    debugPrint('Kapasitas: ${widget.jenisKamar.kapasitas}');
    debugPrint('ID Tipe Kasur: ${widget.jenisKamar.idTipeKasur}');
    debugPrint('Foto: ${widget.jenisKamar.fotoKamar}');
  }

  @override
  void dispose() {
    _namaJenisKamarController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _kapasitasController.dispose();
    super.dispose();
  }

  // Method untuk menampilkan dialog pilihan kamera atau galeri
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Sumber Gambar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                      ),
                      title: const Text('Kamera'),
                      subtitle: const Text('Ambil foto menggunakan kamera'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                      title: const Text('Galeri'),
                      subtitle: const Text('Pilih foto dari galeri'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        debugPrint('Image selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _selectedImage = null;
      _currentImageUrl = null;
      _uploadedImageUrl = null;
    });
    debugPrint('Image removed');
  }

  Future<void> _updateJenisKamar() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return;
    }

    if (_isUpdating) {
      debugPrint('Already updating, skipping...');
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    final viewModel = Provider.of<JenisKamarViewModel>(context, listen: false);
    
    try {
      String? imageUrl = _currentImageUrl;

      // Upload image jika ada gambar baru yang dipilih
      if (_selectedImage != null) {
        debugPrint('Uploading new image...');
        imageUrl = await viewModel.uploadFotoKamar(_selectedImage!);
        if (imageUrl == null) {
          debugPrint('Image upload failed');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal mengupload foto kamar'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        debugPrint('Image uploaded successfully: $imageUrl');
      } else {
        debugPrint('Using existing image URL: $imageUrl');
      }

      // Parse values dengan validasi
      double harga;
      int kapasitas;
      
      try {
        harga = double.parse(_hargaController.text.trim());
        kapasitas = int.parse(_kapasitasController.text.trim());
      } catch (e) {
        debugPrint('Error parsing numbers: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Format harga atau kapasitas tidak valid'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final request = CreateJenisKamarRequest(
        namaJenisKamar: _namaJenisKamarController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        harga: harga,
        kapasitas: kapasitas,
        fotoKamar: imageUrl,
        idTipeKasur: _selectedTipeKasurId,
      );

      // Debug: Print request data
      debugPrint('=== Update Request ===');
      debugPrint('ID to update: ${widget.jenisKamar.idJenisKamar}');
      debugPrint('Request data: ${request.toJson()}');

      final success = await viewModel.updateJenisKamar(widget.jenisKamar.idJenisKamar, request);

      if (mounted) {
        if (success) {
          debugPrint('Update successful');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage.isNotEmpty 
                  ? viewModel.successMessage 
                  : 'Jenis kamar berhasil diupdate'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Delay navigation to ensure snackbar is shown
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context, true); // Return true to indicate success
          }
        } else {
          debugPrint('Update failed: ${viewModel.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage.isNotEmpty 
                  ? viewModel.errorMessage 
                  : 'Gagal mengupdate jenis kamar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Exception during update: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'Edit Jenis Kamar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Consumer<JenisKamarViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debug info (remove in production)
                  if (viewModel.errorMessage.isNotEmpty) 
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red[600], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage,
                              style: TextStyle(color: Colors.red[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Nama Jenis Kamar
                  const Text(
                    "Nama Jenis Kamar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _namaJenisKamarController,
                    decoration: _inputDecoration(hintText: "Masukkan nama jenis kamar"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama jenis kamar harus diisi';
                      }
                      if (value.trim().length < 3) {
                        return 'Nama jenis kamar minimal 3 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    decoration: _inputDecoration(hintText: "Masukkan deskripsi"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi harus diisi';
                      }
                      if (value.trim().length < 10) {
                        return 'Deskripsi minimal 10 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Harga dan Kapasitas
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Harga",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _hargaController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: _inputDecoration(
                                prefixText: 'Rp. ',
                                suffixText: '/malam',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Harga harus diisi';
                                }
                                final harga = double.tryParse(value.trim());
                                if (harga == null) {
                                  return 'Format harga tidak valid';
                                }
                                if (harga <= 0) {
                                  return 'Harga harus lebih dari 0';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kapasitas",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _kapasitasController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(suffixText: 'orang'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Kapasitas harus diisi';
                                }
                                final kapasitas = int.tryParse(value.trim());
                                if (kapasitas == null) {
                                  return 'Format kapasitas tidak valid';
                                }
                                if (kapasitas <= 0) {
                                  return 'Kapasitas harus lebih dari 0';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tipe Kasur
                  const Text(
                    "Tipe Kasur",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    dropdownColor: Colors.white,
                    hint: const Text("Pilih Tipe Kasur"),
                    value: _selectedTipeKasurId,
                    items: viewModel.tipeKasurList.map((tipeKasur) {
                      return DropdownMenuItem<int>(
                        value: tipeKasur.idTipeKasur,
                        child: Text(tipeKasur.tipeKasur),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTipeKasurId = value;
                      });
                      debugPrint('Selected tipe kasur ID: $value');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Gambar Kamar
                  const Text(
                    "Gambar Kamar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload foto kamar baru atau biarkan kosong untuk menggunakan foto lama',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Build photo upload widget
                  _buildPhotoUpload(),

                  if (viewModel.isUploadingImage)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<JenisKamarViewModel>(
        builder: (context, viewModel, child) {
          final isLoading = _isUpdating || viewModel.isLoading || viewModel.isUploadingImage;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isLoading ? null : _updateJenisKamar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Mengupdate...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                  : const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _selectedImage != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Foto Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _currentImageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Foto Lama',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                        size: 50,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap untuk pilih foto',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? prefixText,
    String? suffixText,
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      suffixText: suffixText,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}