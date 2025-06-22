import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/report_viewmodel.dart';
import '../../../widgets/admin/bottom_navbar.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ReportViewModel>(context, listen: false).fetchReport());
  }

  @override
  Widget build(BuildContext context) {
    final reportVM = Provider.of<ReportViewModel>(context);
    final report = reportVM.report;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Laporan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[700], // Blue 700
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: _currentIndex),
      body: reportVM.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1D4ED8),
                strokeWidth: 3,
              ),
            )
          : reportVM.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        reportVM.errorMessage!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : report == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Data tidak tersedia",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          
                          // Revenue Card - Highlighted at top
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 16,
                              vertical: 8,
                            ),
                            child: _buildRevenueCard(report.totalPendapatan),
                          ),

                          // Visitor Statistics Card
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 16,
                              vertical: 8,
                            ),
                            child: _buildVisitorStatsCard(report, isTablet),
                          ),

                          // Room Statistics Section
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              isTablet ? 32 : 16, 
                              32, 
                              isTablet ? 32 : 16, 
                              16
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D4ED8),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Statistik Kamar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Room Statistics Grid
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 16,
                            ),
                            child: _buildRoomStatsGrid(report, isTablet),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
/*************  ✨ Windsurf Command 🌟  *************/
  }

  Widget _buildRevenueCard(int totalPendapatan) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Total Pendapatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Rp ${_formatCurrency(totalPendapatan)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorStatsCard(dynamic report, bool isTablet) {
    final successRate = report.totalBooking == 0 
        ? 0.0 
        : report.bookingSukses / report.totalBooking;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: Color(0xFF1D4ED8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Statistik Pengunjung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          if (isTablet) 
            // Tablet Layout - Side by side
            Row(
              children: [
                Expanded(child: _buildCircularProgress(report, successRate)),
                const SizedBox(width: 32),
                Expanded(child: _buildBookingStats(report)),
              ],
            )
          else
            // Mobile Layout - Stacked
            Column(
              children: [
                _buildCircularProgress(report, successRate),
                const SizedBox(height: 32),
                _buildBookingStats(report),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(dynamic report, double successRate) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: CircularProgressIndicator(
            value: successRate,
            strokeWidth: 12,
            backgroundColor: const Color(0xFFF1F5F9),
            color: const Color(0xFF1D4ED8),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          children: [
            Text(
              report.totalBooking.toString(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const Text(
              'Total Booking',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingStats(dynamic report) {
    return Column(
      children: [
        _buildStatRow(
          icon: Icons.check_circle_outline,
          label: 'Booking Sukses',
          value: report.bookingSukses.toString(),
          color: const Color(0xFF059669),
        ),
        const SizedBox(height: 16),
        _buildStatRow(
          icon: Icons.cancel_outlined,
          label: 'Booking Cancel',
          value: report.bookingCancel.toString(),
          color: const Color(0xFFDC2626),
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomStatsGrid(dynamic report, bool isTablet) {
    final crossAxisCount = isTablet ? 4 : 2;
    final childAspectRatio = isTablet ? 1.1 : 1.0;
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      children: [
        _buildGridItem(
          icon: Icons.hotel_outlined,
          title: "Total Kamar",
          value: report.totalKamar.toString(),
          color: const Color(0xFF7C3AED),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildGridItem(
          icon: Icons.category_outlined,
          title: "Jenis Kamar",
          value: report.totalJenisKamar.toString(),
          color: const Color(0xFF059669),
          gradient: const LinearGradient(
            colors: [Color(0xFF059669), Color(0xFF10B981)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildGridItem(
          icon: Icons.star_outline,
          title: "Kamar Favorit",
          value: report.kamarTerbanyakDipesan,
          color: const Color(0xFFD97706),
          gradient: const LinearGradient(
            colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildGridItem(
          icon: Icons.trending_up_outlined,
          title: "Tingkat Sukses",
          value: "${((report.totalBooking == 0 ? 0 : report.bookingSukses / report.totalBooking) * 100).toStringAsFixed(1)}%",
          color: const Color(0xFF1D4ED8),
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required LinearGradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}