import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';
import 'package:lashess_by_prii_app/widgets/custom_button_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static const salonLat = -34.905;
  static const salonLng = -56.191;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor? _customMarker;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<BitmapDescriptor> _resizeAndLoadMarker(
      String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // 👈 control size here
    );
    final frame = await codec.getNextFrame();
    final bytes = (await frame.image.toByteData(format: ImageByteFormat.png))!;
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  Future<void> _loadCustomMarker() async {
    final markerIcon =
        await _resizeAndLoadMarker('assets/images/icon.png', 96); // ~96px
    setState(() => _customMarker = markerIcon);
  }

  Future<void> _setMapStyle() async {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final stylePath = isLight
        ? 'assets/map_styles/light_map.json'
        : 'assets/map_styles/dark_map.json';

    final styleJson = await rootBundle.loadString(stylePath);
    _mapController?.setMapStyle(styleJson);
  }

  Future<void> _launchNavigation() async {
    final uri = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${MapScreen.salonLat},${MapScreen.salonLng}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callSalon() async {
    final uri = Uri.parse("tel:+11234567890"); // replace with real number
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BaseScaffold(
      currentIndex: 3,
      showBack: true,
      body: Stack(
        children: [
          // ✅ Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(MapScreen.salonLat, MapScreen.salonLng),
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _setMapStyle();
            },
            markers: _customMarker == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('salon'),
                      position:
                          const LatLng(MapScreen.salonLat, MapScreen.salonLng),
                      icon: _customMarker!,
                      infoWindow: const InfoWindow(title: 'Lashess by Prii'),
                    ),
                  },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // ✅ Bottom Info Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isLight ? AppColors.lightCard : AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lashess by Prii",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLight
                          ? AppColors.lightTextPrimary
                          : AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "1234 Beauty St, Suite 5\nSpringfield, USA",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isLight
                                ? AppColors.lightTextSecondary
                                : AppColors.darkTextSecondary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _callSalon,
                        icon: Icon(
                          Icons.phone,
                          color: isLight
                              ? AppColors.lightPrimary
                              : AppColors.darkPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Open in Google Maps",
                      onPressed: _launchNavigation,
                      type: ButtonType
                          .outlined, // 👈 outlined variant gives that bordered look
                      icon: const Icon(Icons.map, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
