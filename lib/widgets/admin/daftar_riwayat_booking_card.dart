// lib/widgets/admin/booking_widgets/daftar_riwayat_booking_card.dart
// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import '../../models/admin/booking_model.dart';
import '../../views/admin/Homepage_screen/detail_booking_user_screen.dart';
import '../../services/admin/booking_admin_service.dart';

class DaftarRiwayatBookingCard extends StatefulWidget {
  final BookingAdminDetail booking;

  const DaftarRiwayatBookingCard({Key? key, required this.booking})
      : super(key: key);

  @override
  State<DaftarRiwayatBookingCard> createState() =>
      _DaftarRiwayatBookingCardState();
}

class _DaftarRiwayatBookingCardState extends State<DaftarRiwayatBookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatPrice(double? price) {
    if (price == null) return 'Rp 0';
    return 'Rp ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header dengan status dan foto
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getStatusColor(widget.booking.idStatus)
                              .withOpacity(0.1),
                          _getStatusColor(widget.booking.idStatus)
                              .withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Room photo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.booking.fotoKamar != null &&
                                    widget.booking.fotoKamar!.isNotEmpty
                                ? Image.network(
                                    widget.booking.fotoKamar!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultRoomImage();
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null)
                                        return child;
                                      return Container(
                                        color: Colors.grey.shade100,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : _buildDefaultRoomImage(),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Booking info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Booking #${widget.booking.idBooking}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(widget.booking.idStatus),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(widget.booking.idStatus)
                                          .withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.booking.namaStatus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Guest info
                        _buildInfoTile(
                          icon: Icons.person,
                          iconColor: const Color(0xFF3498DB),
                          title: 'Nama Tamu',
                          subtitle: widget.booking.namaLengkap,
                        ),
                        const SizedBox(height: 16),

                        // Room info with floor
                        _buildInfoTile(
                          icon: Icons.room,
                          iconColor: const Color(0xFF9B59B6),
                          title: 'Kamar & Tipe',
                          subtitle:
                              '${widget.booking.namaKamar} - ${widget.booking.namaJenisKamar}',
                          additionalInfo: 'Lantai ${widget.booking.lantai}',
                        ),
                        const SizedBox(height: 16),

                        // Bed type
                        _buildInfoTile(
                          icon: Icons.bed,
                          iconColor: const Color(0xFFE67E22),
                          title: 'Tipe Kasur',
                          subtitle: widget.booking.tipeKasur,
                          additionalInfo:
                              'Kapasitas ${widget.booking.kapasitas} orang',
                        ),
                        const SizedBox(height: 16),

                        // Date info
                        _buildInfoTile(
                          icon: Icons.calendar_today,
                          iconColor: const Color(0xFF16A085),
                          title: 'Periode Menginap',
                          subtitle:
                              '${_formatDate(widget.booking.cekIn)} - ${_formatDate(widget.booking.cekOut)}',
                          additionalInfo: _calculateNights(),
                        ),
                        const SizedBox(height: 16),

                        // Price info
                        _buildInfoTile(
                          icon: Icons.payments,
                          iconColor: const Color(0xFF27AE60),
                          title: 'Total Pembayaran',
                          subtitle: _formatPrice(widget.booking.totalHarga),
                          isPrice: true,
                        ),
                        const SizedBox(height: 20),

                        // Action buttons - Hanya tombol Detail
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailBookingUserScreen(
                                              booking: widget.booking.toJson()),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
                                label: const Text('Detail'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF3498DB),
                                  side: const BorderSide(
                                    color: Color(0xFF3498DB),
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Notes section (if exists)
                        if (widget.booking.catatan != null &&
                            widget.booking.catatan!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade50,
                                  Colors.amber.shade50,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.sticky_note_2,
                                    size: 20,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Catatan Admin:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.booking.catatan!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF2C3E50),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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

  Widget _buildDefaultRoomImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.bed, size: 32, color: Colors.grey.shade400),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? additionalInfo,
    bool isPrice = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isPrice ? 16 : 15,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
                  color: isPrice ? const Color(0xFF27AE60) : const Color(0xFF2C3E50),
                  height: 1.2,
                ),
              ),
              if (additionalInfo != null) ...[
                const SizedBox(height: 2),
                Text(
                  additionalInfo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _calculateNights() {
    final difference = widget.booking.cekOut.difference(widget.booking.cekIn).inDays;
    return '$difference malam';
  }

  // Method untuk mendapatkan warna status dari service
  Color _getStatusColor(int statusId) {
    String colorName = BookingAdminService.getStatusColor(statusId);
    switch (colorName) {
      case 'orange':
        return const Color(0xFFFF9800);
      case 'green':
        return const Color(0xFF4CAF50);
      case 'blue':
        return const Color(0xFF2196F3);
      case 'purple':
        return const Color(0xFF9C27B0);
      case 'red':
        return const Color(0xFFF44336);
      case 'grey':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF757575); // Default grey
    }
  }
}