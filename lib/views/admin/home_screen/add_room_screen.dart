import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart'; // Import model kamar yang sudah ada
// import 'package:valonia/models/tipe_kasur_model.dart';
// import 'package:valonia/widgets/home_screen/room_card.dart'; // Import RoomCard widget

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
  // void initState() {
  //   super.initState();

  //   if (widget.isEditMode && widget.kamar != null) {
  //     final jenisKamar = widget.kamar!.jenisKamar;
  //     final tipeKasur = widget.kamar!.tipeKasur;

  //     // Pre-fill the data if editing
  //     _capacityController.text = jenisKamar.kapasitas.toString();
  //     _priceController.text = jenisKamar.harga.toStringAsFixed(0);
  //     _stockController.text = widget.kamar!.stok.toString();
  //     _descriptionController.text = jenisKamar.deskripsi ?? '';
  //     selectedRoomType = jenisKamar.nama;

  //     if (tipeKasur != null) {
  //       if (tipeKasur.namaKasur.toLowerCase() == 'single') {
  //         isSingleBed = true;
  //         isDoubleBed = false;
  //       } else if (tipeKasur.namaKasur.toLowerCase() == 'double') {
  //         isSingleBed = false;
  //         isDoubleBed = true;
  //       }
  //     }
  //   }
  // }

  // Kamar createKamar() {
  //   // Create a Kamar instance from form data
  //   final jenisKamar = JenisKamar(
  //     idJenisKamar: selectedRoomType ?? _customRoomTypeController.text,
  //     nama: selectedRoomType ?? _customRoomTypeController.text,
  //     kapasitas: int.parse(_capacityController.text),
  //     harga: double.parse(_priceController.text),
  //     deskripsi: _descriptionController.text,
  //     fotoKamar: 'assets/images/room.jpg', // Example default image
  //   );

  //   final tipeKasur = TipeKasur(
  //     namaKasur: isSingleBed ? 'Single' : isDoubleBed ? 'Double' : 'Single',
  //   );

  //   return Kamar(
  //     jenisKamar: jenisKamar,
  //     tipeKasur: tipeKasur,
  //     stok: int.parse(_stockController.text),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditMode ? 'Edit Kamar' : 'Tambah Kamar',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Jenis Kamar", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text("Pilih Jenis Kamar"),
              value: selectedRoomType,
              items: [
                ...roomTypes.map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    )),
                const DropdownMenuItem<String>(value: "custom", child: Text("+ Tambah Jenis Kamar")),
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
              const SizedBox(height: 10),
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
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tipe Kasur", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: FilterChip(
                              label: const Text('Single'),
                              selected: isSingleBed,
                              onSelected: (val) => setState(() {
                                isSingleBed = val;
                                if (val) isDoubleBed = false;
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilterChip(
                              label: const Text('Double'),
                              selected: isDoubleBed,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kapasitas", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Harga", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(prefixText: 'Rp. ', suffixText: '/night'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Stok", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
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
            const SizedBox(height: 20),
            const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: _inputDecoration(hintText: "ketik disini..."),
            ),
            const SizedBox(height: 20),
            const Text("Gambar", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
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
            // final kamar = createKamar(); // Create the Kamar object
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: const Text("Room Saved"),
            //     content: RoomCard(room: kamar), // Display RoomCard with the created Kamar
            //     actions: [
            //       TextButton(
            //         onPressed: () => Navigator.pop(context),
            //         child: const Text('Close'),
            //       ),
            //     ],
            //   ),
            // );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
