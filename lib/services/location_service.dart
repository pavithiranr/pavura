import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as developer;
import 'permission_handler_service.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await PermissionHandlerService.requestLocationPermission();
    
    if (hasPermission) {
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
        
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        developer.log('Error getting location: $e');
        return null;
      }
    }
    return null;
  }

  static Future<double> getDistanceBetween(
    final double startLat,
    final double startLng,
    final double endLat,
    final double endLng,
  ) {
    return Future.value(
      Geolocator.distanceBetween(startLat, startLng, endLat, endLng),
    );
  }

  static Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return '${place.street}, ${place.locality}';
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}