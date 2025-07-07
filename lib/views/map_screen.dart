import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static const salonLat = -34.905;
  static const salonLng = -56.191;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icon.png',
    );
    setState(() {
      _customMarker = markerIcon;
    });
  }

  Future<void> _launchNavigation() async {
    final uri = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${MapScreen.salonLat},${MapScreen.salonLng}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(MapScreen.salonLat, MapScreen.salonLng),
          zoom: 16,
        ),
        markers: _customMarker == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('salon'),
                  position: const LatLng(MapScreen.salonLat, MapScreen.salonLng),
                  icon: _customMarker!,
                  infoWindow: const InfoWindow(title: 'Lashess by Prii'),
                ),
              },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchNavigation,
        label: const Text("Cómo llegar"),
        icon: const Icon(Icons.navigation),
      ),
    );
  }
}
