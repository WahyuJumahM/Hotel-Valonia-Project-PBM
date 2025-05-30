import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';
import '../../../widgets/admin/app_bar.dart'; // Ganti dengan path sebenarnya

class AddRoomScreen extends StatefulWidget {
  final Kamar? kamar;
  final bool isEditMode;

  const AddRoomScreen({super.key, this.kamar, this.isEditMode = false});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customRoomTypeController = TextEditingController();

  String? selectedRoomType;
  bool isCustomRoomType = false;
  bool isSingleBed = false;
  bool isDoubleBed = false;

  final List<String> roomTypes = ['Superior', 'Deluxe', 'Suite'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.isEditMode ? 'Edit Kamar' : 'Tambah Kamar',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Jenis Kamar
            const Text("Jenis Kamar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              dropdownColor: Colors.white,
              hint: const Text("Pilih Jenis Kamar"),
              value: selectedRoomType,
              items: [
                ...roomTypes.map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    )),
                const DropdownMenuItem<String>(
                  value: "custom",
                  child: Text("+ Tambah Jenis Kamar"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  if (value == "custom") {
                    isCustomRoomType = true;
                    selectedRoomType = null;
                  } else {
                    isCustomRoomType = false;
                    selectedRoomType = value;
                  }
                });
              },
            ),

            if (isCustomRoomType) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customRoomTypeController,
                decoration: InputDecoration(
                  hintText: "Masukkan jenis kamar baru",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Tipe Kasur dan Kapasitas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tipe Kasur", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: FilterChip(
                              label: const Text('Single'),
                              selected: isSingleBed,
                              backgroundColor: Colors.white,
                              selectedColor: Colors.blue.shade100,
                              checkmarkColor: Colors.blue,
                              onSelected: (val) => setState(() {
                                isSingleBed = val;
                                if (val) isDoubleBed = false;
                              }),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilterChip(
                              label: const Text('Double'),
                              selected: isDoubleBed,
                              backgroundColor: Colors.white,
                              selectedColor: Colors.blue.shade100,
                              checkmarkColor: Colors.blue,
                              onSelected: (val) => setState(() {
                                isDoubleBed = val;
                                if (val) isSingleBed = false;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kapasitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Harga dan Stok
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(prefixText: 'Rp. ', suffixText: '/night'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Stok", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Deskripsi
            const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: _inputDecoration(hintText: "ketik disini..."),
            ),

            const SizedBox(height: 24),

            // Gambar
            const Text("Gambar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 50, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Implementasi simpan kamar bisa ditambahkan di sini
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? prefixText, String? suffixText, String? hintText}) {
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
