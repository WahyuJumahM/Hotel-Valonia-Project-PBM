// lib/widgets/user/list_room_riwayat.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/user/popup_detail_riwayat.dart';
import '../../viewmodels/user/mybooking_riwayat_viewmodel.dart';
import '../../models/user/mybooking.dart';

class ListRoomRiwayat extends StatefulWidget {
  const ListRoomRiwayat({super.key});

  @override
  State<ListRoomRiwayat> createState() => _ListRoomRiwayatState();
}

class _ListRoomRiwayatState extends State<ListRoomRiwayat> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  
  final List<String> _filterOptions = [
    'Semua',
    'Selesai',
    'Pembatalan Disetujui',
  ];

  @override
  void initState() {
    super.initState();
    // Load data riwayat booking saat widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().loadBookingHistory();
    });
    
    // Listen to search text changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Booking> _filterBookings(List<Booking> bookings) {
    List<Booking> filteredBookings = bookings;
    
    // Apply status filter
    if (_selectedFilter != 'Semua') {
      filteredBookings = filteredBookings.where((booking) {
        if (_selectedFilter == 'Selesai') {
          return booking.namaStatus.toLowerCase() == 'selesai';
        } else if (_selectedFilter == 'Pembatalan Disetujui') {
          return booking.namaStatus.toLowerCase() == 'pembatalan disetujui';
        }
        return true;
      }).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredBookings = filteredBookings.where((booking) {
        return booking.namaKamar.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    
    return filteredBookings;
  }

  void showBookingDetailDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => BookingDetailRiwayatPopup(booking: booking),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        // Search Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama kamar...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade500),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Filter Dropdown
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          value,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              icon: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ),
              isExpanded: true,
              dropdownColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget bookingCard({
    required BuildContext context,
    required Booking booking,
  }) {
    final viewModel = context.read<BookingViewModel>();
    
    return GestureDetector(
      onTap: () => showBookingDetailDialog(context, booking),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.white.withOpacity(0.95),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFF8FBFF).withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    booking.fotoKamar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.getStatusColor(booking.namaStatus),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: viewModel.getStatusColor(booking.namaStatus).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          booking.namaStatus,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.namaKamar,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        '${viewModel.formatCurrency(booking.harga)} /malam',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF34495E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Text(
                            viewModel.formatDateRange(booking.cekIn, booking.cekOut),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Text(
                            viewModel.getGuestInfo(booking.tipeKasur, booking.kapasitas),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, String description, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingHistory) {
          return Column(
            children: [
              _buildSearchAndFilter(),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          viewModel.errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          viewModel.clearError();
                          viewModel.loadBookingHistory();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Filter bookings based on search query and filter
        final filteredBookings = _filterBookings(viewModel.bookingHistory);

        if (viewModel.bookingHistory.isEmpty) {
          return Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child: _buildEmptyState(
                  'Belum Ada Riwayat',
                  'Riwayat booking Anda akan muncul di sini',
                  Icons.history,
                ),
              ),
            ],
          );
        }

        if (filteredBookings.isEmpty) {
          String emptyMessage = 'Tidak Ada Hasil';
          String emptyDescription = '';
          
          if (_searchQuery.isNotEmpty && _selectedFilter != 'Semua') {
            emptyDescription = 'Tidak ditemukan kamar "${_searchController.text}" dengan filter "$_selectedFilter"';
          } else if (_searchQuery.isNotEmpty) {
            emptyDescription = 'Tidak ditemukan kamar dengan nama "${_searchController.text}"';
          } else if (_selectedFilter != 'Semua') {
            emptyDescription = 'Tidak ada riwayat dengan status "$_selectedFilter"';
          }

          return Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(
                child: _buildEmptyState(
                  emptyMessage,
                  emptyDescription,
                  Icons.search_off,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refreshBookingHistory(),
                child: ListView.builder(
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return bookingCard(
                      context: context,
                      booking: booking,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}