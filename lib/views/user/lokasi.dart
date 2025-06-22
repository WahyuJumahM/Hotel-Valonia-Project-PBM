import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> with TickerProviderStateMixin {
  LatLng? lokasiAwal;
  final LatLng lokasiTujuan = const LatLng(-8.17063, 113.72686);
  final MapController _mapController = MapController();
  String errorMessage = '';
  List<LatLng> routePoints = [];
  bool isLoadingRoute = false;
  String? routeDistance;
  String? routeDuration;
  StreamSubscription<Position>? _positionStream;
  bool isTrackingEnabled = false;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  double currentSpeed = 0.0;
  double currentAccuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Layanan lokasi tidak aktif.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Izin lokasi ditolak.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Izin lokasi ditolak permanen.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        lokasiAwal = LatLng(position.latitude, position.longitude);
        currentSpeed = position.speed * 3.6; // Convert m/s to km/h
        currentAccuracy = position.accuracy;
        errorMessage = '';
      });

      await _getRoute();
      _startRealTimeTracking();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void _startRealTimeTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update setiap 5 meter
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          lokasiAwal = LatLng(position.latitude, position.longitude);
          currentSpeed = position.speed * 3.6; // Convert to km/h
          currentAccuracy = position.accuracy;
          isTrackingEnabled = true;
        });

        // Update route jika diperlukan
        if (routePoints.isEmpty) {
          _getRoute();
        }
      }
    });
  }

  Future<void> _getRoute() async {
    if (lokasiAwal == null) return;

    setState(() {
      isLoadingRoute = true;
      routePoints.clear();
    });

    try {
      final String url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${lokasiAwal!.longitude},${lokasiAwal!.latitude};'
          '${lokasiTujuan.longitude},${lokasiTujuan.latitude}'
          '?geometries=geojson&overview=full&steps=true';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry']['coordinates'] as List;

          final List<LatLng> points =
              geometry.map((coord) {
                return LatLng(coord[1].toDouble(), coord[0].toDouble());
              }).toList();

          final distance = route['distance'] / 1000;
          final duration = route['duration'] / 60;

          setState(() {
            routePoints = points;
            routeDistance = '${distance.toStringAsFixed(1)} km';
            routeDuration = '${duration.toStringAsFixed(0)} menit';
            isLoadingRoute = false;
          });
        } else {
          setState(() {
            errorMessage = 'Rute tidak ditemukan';
            isLoadingRoute = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal mendapatkan rute: ${response.statusCode}';
          isLoadingRoute = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error mendapatkan rute: $e';
        isLoadingRoute = false;
      });
    }
  }

  void _refreshLocation() async {
    setState(() {
      errorMessage = '';
      routePoints.clear();
    });

    await _getCurrentLocation();

    if (lokasiAwal != null) {
      _mapController.move(lokasiAwal!, 15);
    }
  }

  void _toggleTracking() {
    if (isTrackingEnabled) {
      _positionStream?.cancel();
      setState(() {
        isTrackingEnabled = false;
      });
    } else {
      _startRealTimeTracking();
    }
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (routeDistance != null && routeDuration != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    Icons.straighten_rounded,
                    'Jarak',
                    routeDistance!,
                    Colors.blue,
                  ),
                  _buildInfoItem(
                    Icons.access_time_rounded,
                    'Waktu',
                    routeDuration!,
                    Colors.green,
                  ),
                ],
              ),
            if (isTrackingEnabled) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    Icons.speed_rounded,
                    'Kecepatan',
                    '${currentSpeed.toStringAsFixed(1)} km/h',
                    Colors.orange,
                  ),
                  _buildInfoItem(
                    Icons.gps_fixed_rounded,
                    'Akurasi',
                    '${currentAccuracy.toStringAsFixed(0)} m',
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationMarker() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: 60 + (_pulseController.value * 20),
              height: 60 + (_pulseController.value * 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(
                  0.3 - (_pulseController.value * 0.3),
                ),
              ),
            ),
            // Main marker
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTrackingEnabled ? Colors.green : Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isTrackingEnabled
                    ? Icons.navigation_rounded
                    : Icons.my_location_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDestinationMarker() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating ring
            Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Label
            Positioned(
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: const Text(
                  'Hotel Valonia',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Main marker
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Lokasi Kami',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isTrackingEnabled ? Icons.gps_fixed : Icons.gps_not_fixed,
              color: isTrackingEnabled ? Colors.green.shade200 : Colors.white,
            ),
            onPressed: _toggleTracking,
            tooltip: isTrackingEnabled ? 'Stop Tracking' : 'Start Tracking',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshLocation,
            tooltip: 'Refresh Location',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (isLoadingRoute)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade100, Colors.orange.shade50],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Mencari rute terbaik...',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (routeDistance != null || isTrackingEnabled) _buildInfoCard(),
          Expanded(
            child:
                errorMessage.isNotEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _refreshLocation,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : lokasiAwal == null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Mencari lokasi Anda...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    : FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: lokasiAwal!,
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        if (routePoints.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              // Shadow
                              Polyline(
                                points: routePoints,
                                color: Colors.black.withOpacity(0.3),
                                strokeWidth: 8.0,
                              ),
                              // Main route
                              Polyline(
                                points: routePoints,
                                color: Colors.blue.shade600,
                                strokeWidth: 6.0,
                              ),
                              // Highlight
                              Polyline(
                                points: routePoints,
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            ],
                          ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: lokasiAwal!,
                              width: 80,
                              height: 80,
                              child: _buildCurrentLocationMarker(),
                            ),
                            Marker(
                              point: lokasiTujuan,
                              width: 100,
                              height: 100,
                              child: _buildDestinationMarker(),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton:
          routePoints.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () {
                  if (routePoints.isNotEmpty) {
                    double minLat = routePoints.first.latitude;
                    double maxLat = routePoints.first.latitude;
                    double minLng = routePoints.first.longitude;
                    double maxLng = routePoints.first.longitude;

                    for (final point in routePoints) {
                      minLat =
                          minLat < point.latitude ? minLat : point.latitude;
                      maxLat =
                          maxLat > point.latitude ? maxLat : point.latitude;
                      minLng =
                          minLng < point.longitude ? minLng : point.longitude;
                      maxLng =
                          maxLng > point.longitude ? maxLng : point.longitude;
                    }

                    _mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: LatLngBounds(
                          LatLng(minLat, minLng),
                          LatLng(maxLat, maxLng),
                        ),
                        padding: const EdgeInsets.all(50),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.fit_screen_rounded),
                label: const Text('Lihat Rute'),
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
              : null,
    );
  }
}
