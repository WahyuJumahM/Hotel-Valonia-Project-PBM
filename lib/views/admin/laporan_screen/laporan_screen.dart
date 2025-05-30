import 'package:flutter/material.dart';
import '../../../widgets/admin/bottom_navbar.dart';
import '../../../widgets/admin/app_bar.dart'; // pastikan path sesuai

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final int _currentIndex = 2;
  final List<String> years = ['2024', '2025', '2026', '2027', '2028', '2029'];
  String selectedYear = '2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // background putih murni
      bottomNavigationBar: BottomNavbar(currentIndex: _currentIndex),

      appBar: CustomAppBar(
        title: 'Laporan',
        showBackButton: true,
        onBack: () {
          Navigator.pushReplacementNamed(context, '/homepage_admin');
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final selected = year == selectedYear;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(
                      year,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selected,
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    side: BorderSide(
                      color: selected ? Colors.blue : Colors.grey.shade400,
                      width: selected ? 2 : 1,
                    ),
                    onSelected: (bool value) {
                      setState(() {
                        if (value) selectedYear = year;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: 2440 / 2870,
                          strokeWidth: 10,
                          backgroundColor: Colors.red,
                          color: Colors.blue,
                        ),
                      ),
                      const Column(
                        children: [
                          Text(
                            '2.870',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pengunjung setiap tahun',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(radius: 5, backgroundColor: Colors.blue),
                      SizedBox(width: 5),
                      Text('Sukses ', style: TextStyle(color: Colors.black)),
                      Text(
                        '2.440',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(radius: 5, backgroundColor: Colors.red),
                      SizedBox(width: 5),
                      Text('Cancel ', style: TextStyle(color: Colors.black)),
                      Text(
                        '430',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Kalkulasi Setiap Kmar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('See All', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '150',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Superior Twin',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
