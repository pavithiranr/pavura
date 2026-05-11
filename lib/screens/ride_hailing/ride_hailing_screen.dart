import 'package:flutter/material.dart';
import '../../services/ride_service.dart';
import 'booking_confirmation_screen.dart';
import 'location_search_screen.dart';

class RideHailingScreen extends StatefulWidget {
  final String? destination;
  
  const RideHailingScreen({super.key, this.destination});

  @override
  State<RideHailingScreen> createState() => _RideHailingScreenState();
}

class _RideHailingScreenState extends State<RideHailingScreen> {
  String _pickupLocation = '';
  String _dropoffLocation = '';
  String _selectedRideType = 'JustGrab';
  final List<Map<String, dynamic>> _rideTypes = [
    {
      'name': 'JustGrab',
      'price': 'RM 15-20',
      'time': '5 min',
      'icon': Icons.local_taxi,
    },
    {
      'name': 'GrabCar',
      'price': 'RM 18-25',
      'time': '3 min',
      'icon': Icons.directions_car,
    },
    {
      'name': 'GrabCar Premium',
      'price': 'RM 25-35',
      'time': '7 min',
      'icon': Icons.airline_seat_individual_suite,
    },
  ];

  static const Color grabGreen = Color(0xFF00B14F);

  @override
  void initState() {
    super.initState();
    _dropoffLocation = widget.destination ?? '';
  }

  Widget _buildLocationField(String label, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        label == 'Pickup' ? Icons.my_location : Icons.location_on,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value.isEmpty ? 'Select $label Location' : value,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      onTap: onTap,
    );
  }

  Widget _buildRideTypeCard(Map<String, dynamic> rideType) {
    final isSelected = _selectedRideType == rideType['name'];
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.white,
      child: InkWell(
        onTap: () => setState(() => _selectedRideType = rideType['name']),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(rideType['icon'], size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rideType['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${rideType['time']} away',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                rideType['price'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      appBar: AppBar(
        title: const Text(
          'Grab',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: grabGreen,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [                _buildLocationField('Pickup', _pickupLocation, () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationSearchScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() => _pickupLocation = result);
                  }
                }),
                const Divider(height: 1),
                _buildLocationField('Dropoff', _dropoffLocation, () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationSearchScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() => _dropoffLocation = result);
                  }
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rideTypes.length,
              itemBuilder: (context, index) => _buildRideTypeCard(_rideTypes[index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _pickupLocation.isNotEmpty && _dropoffLocation.isNotEmpty
                    ? () async {
                        final context = this.context;
                        final success = await RideService.bookRide(
                          pickup: _pickupLocation,
                          dropoff: _dropoffLocation,
                          rideType: _selectedRideType,
                        );
                        if (mounted && success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmationScreen(
                                bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
                                pickupLocation: _pickupLocation,
                                dropoffLocation: _dropoffLocation,
                              ),
                            ),
                          );
                        }
                      }
                    : null,                style: ElevatedButton.styleFrom(
                  backgroundColor: grabGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}