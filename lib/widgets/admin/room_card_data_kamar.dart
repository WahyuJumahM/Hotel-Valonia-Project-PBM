// lib/widgets/admin/room_card_data_kamar.dart
import 'package:flutter/material.dart';
import '../../views/admin/kamar_screen/detail_kamar_screen.dart';
import '../../models/admin/data_kamar_model.dart';

class RoomCard extends StatelessWidget {
  final Kamar room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 900;
    
    // Responsive dimensions
    final imageSize = isDesktop ? 100.0 : (isTablet ? 90.0 : 80.0);
    final cardMargin = isDesktop ? 20.0 : (isTablet ? 16.0 : 12.0);
    final cardPadding = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final titleFontSize = isDesktop ? 18.0 : (isTablet ? 17.0 : 16.0);
    
    return Container(
      margin: EdgeInsets.only(bottom: cardMargin),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailKamarScreen(kamar: room),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // Pure white
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: isDesktop || isTablet
                  ? _buildDesktopLayout(imageSize, titleFontSize)
                  : _buildMobileLayout(imageSize, titleFontSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double imageSize, double titleFontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageContainer(imageSize),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoomName(titleFontSize),
              const SizedBox(height: 8),
              _buildRoomType(),
              const SizedBox(height: 8),
              _buildPriceTag(),
              const SizedBox(height: 12),
              _buildInfoRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(double imageSize, double titleFontSize) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageContainer(imageSize),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoomName(titleFontSize),
                  const SizedBox(height: 8),
                  _buildRoomType(),
                  const SizedBox(height: 8),
                  _buildPriceTag(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow(),
      ],
    );
  }

  Widget _buildImageContainer(double size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          room.fotoKamar ?? 'https://via.placeholder.com/150x150',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[200]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.hotel_rounded,
                color: Colors.grey[400],
                size: size * 0.4,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue[400],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoomName(double fontSize) {
    return Text(
      room.namaKamar,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: const Color(0xFF1A1A1A),
        letterSpacing: -0.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRoomType() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        room.namaJenisKamar ?? 'Jenis tidak diketahui',
        style: const TextStyle(
          color: Color(0xFF3B82F6),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildFloorInfo(),
        if (room.kapasitas != null) _buildCapacityInfo(),
        if (room.jumlahDireservasi != null) _buildReservationInfo(),
      ],
    );
  }

  Widget _buildFloorInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.layers_rounded,
            size: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Lantai ${room.lantai}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCapacityInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.people_rounded,
            size: 14,
            color: Colors.orange[600],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${room.kapasitas} orang',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildReservationInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.bookmark_rounded,
            size: 14,
            color: Colors.purple[600],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${room.jumlahDireservasi} reservasi',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }



  Widget _buildPriceTag() {
    if (room.harga == null) return const SizedBox.shrink();
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF10B981),
              const Color(0xFF059669),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Rp ${_formatPrice(room.harga!.toInt())}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}