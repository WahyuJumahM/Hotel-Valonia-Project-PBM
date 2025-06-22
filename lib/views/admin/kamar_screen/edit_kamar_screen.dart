// lib/views/admin/kamar_screen/edit_kamar_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../viewmodels/admin/data_kamar_viewmodel.dart';
import '../../../models/admin/data_kamar_model.dart';

class EditKamarScreen extends StatefulWidget {
  final Kamar kamar;

  const EditKamarScreen({super.key, required this.kamar});

  @override
  State<EditKamarScreen> createState() => _EditKamarScreenState();
}

class _EditKamarScreenState extends State<EditKamarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaKamarController = TextEditingController();
  final _lantaiController = TextEditingController();
  
  JenisKamar? _selectedJenisKamar;
  File? _fotoView1;
  File? _fotoView2;
  File? _fotoView3;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load jenis kamar untuk dropdown dan set initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataKamarViewModel>().loadAllJenisKamar().then((_) {
        _initializeForm();
      });
    });
  }

  void _initializeForm() {
    final viewModel = context.read<DataKamarViewModel>();
    
    _namaKamarController.text = widget.kamar.namaKamar;
    _lantaiController.text = widget.kamar.lantai.toString();
    
    // Set selected jenis kamar
    if (widget.kamar.idJenisKamar != null) {
      try {
        _selectedJenisKamar = viewModel.jenisKamarList.firstWhere(
          (jenis) => jenis.idJenisKamar == widget.kamar.idJenisKamar,
        );
      } catch (e) {
        _selectedJenisKamar = null;
      }
    }
    
    setState(() {});
  }

  @override
  void dispose() {
    _namaKamarController.dispose();
    _lantaiController.dispose();
    super.dispose();
  }

  // Method untuk menampilkan dialog pilihan kamera atau galeri
  Future<void> _showImageSourceDialog(int viewNumber) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFFFF), // White background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: const Color(0xFFFFFFFF), // White background
            child: Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFFFFFFF), // White background
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
                      Container(
                        color: const Color(0xFFFFFFFF), // White background
                        child: ListTile(
                          leading: const Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                          ),
                          title: const Text('Kamera'),
                          subtitle: const Text('Ambil foto menggunakan kamera'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(viewNumber, ImageSource.camera);
                          },
                        ),
                      ),
                      Container(
                        color: const Color(0xFFFFFFFF), // White background
                        child: ListTile(
                          leading: const Icon(
                            Icons.photo_library,
                            color: Colors.green,
                          ),
                          title: const Text('Galeri'),
                          subtitle: const Text('Pilih foto dari galeri'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(viewNumber, ImageSource.gallery);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(int viewNumber, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          switch (viewNumber) {
            case 1:
              _fotoView1 = File(image.path);
              break;
            case 2:
              _fotoView2 = File(image.path);
              break;
            case 3:
              _fotoView3 = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedJenisKamar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis kamar terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<DataKamarViewModel>();
    
    final success = await viewModel.updateKamar(
      id: widget.kamar.idKamar,
      namaKamar: _namaKamarController.text.trim(),
      lantai: int.parse(_lantaiController.text.trim()),
      idJenisKamar: _selectedJenisKamar!.idJenisKamar,
      fotoView1: _fotoView1,
      fotoView2: _fotoView2,
      fotoView3: _fotoView3,
      existingFotoView1: widget.kamar.fotoView1,
      existingFotoView2: widget.kamar.fotoView2,
      existingFotoView3: widget.kamar.fotoView3,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamar berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage.isNotEmpty
                ? viewModel.errorMessage
                : 'Gagal memperbarui kamar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // White background
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'Edit Kamar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DataKamarViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            color: const Color(0xFFFFFFFF), // White background
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Informasi Kamar
                    Card(
                      elevation: 2,
                      color: const Color(0xFFFFFFFF), // White background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        color: const Color(0xFFFFFFFF), // White background
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Informasi Kamar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                color: const Color(0xFFFFFFFF), // White background
                                child: TextFormField(
                                  controller: _namaKamarController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama Kamar',
                                    hintText: 'Contoh: Kamar 101',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.hotel),
                                    fillColor: Color(0xFFFFFFFF), // White background
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Nama kamar tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                color: const Color(0xFFFFFFFF), // White background
                                child: TextFormField(
                                  controller: _lantaiController,
                                  decoration: const InputDecoration(
                                    labelText: 'Lantai',
                                    hintText: 'Contoh: 1',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.layers),
                                    fillColor: Color(0xFFFFFFFF), // White background
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Lantai tidak boleh kosong';
                                    }
                                    final lantai = int.tryParse(value.trim());
                                    if (lantai == null || lantai < 1) {
                                      return 'Lantai harus berupa angka positif';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Dropdown Jenis Kamar
                              Container(
                                color: const Color(0xFFFFFFFF), // White background
                                child: DropdownButtonFormField<JenisKamar>(
                                  decoration: const InputDecoration(
                                    labelText: 'Jenis Kamar',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.category),
                                    fillColor: Color(0xFFFFFFFF), // White background
                                    filled: true,
                                  ),
                                  value: _selectedJenisKamar,
                                  items: viewModel.jenisKamarList.map((jenisKamar) {
                                    return DropdownMenuItem<JenisKamar>(
                                      value: jenisKamar,
                                      child: Text(jenisKamar.namaJenisKamar),
                                    );
                                  }).toList(),
                                  onChanged: (JenisKamar? value) {
                                    setState(() {
                                      _selectedJenisKamar = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Pilih jenis kamar';
                                    }
                                    return null;
                                  },
                                  dropdownColor: const Color(0xFFFFFFFF), // White dropdown background
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Upload Foto
                    Card(
                      elevation: 2,
                      color: const Color(0xFFFFFFFF), // White background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        color: const Color(0xFFFFFFFF), // White background
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Foto View Kamar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Upload foto view kamar baru atau biarkan kosong untuk menggunakan foto lama',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Foto View 1
                              _buildPhotoUpload(
                                title: 'Foto View 1',
                                file: _fotoView1,
                                existingUrl: widget.kamar.fotoView1,
                                onTap: () => _showImageSourceDialog(1),
                                onRemove: () => setState(() => _fotoView1 = null),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Foto View 2
                              _buildPhotoUpload(
                                title: 'Foto View 2',
                                file: _fotoView2,
                                existingUrl: widget.kamar.fotoView2,
                                onTap: () => _showImageSourceDialog(2),
                                onRemove: () => setState(() => _fotoView2 = null),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Foto View 3
                              _buildPhotoUpload(
                                title: 'Foto View 3',
                                file: _fotoView3,
                                existingUrl: widget.kamar.fotoView3,
                                onTap: () => _showImageSourceDialog(3),
                                onRemove: () => setState(() => _fotoView3 = null),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    Container(
                      color: const Color(0xFFFFFFFF), // White background
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (viewModel.isLoading || viewModel.isUploading)
                              ? null
                              : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: (viewModel.isLoading || viewModel.isUploading)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(viewModel.isUploading 
                                        ? 'Mengupload foto...' 
                                        : 'Menyimpan...'),
                                  ],
                                )
                              : const Text(
                                  'Perbarui Kamar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoUpload({
    required String title,
    required File? file,
    required String? existingUrl,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Container(
      color: const Color(0xFFFFFFFF), // White background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // White background
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: file != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: onRemove,
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
                  : existingUrl != null && existingUrl.isNotEmpty
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                existingUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFFFFFFF), // White background
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: const Color(0xFFFFFFFF), // White background
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
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
                      : Container(
                          color: const Color(0xFFFFFFFF), // White background
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.grey,
                                size: 40,
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
            ),
          ),
        ],
      ),
    );
  }
}