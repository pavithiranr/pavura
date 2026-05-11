// API Endpoints
class ApiConstants {
  static const String baseUrl = 'https://api.data.gov.my';
  static const String gtfsStaticKtmb = '$baseUrl/gtfs-static/';
  static const String gtfsRealtimeKtmb = '$baseUrl/gtfs-realtime/vehicle-position/ktmb';
  static const String gtfsRealtimePrasarana = '$baseUrl/gtfs-realtime/vehicle-position/prasarana';
}

// App strings
class AppStrings {
  // Navigation
  static const String appName = 'Pavura';
  static const String home = 'Home';
  static const String search = 'Search';
  static const String tracking = 'Tracking';
  static const String rides = 'Rides';
  static const String profile = 'Profile';

  // Auth
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String rememberMe = 'Remember me';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';

  // Transport
  static const String trains = 'Trains';
  static const String buses = 'Buses';
  static const String from = 'From';
  static const String to = 'To';
  static const String date = 'Date';
  static const String selectStation = 'Select Station';
  static const String searchRoutes = 'Search Routes';
  static const String noResultsFound = 'No results found';

  // Ride-hailing
  static const String bookRide = 'Book Ride';
  static const String estimatedPrice = 'Estimated Price';
  static const String selectRideType = 'Select Ride Type';
  static const String confirmBooking = 'Confirm Booking';

  // General
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String more = 'More';
}

// Duration constants
class AppDurations {
  static const Duration shortest = Duration(milliseconds: 200);
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration longest = Duration(seconds: 1);
}

// Transport agencies
class TransportAgencies {
  static const String ktmb = 'KTMB';
  static const String prasaranaLrt = 'Prasarana LRT';
  static const String prasaranaBus = 'Prasarana Bus';
  
  static const Map<String, String> all = {
    'ktmb': '🚆 KTMB (Trains)',
    'prasarana-rapid-rail-kl': '🚇 Prasarana LRT',
    'prasarana-rapid-bus-kl': '🚌 Prasarana Bus',
  };
}

// Ride types
class RideTypes {
  static const String economy = 'Economy';
  static const String comfort = 'Comfort';
  static const String premium = 'Premium';
  static const String shared = 'Shared';
}
