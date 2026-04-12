import 'dart:async';
import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String bookingId;
  final String pickupLocation;
  final String dropoffLocation;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  bool _driverFound = false;
  int _remainingTime = 300; // 5 minutes in seconds
  Timer? _timer;
  final _driverDetails = {
    'name': 'John Doe',
    'car': 'Proton Saga',
    'plate': 'ABC 1234',
    'rating': '4.8',
    'arrivalTime': '3',
  };

  @override
  void initState() {
    super.initState();
    _findDriver();
  }

  void _findDriver() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _driverFound = true;
        });
        _startCountdown();
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_driverFound ? 'Driver Found!' : 'Finding Driver...'),
        backgroundColor: const Color(0xFF00B14F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (!_driverFound) ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B14F)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Finding the nearest driver...',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF00B14F),
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _driverDetails['name']!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_driverDetails['car']} • ${_driverDetails['plate']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(' ${_driverDetails['rating']}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_on, color: Color(0xFF00B14F)),
                        title: const Text('Pickup'),
                        subtitle: Text(widget.pickupLocation),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.flag, color: Color(0xFF00B14F)),
                        title: const Text('Dropoff'),
                        subtitle: Text(widget.dropoffLocation),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Driver arriving in ${_driverDetails['arrivalTime']} minutes',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: ${widget.bookingId}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}