import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';

class GtfsService {
  static const String _baseUrl = 'https://api.data.gov.my/gtfs-static';

  Future<Map<String, dynamic>> fetchTransitData(final String location) async {
    final Map<String, String> endpoints = {
      'prasarana_rail': '$_baseUrl/prasarana?category=rapid-rail-kl',
      'prasarana_bus': '$_baseUrl/prasarana?category=rapid-bus-kl',
      'ktmb': '$_baseUrl/ktmb',
    };

    try {
      final url = endpoints[location] ?? endpoints['prasarana_rail']!;
      developer.log('Fetching GTFS data from: $url');
      
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timed out'),
      );

      if (response.statusCode == 200) {
        if (response.bodyBytes.isEmpty) {
          throw Exception('Empty response received');
        }
        final archive = ZipDecoder().decodeBytes(response.bodyBytes);
        return _parseGtfsFiles(archive);
      } else {
        throw Exception('Failed to fetch GTFS data: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in fetchTransitData: $e');
      throw Exception('Error fetching GTFS data: $e');
    }
  }

  Map<String, dynamic> _parseGtfsFiles(final Archive archive) {
    final Map<String, List<Map<String, dynamic>>> data = {};
    
    for (final file in archive) {
      if (file.isFile) {
        switch (file.name) {
          case 'stops.txt':
            data['stops'] = _parseFile(file);
            break;
          case 'routes.txt':
            data['routes'] = _parseFile(file);
            break;
          case 'trips.txt':
            data['trips'] = _parseFile(file);
            break;
          case 'stop_times.txt':
            data['stopTimes'] = _parseFile(file);
            break;
        }
      }
    }
    return data;
  }

  List<Map<String, dynamic>> _parseFile(final ArchiveFile file) {
    try {
      final content = utf8.decode(file.content);
      final lines = const LineSplitter().convert(content);
      if (lines.isEmpty) return [];
      
      final headers = lines.first.split(',')
          .map((final h) => h.trim())
          .toList();
      
      if (headers.isEmpty) return [];

      return lines.skip(1).map((final line) {
        final values = line.split(',')
            .map((final v) => v.trim())
            .toList();
        
        // Ensure values match headers length
        while (values.length < headers.length) {
          values.add('');
        }
        if (values.length > headers.length) {
          values.length = headers.length;
        }
        
        return Map<String, dynamic>.fromIterables(headers, values);
      }).toList();
    } catch (e) {
      developer.log('Error parsing file ${file.name}: $e');
      return [];
    }
  }
}