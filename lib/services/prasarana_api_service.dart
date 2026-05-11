import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
// import '../protos/gtfs_realtime.pb.dart'; // TODO: Re-enable when Prasarana real-time is implemented

class PrasaranaApiService {
  static const String baseUrl = 'https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana';
  
  Future<List<Map<String, dynamic>>> fetchBusPositions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?category=rapid-bus-kl'),
        headers: {
          'Accept': 'application/x-protobuf',
        },
      );

      developer.log('API Response Status: ${response.statusCode}');
      developer.log('API Response Body: ${response.bodyBytes}');

      if (response.statusCode == 200) {
        try {
          // TODO: Re-enable protobuf parsing when gtfs_realtime.pb.dart is available
          /*
          final feed = FeedMessage.fromBuffer(response.bodyBytes);
          return feed.entity.where((entity) => entity.hasVehicle()).map((entity) {
            final vehicle = entity.vehicle;
            if (!vehicle.hasPosition()) return null;
            return {
              'id': vehicle.vehicle.id,
              'latitude': vehicle.position.latitude,
              'longitude': vehicle.position.longitude,
              'route': vehicle.trip.routeId,
              'timestamp': DateTime.fromMillisecondsSinceEpoch(
                (vehicle.timestamp).toInt() * 1000
              ).toIso8601String(),
              'speed': vehicle.position.speed,
              'bearing': vehicle.position.bearing,
            };
          }).whereType<Map<String, dynamic>>().toList();
          */
          throw UnimplementedError('Protobuf parsing requires gtfs_realtime.pb.dart');
        } catch (e) {
          developer.log('Error parsing protobuf: $e');
          throw Exception('Protobuf parsing failed');
        }
      } else {
        throw Exception('Failed to fetch bus positions: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error fetching bus positions: $e');
      // Fallback to mock data if API fails
      return [
        {
          'id': 'RapidKL-001',
          'latitude': 3.1390,
          'longitude': 101.6869,
          'route': 'T461',
          'timestamp': DateTime.now().toIso8601String(),
          'speed': 0.0,
          'bearing': 0.0,
        },
        {
          'id': 'RapidKL-002',
          'latitude': 3.1516,
          'longitude': 101.7155,
          'route': 'T462',
          'timestamp': DateTime.now().toIso8601String(),
          'speed': 0.0,
          'bearing': 45.0,
        },
      ];
    }
  }
}