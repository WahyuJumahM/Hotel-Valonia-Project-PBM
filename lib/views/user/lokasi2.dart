import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class TesMap extends StatefulWidget {
  const TesMap({super.key});
  static const routeName = '/tesmap';

  @override
  State<TesMap> createState() => _TesMapState();
}

class _TesMapState extends State<TesMap> {
  LatLng? currentLocation;
  bool isLoading = true;
  bool isRendered = false;
  String errorMessage = '';
  final MapController _mapController = MapController();

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled.';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permissions are denied.';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied.';
          isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newPosition;
        isLoading = false;
      });

      if (!isRendered) {
        _mapController.move(currentLocation!, 15);
        isRendered = true;
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _getCurrentLocation();
            },
          ),
        ],
      ),
      body: _buildMap(),
    );
  }

  Widget _buildMap() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (currentLocation == null) {
      return const Center(child: Text('Location not found'));
    }

    return FlutterMap(children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.geolocator_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                )
                ),
            ],
          )
      ],
    );
  }
}