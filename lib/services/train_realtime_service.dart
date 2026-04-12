import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../protos/gtfs_realtime.pb.dart';

class TrainRealtimeService {
  final String baseUrl = 'https://api.data.gov.my/gtfs-realtime/vehicle-position/ktmb';

  Future<List<FeedEntity>> fetchTrainPositions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      developer.log('Response status: ${response.statusCode}');
      
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
        developer.log('Failed to fetch train positions: ${response.statusCode}');
        throw Exception('Failed to load train positions');
      }
    } catch (e) {
      developer.log('Error fetching train positions: $e');
      throw Exception('Error fetching train positions: $e');
    }
  }
}