import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  LatLng? lokasiAwal;
  final LatLng lokasiTujuan = const LatLng(-8.17063, 113.72686);
  final MapController _mapController = MapController();
  String errorMessage = '';
  List<LatLng> routePoints = [];
  bool isLoadingRoute = false;
  String? routeDistance;
  String? routeDuration;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
        errorMessage = '';
      });

      await _getRoute();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
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

          final List<LatLng> points = geometry.map((coord) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Kami'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _refreshLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          if (routeDistance != null && routeDuration != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.straighten, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text('Jarak: $routeDistance',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text('Waktu: $routeDuration',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          if (isLoadingRoute)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange.shade50,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Mencari rute terbaik...'),
                ],
              ),
            ),
          Expanded(
            child: errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshLocation,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : lokasiAwal == null
                    ? const Center(child: CircularProgressIndicator())
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
                                Polyline(
                                  points: routePoints,
                                  color: Colors.blue,
                                  strokeWidth: 5.0,
                                ),
                                Polyline(
                                  points: routePoints,
                                  color: Colors.white,
                                  strokeWidth: 7.0,
                                ),
                                Polyline(
                                  points: routePoints,
                                  color: Colors.blue,
                                  strokeWidth: 5.0,
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: lokasiAwal!,
                                width: 80,
                                height: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Marker(
                                point: lokasiTujuan,
                                width: 100,
                                height: 100,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Hotel Valonia',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: routePoints.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                if (routePoints.isNotEmpty) {
                  double minLat = routePoints.first.latitude;
                  double maxLat = routePoints.first.latitude;
                  double minLng = routePoints.first.longitude;
                  double maxLng = routePoints.first.longitude;

                  for (final point in routePoints) {
                    minLat = minLat < point.latitude ? minLat : point.latitude;
                    maxLat = maxLat > point.latitude ? maxLat : point.latitude;
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
              icon: const Icon(Icons.fit_screen),
              label: const Text('Lihat Rute'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
