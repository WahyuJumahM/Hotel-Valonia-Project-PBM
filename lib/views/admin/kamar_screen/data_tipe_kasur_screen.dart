// lib/views/admin/kamar_screen/data_tipe_kasur_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/tipe_kasur_viewmodel.dart';
import '../../../models/admin/tipe_kasur_model.dart';
import 'add_tipe_kasur_screen.dart';
import 'edit_tipe_kasur_screen.dart';

class DataTipeKasurScreen extends StatefulWidget {
  const DataTipeKasurScreen({super.key});

  @override
  State<DataTipeKasurScreen> createState() => _DataTipeKasurScreenState();
}

class _DataTipeKasurScreenState extends State<DataTipeKasurScreen> {
  late TipeKasurViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<TipeKasurViewModel>(context, listen: false);
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.fetchAllTipeKasur();
  }

  Future<void> _refreshData() async {
    await _viewModel.fetchAllTipeKasur();
  }

  void _showDeleteConfirmation(TipeKasur tipeKasur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apakah Anda yakin ingin menghapus tipe kasur "${tipeKasur.tipeKasur}"?',
              ),
              const SizedBox(height: 8),
              const Text(
                'Catatan: Pastikan tipe kasur ini belum digunakan dalam kamar manapun.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteTipeKasur(tipeKasur);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTipeKasur(TipeKasur tipeKasur) async {
    final result = await _viewModel.deleteTipeKasur(
      tipeKasur.idTipeKasur,
      tipeKasur.tipeKasur,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTipeKasurScreen()),
    );

    if (result == true) {
      _refreshData();
    }
  }

  void _navigateToEdit(TipeKasur tipeKasur) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTipeKasurScreen(tipeKasur: tipeKasur),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          'Data Tipe Kasur',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: Consumer<TipeKasurViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.tipeKasurList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bed_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada data tipe kasur',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _navigateToAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Tambah Tipe Kasur Pertama'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: Colors.blue[700],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: viewModel.tipeKasurList.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final tipeKasur = viewModel.tipeKasurList[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.bed, color: Colors.blue[700]),
                            ),
                            title: Text(
                              tipeKasur.tipeKasur,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${tipeKasur.idTipeKasur}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.blue[700],
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    _navigateToEdit(tipeKasur);
                                    break;
                                  case 'delete':
                                    _showDeleteConfirmation(tipeKasur);
                                    break;
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                            onTap: () => _navigateToEdit(tipeKasur),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
