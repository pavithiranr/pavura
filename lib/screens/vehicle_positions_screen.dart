import 'package:flutter/material.dart';
import '../services/gtfs_realtime_service.dart';
import '../protos/gtfs_realtime.pb.dart';

class VehiclePositionsScreen extends StatefulWidget {
  const VehiclePositionsScreen({super.key});

  @override
  _VehiclePositionsScreenState createState() => _VehiclePositionsScreenState();
}

class _VehiclePositionsScreenState extends State<VehiclePositionsScreen> {
  final GtfsRealtimeService _service = GtfsRealtimeService();
  List<FeedEntity> _vehiclePositions = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchVehiclePositions();
  }

  Future<void> _fetchVehiclePositions() async {
    try {
      final positions = await _service.fetchVehiclePositions();
      setState(() {
        _vehiclePositions = positions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Positions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 10),
                      Text('Error: $_error',
                          style: const TextStyle(fontSize: 16, color: Colors.red),),
                    ],
                  ),
                )
              : _vehiclePositions.isEmpty
                  ? const Center(
                      child: Text(
                        'No vehicle data available',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _vehiclePositions.length,
                      itemBuilder: (final context, final index) {
                        final entity = _vehiclePositions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: const Icon(Icons.directions_transit, color: Colors.blue),
                            title: Text('Vehicle ID: ${entity.vehicle.vehicle.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(
                                'Lat: ${entity.vehicle.position.latitude}, Lng: ${entity.vehicle.position.longitude}',),
                          ),
                        );
                      },
                    ),
    );
  }
}