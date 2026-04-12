import 'dart:developer' as developer;
import 'prasarana_api_service.dart';

class BusTrackingService {
  final PrasaranaApiService _api = PrasaranaApiService();

  Future<List<Map<String, dynamic>>> fetchBusPositions() async {
    try {
      return await _api.fetchBusPositions();
    } catch (e) {
      developer.log('Error fetching bus positions: $e');
      // Fallback to mock data if API fails
      return [
        {
          'id': 'B1001',
          'latitude': 3.1390,
          'longitude': 101.6869,
          'route': 'T461',
          'destination': 'KL Sentral',
        },
        {
          'id': 'B1002',
          'latitude': 3.1516,
          'longitude': 101.7155,
          'route': 'T462',
          'destination': 'Titiwangsa',
        },
        {
          'id': 'B1003',
          'latitude': 3.1207,
          'longitude': 101.6748,
          'route': 'T463',
          'destination': 'Mid Valley',
        },
      ];
    }
  }

  Future<List<Map<String, dynamic>>> getBusSchedule(String route) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulated API delay
      return [
        {
          'departure': '08:00',
          'arrival': '08:45',
          'route': route,
          'status': 'On Time',
        },
        {
          'departure': '08:30',
          'arrival': '09:15',
          'route': route,
          'status': 'Delayed',
        },
      ];
    } catch (e) {
      developer.log('Error fetching bus schedule: $e');
      return [];
    }
  }
}