import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResultsScreen extends StatelessWidget {
  final String startLocation;
  final String destination;

  const SearchResultsScreen({
    super.key,
    required this.startLocation,
    required this.destination,
  });

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Results for: $startLocation to $destination',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Assume 5 routes for now, can be dynamic
                itemBuilder: (final context, final index) {
                  final routeDetails = 'Route ${index + 1}';
                  return ListTile(
                    title: Text(routeDetails),
                    subtitle: Text('Estimated Time: ${index * 15 + 30} minutes'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Example route coordinates, replace with actual data
                        final routeCoordinates = [
                          const LatLng(3.1390, 101.6869), // Starting point
                          const LatLng(3.1500, 101.7000), // End point
                        ];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (final context) => RouteTrackingScreen(
                              routeDetails: routeDetails,
                              routeCoordinates: routeCoordinates,
                            ),
                          ),
                        );
                      },
                      child: const Text('Track on Map'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteTrackingScreen extends StatefulWidget {
  final String routeDetails;
  final List<LatLng> routeCoordinates;

  const RouteTrackingScreen({
    super.key,
    required this.routeDetails,
    required this.routeCoordinates,
  });

  @override
  State<RouteTrackingScreen> createState() => _RouteTrackingScreenState();
}

class _RouteTrackingScreenState extends State<RouteTrackingScreen> {
  // Removed unused _mapController field

  @override
  Widget build(final BuildContext context) {
    // Check if the coordinates are valid
    if (widget.routeCoordinates.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Route Tracking - ${widget.routeDetails}'),
        ),
        body: const Center(
          child: Text('No route data available to display.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Tracking - ${widget.routeDetails}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.routeCoordinates.first,
          zoom: 12.0,
        ),
        markers: widget.routeCoordinates
            .map((final coord) => Marker(
                  markerId: MarkerId(coord.toString()),
                  position: coord,
                ),)
            .toSet(),
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: widget.routeCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
        onMapCreated: (final controller) {
          // Map controller created but not stored as it's unused
        },
      ),
    );
  }
}
