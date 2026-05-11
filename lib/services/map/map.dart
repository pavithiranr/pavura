import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapService {
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  
  // Center coordinates for Kuala Lumpur
  static const LatLng klCenter = LatLng(3.1390, 101.6869);
  
  static Widget buildMap({
    required LatLng center,
    double zoom = 13.0,
    List<Marker> markers = const [],
    List<Polyline> routes = const [],
  }) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: osmTileUrl,
          userAgentPackageName: 'com.example.passenger_transportation_tracker',
          maxZoom: 18,
        ),
        MarkerLayer(markers: markers),
        PolylineLayer(polylines: routes),
      ],
    );
  }

  static Marker createMarker({
    required LatLng position,
    required String label,
    Color color = Colors.red,
  }) {
    return Marker(
      point: position,
      width: 80,
      height: 80,
      child: Column(
        children: [
          Icon(Icons.location_on, color: color, size: 30),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  static Polyline createRoute({
    required List<LatLng> points,
    Color color = Colors.blue,
    double width = 4.0,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: width,
    );
  }
}