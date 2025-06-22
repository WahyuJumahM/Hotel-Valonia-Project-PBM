// lib/widgets/admin/booking_widgets/daftar_booking_card.dart
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin/booking_model.dart';
import '../../viewmodels/admin/booking_admin_viewmodel.dart';
import '../../views/admin/Homepage_screen/detail_booking_user_screen.dart';
import '../../services/admin/booking_admin_service.dart';  

class DaftarBookingCard extends StatefulWidget {
  final BookingAdminDetail booking;
  final VoidCallback? onRefresh;

  const DaftarBookingCard({Key? key, required this.booking, this.onRefresh})
    : super(key: key);

  @override
  State<DaftarBookingCard> createState() => _DaftarBookingCardState();
}

class _DaftarBookingCardState extends State<DaftarBookingCard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _catatanController = TextEditingController();
  bool _showCatatanField = false;
  int? _selectedAction;
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
    _catatanController.dispose();
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
    final viewModel = Provider.of<BookingAdminViewModel>(context);

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
                          _getStatusColor(
                            widget.booking.idStatus,
                          ).withOpacity(0.1),
                          _getStatusColor(
                            widget.booking.idStatus,
                          ).withOpacity(0.05),
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
                            child:
                                widget.booking.fotoKamar != null &&
                                        widget.booking.fotoKamar!.isNotEmpty
                                    ? Image.network(
                                      widget.booking.fotoKamar!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return _buildDefaultRoomImage();
                                      },
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
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
                                  color: _getStatusColor(
                                    widget.booking.idStatus,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(
                                        widget.booking.idStatus,
                                      ).withOpacity(0.3),
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

                        // Action buttons
                        Row(
                          children: [
                            // Detail button
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailBookingUserScreen(
                                            booking: widget.booking.toJson(),
                                          ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility, size: 18, color: Color(0xFF3498DB)),
                                label: const Text('Detail'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF3498DB),
                                  side: const BorderSide(
                                    color: Color(0xFF3498DB),
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Approve button
                            if (viewModel.canApprove(widget.booking.idBooking))
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      viewModel.isUpdating
                                          ? null
                                          : () => _showUpdateDialog(2),
                                  icon:
                                      viewModel.isUpdating
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                  label: const Text('Setujui'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF27AE60),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                ),
                              ),

                            // Complete button
                            if (viewModel.canComplete(widget.booking.idBooking))
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      viewModel.isUpdating
                                          ? null
                                          : () => _showUpdateDialog(3),
                                  icon:
                                      viewModel.isUpdating
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : const Icon(
                                            Icons.task_alt,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                  label: const Text('Selesai'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3498DB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isPrice ? 16 : 15,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
                  color:
                      isPrice
                          ? const Color(0xFF27AE60)
                          : const Color(0xFF2C3E50),
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
    final difference =
        widget.booking.cekOut.difference(widget.booking.cekIn).inDays;
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

  void _showUpdateDialog(int action) {
    final viewModel = Provider.of<BookingAdminViewModel>(
      context,
      listen: false,
    );
    String actionText = action == 2 ? 'menyetujui' : 'menyelesaikan';

    // Validate action
    if (action == 2 && !viewModel.canApprove(widget.booking.idBooking)) {
      _showErrorDialog(
        'Booking ini tidak dapat disetujui pada status saat ini',
      );
      return;
    }

    if (action == 3 && !viewModel.canComplete(widget.booking.idBooking)) {
      String errorMsg;
      if (widget.booking.idStatus == 1) {
        errorMsg =
            'Booking ini tidak dapat diselesaikan. Setujui terlebih dahulu.';
      } else {
        errorMsg = 'Booking ini tidak dapat diselesaikan pada status saat ini.';
      }
      _showErrorDialog(errorMsg);
      return;
    }

    setState(() {
      _selectedAction = action;
      _showCatatanField = true;
      _catatanController.clear();
    });

    // Custom dialog content based on current status
    String dialogTitle = 'Konfirmasi ${actionText.toUpperCase()}';
    String dialogContent = 'Apakah Anda yakin ingin $actionText booking ini?';

    if (action == 3 && widget.booking.idStatus == 5) {
      dialogTitle = 'Konfirmasi SELESAIKAN BOOKING';
      dialogContent =
          'Booking dengan pembatalan ditolak akan diselesaikan. Apakah Anda yakin?';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFFFFFF), // Pure white background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    action == 2 ? Icons.check_circle : Icons.task_alt,
                    color: action == 2 ? Colors.green : Colors.blue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dialogTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dialogContent, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            icon: Icons.confirmation_number,
                            label: 'Booking ID',
                            value: '#${widget.booking.idBooking}',
                            isBold: true,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.person,
                            label: 'Nama Tamu',
                            value: widget.booking.namaLengkap,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.room,
                            label: 'Kamar',
                            value: widget.booking.namaKamar,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.info_outline,
                            label: 'Status Saat Ini',
                            value: widget.booking.namaStatus,
                            valueColor: _getStatusColor(
                              widget.booking.idStatus,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        hintText: 'Tambahkan catatan untuk booking ini...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: action == 2 ? Colors.green : Colors.blue,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.note_add),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _showCatatanField = false;
                      _selectedAction = null;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Batal', style: TextStyle(fontSize: 16)),
                ),
                Consumer<BookingAdminViewModel>(
                  builder: (context, viewModel, child) {
                    return ElevatedButton(
                      onPressed:
                          viewModel.isUpdating
                              ? null
                              : () async {
                                await _handleUpdateStatus(viewModel, action);
                                // Dialog will be closed inside _handleUpdateStatus
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            action == 2 ? Colors.green : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          viewModel.isUpdating
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                action == 2 ? 'SETUJUI' : 'SELESAI',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleUpdateStatus(
    BookingAdminViewModel viewModel,
    int action,
  ) async {
    bool success = false;

    if (action == 2) {
      success = await viewModel.approveBooking(
        bookingId: widget.booking.idBooking,
        catatan:
            _catatanController.text.trim().isEmpty
                ? null
                : _catatanController.text.trim(),
      );
    } else if (action == 3) {
      success = await viewModel.completeBooking(
        bookingId: widget.booking.idBooking,
        catatan:
            _catatanController.text.trim().isEmpty
                ? null
                : _catatanController.text.trim(),
      );
    }

    // Close the dialog first before showing success/error dialog
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (success) {
      String successMsg = action == 2 ? 'disetujui' : 'diselesaikan';
      _showSuccessDialog(successMsg);
      widget.onRefresh?.call();
    } else {
      _showErrorDialog(viewModel.errorMessage ?? 'Terjadi kesalahan');
    }

    setState(() {
      _showCatatanField = false;
      _selectedAction = null;
    });
  }

  void _showSuccessDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF), // Pure white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
          ),
          title: const Text(
            'Berhasil',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Booking berhasil $action',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF), // Pure white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error, color: Colors.red, size: 48),
          ),
          title: const Text(
            'Error',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
