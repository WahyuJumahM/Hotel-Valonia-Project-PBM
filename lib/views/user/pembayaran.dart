//lib/views/user/pembayaran.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user/booking_viewmodel.dart';
import '../../viewmodels/user/kamar_viewmodel.dart';
import '../../viewmodels/auth/user_auth_viewmodel.dart'; // Import UserViewModel
import 'mybooking.dart';

class PembayaranPage extends StatefulWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int totalBayar;

  const PembayaranPage({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalBayar,
  });

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int? _selectedMetode;
  String? _selectedBank;

  // E-Wallet options
  final List<Map<String, dynamic>> eWalletMethods = [
    {
      "id": "gopay",
      "title": "GoPay",
      "image": "assets/images/gopay.png",
      "subtitle": "Saldo: unlimited",
    },
    {
      "id": "shopeepay",
      "title": "ShopeePay",
      "image": "assets/images/shopeepay.png", //
      "subtitle": "Saldo: unlimited",
    },
    {
      "id": "dana",
      "title": "DANA",
      "image": "assets/images/dana.png", // Path to dana image
      "subtitle": "Saldo: unlimited",
    },
  ];

  // Bank options for dropdown
  final List<Map<String, String>> bankOptions = [
    {"value": "bca", "name": "Bank BCA"},
    {"value": "bri", "name": "Bank BRI"},
    {"value": "bni", "name": "Bank BNI"},
  ];

  @override
  void initState() {
    super.initState();
    // Validate user session when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateUserSession();
    });
  }

  void _validateUserSession() async {
    final userViewModel = context.read<UserViewModel>();
    final bookingViewModel = context.read<DetailBookingViewModel>();

    if (!userViewModel.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    // Validate session with booking viewmodel
    final isValid = await bookingViewModel.validateUserSession();
    if (!isValid) {
      _showLoginRequiredDialog();
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Diperlukan'),
          content: const Text(
            'Anda perlu login untuk melanjutkan proses pembayaran.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous page
              },
              child: const Text('Kembali'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login page - adjust route as needed
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _handlePayment() async {
    if (_selectedMetode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if bank is selected when payment method is bank transfer
    if (_selectedMetode == 1 && _selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih bank terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final userViewModel = context.read<UserViewModel>();
    final bookingViewModel = context.read<DetailBookingViewModel>();
    final kamarViewModel = context.read<KamarViewModel>();

    // Double check user is still logged in
    if (!userViewModel.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    if (kamarViewModel.selectedKamar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data kamar tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memproses pembayaran...'),
            ],
          ),
        );
      },
    );

    try {
      // Validate user session before creating booking
      final isSessionValid = await bookingViewModel.validateUserSession();
      if (!isSessionValid) {
        Navigator.of(context).pop(); // Close loading dialog
        _showLoginRequiredDialog();
        return;
      }

      // Create booking via API
      final success = await bookingViewModel.createBooking(
        kamarViewModel.selectedKamar!.idKamar,
        widget.checkInDate,
        widget.checkOutDate,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Navigate to success page
        _navigateToSuccess();
      } else {
        // Handle specific error messages
        String errorMessage = bookingViewModel.errorMessage;

        if (errorMessage.contains('login') || errorMessage.contains('Sesi')) {
          _showLoginRequiredDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage.isNotEmpty
                    ? errorMessage
                    : 'Gagal memproses pembayaran',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      String errorMessage = e.toString();
      if (errorMessage.contains('Unauthorized') ||
          errorMessage.contains('401')) {
        _showLoginRequiredDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSuccess() {
    String selectedMethod = "";
    if (_selectedMetode == 0) {
      selectedMethod = eWalletMethods[0]["title"]; // First e-wallet selected
    } else if (_selectedMetode == 1) {
      selectedMethod =
          bankOptions.firstWhere(
            (bank) => bank["value"] == _selectedBank,
          )["name"] ??
          "Bank Transfer";
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => PembayaranBerhasilPage(
              totalBayar: widget.totalBayar,
              checkInDate: widget.checkInDate,
              checkOutDate: widget.checkOutDate,
              selectedMetode: selectedMethod,
            ),
      ),
    );
  }

  Widget _buildEWalletSection() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedMetode == 0 ? Colors.blue : Colors.grey.shade300,
          width: _selectedMetode == 0 ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
                size: 24,
              ),
            ),
            title: const Text(
              'E-Wallet',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: const Text('Gopay, ShopeePay, DANA'),
            trailing: Radio(
              value: 0,
              groupValue: _selectedMetode,
              onChanged: (int? value) {
                setState(() {
                  _selectedMetode = value;
                  _selectedBank = null; // Reset bank selection
                });
              },
              activeColor: Colors.blue,
            ),
            onTap: () {
              setState(() {
                _selectedMetode = 0;
                _selectedBank = null;
              });
            },
          ),
          if (_selectedMetode == 0)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children:
                    eWalletMethods.map((wallet) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                wallet["image"],
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if image not found
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.payment,
                                      color: Colors.grey.shade500,
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            wallet["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            wallet["subtitle"],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            // Handle e-wallet selection if needed
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBankSection() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedMetode == 1 ? Colors.blue : Colors.grey.shade300,
          width: _selectedMetode == 1 ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white, // <--- added
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.account_balance, color: Colors.green, size: 24),
            ),
            title: const Text(
              'Transfer Bank',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: const Text('BCA, BRI, BNI'),
            trailing: Radio(
              value: 1,
              groupValue: _selectedMetode,
              onChanged: (int? value) {
                setState(() {
                  _selectedMetode = value;
                });
              },
              activeColor: Colors.blue,
            ),
            onTap: () {
              setState(() {
                _selectedMetode = 1;
              });
            },
          ),
          if (_selectedMetode == 1)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedBank,
                  hint: const Text('Pilih Bank'),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    border: InputBorder.none,
                  ),
                  items:
                      bankOptions.map((bank) {
                        return DropdownMenuItem<String>(
                          value: bank["value"],
                          child: Text(
                            bank["name"]!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedBank = value;
                    });
                  },
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor:
            Colors.white, // Changed from Colors.black to Colors.white
        elevation: 1,
      ),
      body: Consumer3<DetailBookingViewModel, UserViewModel, KamarViewModel>(
        builder: (
          context,
          bookingViewModel,
          userViewModel,
          kamarViewModel,
          child,
        ) {
          // Show login required message if not logged in
          if (!userViewModel.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Login Diperlukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Silakan login untuk melanjutkan pembayaran'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Payment amount summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${NumberFormat('#,###').format(widget.totalBayar)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(widget.checkInDate)} - ${DateFormat('dd MMM yyyy').format(widget.checkOutDate)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Payment methods
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // E-Wallet Section
                      _buildEWalletSection(),

                      // Bank Transfer Section
                      _buildBankSection(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Pay button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      bookingViewModel.isCreatingBooking
                          ? null
                          : (_canProceedPayment() ? _handlePayment : null),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor:
                        _canProceedPayment()
                            ? Colors.blue
                            : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: _canProceedPayment() ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      bookingViewModel.isCreatingBooking
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Memproses...'),
                            ],
                          )
                          : Text(
                            _canProceedPayment()
                                ? 'Bayar Rp ${NumberFormat('#,###').format(widget.totalBayar)}'
                                : 'Pilih Metode Pembayaran',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _canProceedPayment() {
    if (_selectedMetode == null) return false;
    if (_selectedMetode == 1 && _selectedBank == null) return false;
    return true;
  }
}

class PembayaranBerhasilPage extends StatelessWidget {
  final int totalBayar;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String selectedMetode;

  const PembayaranBerhasilPage({
    super.key,
    required this.totalBayar,
    required this.checkInDate,
    required this.checkOutDate,
    required this.selectedMetode,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Informasi',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success icon with animation
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade200,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Booking Anda akan segera diproses",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Payment amount
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade600,
                    Colors.blue.shade800,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade300.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL BAYAR",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Rp ${NumberFormat('#,###').format(totalBayar)}",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Booking details card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDetailRow("Check-In", dateFormat.format(checkInDate)),
                    const Divider(height: 20),
                    _buildDetailRow(
                      "Check-Out",
                      dateFormat.format(checkOutDate),
                    ),
                    const Divider(height: 20),
                    _buildDetailRow("Metode Pembayaran", selectedMetode),
                    const Divider(height: 20),
                    _buildDetailRow(
                      "Status Pembayaran",
                      "Terkonfirmasi",
                      isStatus: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.yellow.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.yellow.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Pesanan Anda dalam antrean, akan segera diproses oleh admin.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.yellow.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Main action button - Lihat Detail
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookingPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.list_alt, color: Colors.white),
                label: const Text("Lihat Detail Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 52),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child:
              isStatus
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color.fromARGB(255, 3, 145, 62), const Color.fromARGB(255, 20, 196, 122)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                  : Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
        ),
      ],
    );
  }
}
