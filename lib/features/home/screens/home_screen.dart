import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../../screens/train/train_schedule_screen.dart';
import '../../../screens/bus/bus_schedule_screen.dart';
import '../../../screens/bus/bus_tracking_screen.dart';
import '../../../screens/ride_hailing/ride_hailing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  
  List<Polyline> _trainRoutes = [];
  List<Marker> _trainStops = [];
  bool _isLoadingGTFS = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadGTFSData();
  }

  Future<void> _loadGTFSData() async {
    try {
      final shapesData = await DefaultAssetBundle.of(context).loadString('assets/gtfs_rapid_rail_kl/shapes.txt');
      final stopsData = await DefaultAssetBundle.of(context).loadString('assets/gtfs_rapid_rail_kl/stops.txt');

      Map<String, Color> routeColors = {
        'AG': const Color(0xFFE57200), // Orange
        'KJ': const Color(0xFFD50032), // Red
        'PH': const Color(0xFF76232F), // Maroon
        'MRT': const Color(0xFF047940), // Dark Green
        'PYL': const Color(0xFFFFCD00), // Yellow
        'MR': const Color(0xFF84BD00), // Light Green
      };

      // 1. Parse Shapes
      Map<String, List<LatLng>> shapePoints = {};
      for (var line in shapesData.replaceAll('\r', '').split('\n').skip(1)) {
        if (line.trim().isEmpty) continue;
        var parts = line.split(',');
        if (parts.length >= 4) {
          var shapeId = parts[0];
          if (shapeId.contains('BRT')) continue; // Skip BRT
          
          var lon = double.tryParse(parts[1]);
          var lat = double.tryParse(parts[2]);
          if (lon != null && lat != null) {
            shapePoints.putIfAbsent(shapeId, () => []).add(LatLng(lat, lon));
          }
        }
      }

      List<Polyline> polylines = [];
      shapePoints.forEach((shapeId, points) {
        String routeId = shapeId.split('_')[1]; 
        polylines.add(
          Polyline(
            points: points,
            color: routeColors[routeId] ?? Colors.grey,
            strokeWidth: 3.5,
          ),
        );
      });

      // 2. Parse Stops
      List<Marker> markers = [];
      for (var line in stopsData.replaceAll('\r', '').split('\n').skip(1)) {
        if (line.trim().isEmpty) continue;
        // Split by comma respecting double quotes
        var parts = line.split(RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'));
        if (parts.length >= 6) {
          String category = parts[4];
          if (category == 'BRT') continue; // Skip BRT

          double? lat = double.tryParse(parts[2]);
          double? lon = double.tryParse(parts[3]);
          String routeId = parts[5];

          if (lat != null && lon != null) {
            markers.add(
              Marker(
                point: LatLng(lat, lon),
                width: 12,
                height: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: routeColors[routeId] ?? Colors.black,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          _trainRoutes = polylines;
          _trainStops = markers;
          _isLoadingGTFS = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading GTFS: $e');
      if (mounted) {
        setState(() => _isLoadingGTFS = false);
      }
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return;
    } 

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 13.0);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D5A3F), // Forest Green
      body: Stack(
        children: [
          // 1. Decorative Circles (Background Styling)
          Positioned(top: -50, left: -50, child: _buildCircle()),
          Positioned(top: 150, right: -100, child: _buildCircle()),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. Header Correction (Top Bar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Profile Picture
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to profile edit settings
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 25,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                        
                        // Center: App Logo
                        Image.asset(
                          'assets/images/Pavura_logo.png',
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        
                        // Right: Info Stack
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(Icons.cloud, 'Cloudy'),
                            _buildInfoRow(Icons.star, 'Pro'),
                            _buildInfoRow(Icons.location_on, 'Kuala Lumpur'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3. Search Bar "Ghosting" Fix
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      height: 55, // Fixed height to stop double border/ugly box
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A321F), // Dark Brown
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.urbanist(color: Colors.white),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Where are you going?',
                                hintStyle: GoogleFonts.urbanist(
                                  color: Colors.white70, 
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          const Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  // 4. Functional Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.4, // Aspect ratio updated
                      children: [
                        _MenuCard(
                          icon: Icons.train, 
                          title: 'Train\nSchedule',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TrainScheduleScreen()),
                          ),
                        ),
                        _MenuCard(
                          icon: Icons.directions_bus, 
                          title: 'Bus\nSchedule',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BusScheduleScreen(
                                start: 'KL Sentral',
                                destination: 'Pavilion KL',
                              ),
                            ),
                          ),
                        ),
                        _MenuCard(
                          icon: Icons.near_me, 
                          title: 'Nearby\nStops',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BusTrackingScreen(
                                start: 'Current Location',
                                destination: 'Nearby Stops',
                              ),
                            ),
                          ),
                        ),
                        _MenuCard(
                          icon: Icons.local_taxi, 
                          title: 'Ride-Hailing\nServices',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RideHailingScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Map Containment & Scrolling (Critical)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16), // Using margin for outer spacing so clip applies correctly to map
                    height: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: LatLng(3.1390, 101.6869), // KL Coordinates
                        initialZoom: 12.0, // Zoomed out slightly to see the routes
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                          userAgentPackageName: 'com.pavura.app',
                          tileProvider: CancellableNetworkTileProvider(),
                        ),
                        if (!_isLoadingGTFS)
                          PolylineLayer(
                            polylines: _trainRoutes,
                          ),
                        MarkerLayer(
                          markers: [
                            ..._trainStops,
                            // User Current Location
                            if (_currentLocation != null)
                              Marker(
                                point: _currentLocation!,
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.my_location,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            else
                              const Marker(
                                point: LatLng(3.1390, 101.6869),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color: Color(0xFF2D5A3F),
                                  size: 40,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Extra padding at bottom for scroll clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCircle() => Container(
    width: 200, height: 200,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 20),
    ),
  );

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          text, 
          style: GoogleFonts.urbanist(
            color: Colors.white, 
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _MenuCard({
    required this.icon, 
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Material(
      color: const Color(0xFFD9D9D9), // Sage Gray
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  title, 
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold, 
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
