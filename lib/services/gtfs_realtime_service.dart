import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../protos/gtfs_realtime.pb.dart';

class GtfsRealtimeService {
  final String apiUrl = 'https://api.data.gov.my/gtfs-realtime/vehicle-position/prasarana?category=rapid-rail-kl';

  Future<List<FeedEntity>> fetchVehiclePositions() async {
    try {
      developer.log('Fetching vehicle positions from: $apiUrl');
      final response = await http.get(Uri.parse(apiUrl));
      developer.log('Response status: ${response.statusCode}');
      developer.log('Response size: ${response.bodyBytes.length} bytes');
      
      if (response.statusCode == 200) {
        try {
          final feed = FeedMessage.fromBuffer(response.bodyBytes);
          developer.log('Successfully parsed feed with ${feed.entity.length} entities');
          if (feed.entity.isEmpty) {
            developer.log('Warning: Feed contains no entities');
          }
          return feed.entity;
        } catch (e) {
          developer.log('Error parsing protobuf data: $e');
          developer.log('First 100 bytes of response: ${response.bodyBytes.take(100)}');
          throw Exception('Error parsing protobuf data: $e');
        }
      } else {
        developer.log('Failed to fetch vehicle positions: ${response.statusCode}');
        developer.log('Response body: ${response.body}');
        throw Exception('Failed to fetch vehicle positions: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error fetching vehicle positions: $e');
      throw Exception('Error fetching vehicle positions: $e');
    }
  }
}