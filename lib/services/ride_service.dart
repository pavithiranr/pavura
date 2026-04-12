class RideService {
  static Future<bool> bookRide({
    required String pickup,
    required String dropoff,
    required String rideType,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  static String calculatePrice(String pickup, String dropoff, String rideType) {
    // Simple price calculation based on ride type
    switch (rideType) {
      case 'JustGrab':
        return 'RM 15-20';
      case 'GrabCar':
        return 'RM 18-25';
      case 'GrabCar Premium':
        return 'RM 25-35';
      default:
        return 'RM 15-20';
    }
  }

  static String estimateTime(String rideType) {
    // Simple time estimation based on ride type
    switch (rideType) {
      case 'JustGrab':
        return '5 min';
      case 'GrabCar':
        return '3 min';
      case 'GrabCar Premium':
        return '7 min';
      default:
        return '5 min';
    }
  }
}