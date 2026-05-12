import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainScheduleScreen extends StatefulWidget {
  const TrainScheduleScreen({super.key});

  @override
  State<TrainScheduleScreen> createState() => _TrainScheduleScreenState();
}

class _TrainScheduleScreenState extends State<TrainScheduleScreen> {
  String _searchQuery = '';
  List<String> _allStations = [];
  Map<String, Set<String>> _stationLines = {};

  @override
  void initState() {
    super.initState();
    _loadLocalStops();
  }

  Future<void> _loadLocalStops() async {
    try {
      final stopsData = await DefaultAssetBundle.of(context).loadString('assets/gtfs_rapid_rail_kl/stops.txt');
      Map<String, Set<String>> stationLines = {};
      
      for (var line in stopsData.replaceAll('\r', '').split('\n').skip(1)) {
        if (line.trim().isEmpty) continue;
        var parts = line.split(RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'));
        if (parts.length >= 6) {
          String category = parts[4];
          if (category == 'BRT') continue; // Skip bus

          String rawStopName = parts[1].replaceAll('"', '').trim();
          String routeId = parts[5];
          
          if (routeId == 'KGL' || routeId == 'MRT') routeId = 'KG';
          if (routeId == 'PYL') routeId = 'PY';
          if (routeId == 'SPL') routeId = 'PH';

          // Clean up common station names
          if (rawStopName.contains('KL SENTRAL')) rawStopName = 'KL Sentral';
          if (rawStopName.contains('MASJID JAMEK')) rawStopName = 'Masjid Jamek';
          if (rawStopName.contains('PASAR SENI')) rawStopName = 'Pasar Seni';

          stationLines.putIfAbsent(rawStopName, () => {}).add(routeId);
        }
      }
      
      if (mounted) {
        setState(() {
          _allStations = stationLines.keys.toList()..sort();
          _stationLines = stationLines;
        });
      }
    } catch (e) {
      debugPrint('Error loading stops: $e');
    }
  }

  String? _getIconForRoute(String routeId) {
    switch (routeId) {
      case 'AG': return 'assets/images/train_logos/AGL-icon 1.png';
      case 'KJ': return 'assets/images/train_logos/KJL-icon 1.png';
      case 'KG': return 'assets/images/train_logos/KGL-icon 1.png';
      case 'PY': return 'assets/images/train_logos/PYL-icon 1.png';
      case 'MR': return 'assets/images/train_logos/MRL-icon 1.png';
      case 'PH': return 'assets/images/train_logos/SPL-Long-Logo 1.png'; // Fallback
      default: return null;
    }
  }

  String _toTitleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1).toLowerCase();
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  List<String> get _filteredStations {
    if (_searchQuery.isEmpty) return [];
    return _allStations
        .where((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A321F), // Dark Brown Figma Background
      body: Stack(
        children: [
          // Background Decorative Circles
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 30),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 30),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Custom Top Bar with Absolute Centering
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/Pavura_logo.png',
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  const SizedBox(height: 10),
                  // Search Bar
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.urbanist(color: Colors.white),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Where are you going?',
                              hintStyle: GoogleFonts.urbanist(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: _searchQuery.isEmpty 
                        ? _buildEmptyState() 
                        : _buildSearchResults(),
                  ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Recent Searches',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Hardcoded Recent Searches to match Figma
        _buildStationCard('KL Sentral', [
          'assets/images/train_logos/KJL-icon 1.png',
          'assets/images/train_logos/KGL-icon 1.png',
          'assets/images/train_logos/MRL-icon 1.png',
          'assets/images/train_logos/ekspres 1.png',
        ]),
        _buildStationCard('Masjid Jamek', [
          'assets/images/train_logos/AGL-icon 1.png',
          'assets/images/train_logos/KGL-icon 1.png', // Generic placement
          'assets/images/train_logos/KJL-icon 1.png',
        ]),
        _buildStationCard('Pasar Seni', [
          'assets/images/train_logos/KGL-icon 1.png',
          'assets/images/train_logos/KJL-icon 1.png',
        ]),
        _buildStationCard('Asia Jaya', [
          'assets/images/train_logos/KJL-icon 1.png',
        ]),

        const SizedBox(height: 16),
        Text(
          'Suggested Destinations',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStationCard('Gombak', [
          'assets/images/train_logos/KJL-icon 1.png',
        ]),
        _buildStationCard('Universiti', [
          'assets/images/train_logos/KJL-icon 1.png',
        ]),
        _buildStationCard('Dang Wangi', [
          'assets/images/train_logos/MRL-icon 1.png',
          'assets/images/train_logos/KJL-icon 1.png',
        ]),
        _buildStationCard('Kajang', [
          'assets/images/train_logos/KGL-icon 1.png',
        ]),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredStations.isEmpty) {
      return Center(
        child: Text(
          'No stations found',
          style: GoogleFonts.urbanist(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredStations.length,
      itemBuilder: (context, index) {
        final stationName = _filteredStations[index];
        final routes = _stationLines[stationName] ?? {};
        
        List<String> icons = [];
        for (var r in routes) {
          final path = _getIconForRoute(r);
          if (path != null) icons.add(path);
        }

        // Use Title Case for aesthetic display
        final displayName = stationName == 'KL Sentral' || stationName == 'Masjid Jamek' || stationName == 'Pasar Seni' 
            ? stationName 
            : _toTitleCase(stationName);

        return _buildStationCard(displayName, icons);
      },
    );
  }

  Widget _buildStationCard(String name, List<String> iconPaths) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700, // Extra Bold matching Figma
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: iconPaths.map((path) => Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Image.asset(path, height: 26, fit: BoxFit.contain),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

