import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';

class GTFSStaticService {
  static const String baseUrl = 'https://api.data.gov.my/gtfs-static';
  
  late Map<String, Map<String, dynamic>> _stops;
  late Map<String, Map<String, dynamic>> _routes;
  late Map<String, List<Map<String, dynamic>>> _stopTimes;
  late Map<String, Map<String, dynamic>> _trips;
  late List<Map<String, dynamic>> _calendar;
  
  bool _isInitialized = false;

  /// Initialize GTFS data for a specific agency
  /// agency: 'ktmb', 'prasarana', etc.
  /// category: for prasarana, use 'rapid-rail-kl', 'rapid-bus-kl', etc.
  Future<void> initialize({
    required String agency,
    String? category,
  }) async {
    try {
      developer.log('Initializing GTFS data for agency: $agency');
      
      final zipUrl = category != null
          ? '$baseUrl/$agency?category=$category'
          : '$baseUrl/$agency';

      final response = await http.get(Uri.parse(zipUrl)).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('GTFS download timeout'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to download GTFS data: ${response.statusCode}');
      }

      // Decode the ZIP file
      final archive = ZipDecoder().decodeBytes(response.bodyBytes);
      
      _stops = {};
      _routes = {};
      _stopTimes = {};
      _trips = {};
      _calendar = [];

      // Parse GTFS files
      for (final file in archive) {
        if (file.isFile) {
          final content = utf8.decode(file.content);
          
          switch (file.name) {
            case 'stops.txt':
              _parseStops(content);
              break;
            case 'routes.txt':
              _parseRoutes(content);
              break;
            case 'trips.txt':
              _parseTrips(content);
              break;
            case 'stop_times.txt':
              _parseStopTimes(content);
              break;
            case 'calendar.txt':
              _parseCalendar(content);
              break;
          }
        }
      }

      _isInitialized = true;
      developer.log('GTFS data loaded successfully');
      developer.log('Stops: ${_stops.length}, Routes: ${_routes.length}, Trips: ${_trips.length}');
    } catch (e) {
      developer.log('Error initializing GTFS: $e');
      rethrow;
    }
  }

  void _parseStops(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return;

    final headers = _parseCSVLine(lines[0]);
    
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCSVLine(lines[i]);
      if (values.isEmpty) continue;

      final stop = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        stop[headers[j]] = values[j];
      }
      
      final stopId = stop['stop_id'] as String?;
      if (stopId != null) {
        _stops[stopId] = stop;
      }
    }
    developer.log('Parsed ${_stops.length} stops');
  }

  void _parseRoutes(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return;

    final headers = _parseCSVLine(lines[0]);
    
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCSVLine(lines[i]);
      if (values.isEmpty) continue;

      final route = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        route[headers[j]] = values[j];
      }
      
      final routeId = route['route_id'] as String?;
      if (routeId != null) {
        _routes[routeId] = route;
      }
    }
    developer.log('Parsed ${_routes.length} routes');
  }

  void _parseTrips(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return;

    final headers = _parseCSVLine(lines[0]);
    
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCSVLine(lines[i]);
      if (values.isEmpty) continue;

      final trip = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        trip[headers[j]] = values[j];
      }
      
      final tripId = trip['trip_id'] as String?;
      if (tripId != null) {
        _trips[tripId] = trip;
      }
    }
    developer.log('Parsed ${_trips.length} trips');
  }

  void _parseStopTimes(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return;

    final headers = _parseCSVLine(lines[0]);
    
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCSVLine(lines[i]);
      if (values.isEmpty) continue;

      final stopTime = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        stopTime[headers[j]] = values[j];
      }
      
      final stopId = stopTime['stop_id'] as String?;
      if (stopId != null) {
        _stopTimes.putIfAbsent(stopId, () => []);
        _stopTimes[stopId]!.add(stopTime);
      }
    }
    developer.log('Parsed ${_stopTimes.length} stop groups');
  }

  void _parseCalendar(String content) {
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return;

    final headers = _parseCSVLine(lines[0]);
    
    for (int i = 1; i < lines.length; i++) {
      final values = _parseCSVLine(lines[i]);
      if (values.isEmpty) continue;

      final cal = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        cal[headers[j]] = values[j];
      }
      
      _calendar.add(cal);
    }
    developer.log('Parsed ${_calendar.length} calendar entries');
  }

  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        insideQuotes = !insideQuotes;
      } else if (char == ',' && !insideQuotes) {
        result.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    
    result.add(current.toString().trim());
    return result;
  }

  /// Get schedules between two stops
  Future<List<Map<String, dynamic>>> getSchedules({
    required String startStopName,
    required String endStopName,
  }) async {
    if (!_isInitialized) {
      throw Exception('GTFS data not initialized. Call initialize() first.');
    }

    try {
      // Find stop IDs by name
      final startStopId = _findStopIdByName(startStopName);
      final endStopId = _findStopIdByName(endStopName);

      if (startStopId == null || endStopId == null) {
        developer.log('Could not find stops: $startStopName, $endStopName');
        return [];
      }

      final schedules = <Map<String, dynamic>>[];

      // Get stop times for start station
      final startStopTimes = _stopTimes[startStopId] ?? [];

      for (final stopTime in startStopTimes) {
        final departureTime = stopTime['departure_time'] as String?;
        if (departureTime == null) continue;

        final tripId = stopTime['trip_id'] as String?;
        if (tripId == null) continue;

        // Find the end stop in the same trip
        final endStopTimesInTrip = _stopTimes[endStopId]
            ?.where((st) => st['trip_id'] == tripId)
            .toList() ??
            [];

        if (endStopTimesInTrip.isEmpty) continue;

        final endStopTime = endStopTimesInTrip.first;
        final arrivalTime = endStopTime['arrival_time'] as String?;

        final trip = _trips[tripId];
        final routeId = trip?['route_id'] as String?;
        final route = routeId != null ? _routes[routeId] : null;

        final schedule = {
          'tripId': tripId,
          'routeName': route?['route_short_name'] ?? route?['route_long_name'] ?? 'Unknown',
          'routeId': routeId,
          'departureTime': departureTime,
          'arrivalTime': arrivalTime,
          'startStation': startStopName,
          'endStation': endStopName,
          'duration': _calculateDuration(departureTime, arrivalTime),
          'serviceId': trip?['service_id'],
        };

        schedules.add(schedule);
      }

      // Sort by departure time and limit to next 10 services
      schedules.sort((a, b) =>
          (a['departureTime'] as String).compareTo(b['departureTime'] as String));

      return schedules.take(10).toList();
    } catch (e) {
      developer.log('Error getting schedules: $e');
      rethrow;
    }
  }

  String? _findStopIdByName(String stopName) {
    // Try exact match first
    for (final entry in _stops.entries) {
      final stopNameField = entry.value['stop_name'] as String?;
      if (stopNameField?.toLowerCase() == stopName.toLowerCase()) {
        return entry.key;
      }
    }

    // Try partial match
    for (final entry in _stops.entries) {
      final stopNameField = entry.value['stop_name'] as String?;
      if (stopNameField?.toLowerCase().contains(stopName.toLowerCase()) ?? false) {
        return entry.key;
      }
    }

    return null;
  }

  String _calculateDuration(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return 'N/A';
    try {
      final startParts = startTime.split(':').map(int.parse).toList();
      final endParts = endTime.split(':').map(int.parse).toList();

      final startMinutes = (startParts[0] * 60) + startParts[1];
      final endMinutes = (endParts[0] * 60) + endParts[1];

      var diff = endMinutes - startMinutes;
      if (diff < 0) diff += 24 * 60; // Handle next day

      final hours = diff ~/ 60;
      final minutes = diff % 60;

      if (hours > 0) {
        return '$hours h $minutes m';
      } else {
        return '$minutes min';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  /// Get list of all available stops
  List<String> getAllStops() {
    return _stops.values
        .map((stop) => stop['stop_name'] as String? ?? 'Unknown')
        .toList();
  }
}
