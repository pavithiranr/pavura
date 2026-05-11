import 'package:flutter/material.dart';
import 'train/train_schedule_screen.dart';
import 'bus/bus_schedule_screen.dart';
import 'bus/bus_tracking_screen.dart';
import 'ride_hailing/ride_hailing_screen.dart';
import '../utils/station_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _startController = TextEditingController();
  final _destinationController = TextEditingController();
  List<StationInfo> filteredStartStations = [];
  List<StationInfo> filteredDestStations = [];
  bool showStartSuggestions = false;
  bool showDestSuggestions = false;

  Widget _buildSuggestionsList(final List<StationInfo> stations, final TextEditingController controller, final bool isStart) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: stations.length,
        itemBuilder: (final context, final index) {
          final station = stations[index];
          return ListTile(
            title: StationFormatter.buildStationWithLines(station),
            onTap: () {
              setState(() {
                controller.text = station.name;
                if (isStart) {
                  showStartSuggestions = false;
                } else {
                  showDestSuggestions = false;
                }
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transit App'),
        shadowColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 170, 23, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'Starting Location',
                      prefixIcon: Icon(Icons.location_on),
                      hintText: 'e.g., KL Sentral',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (final value) {
                      setState(() {
                        filteredStartStations = StationFormatter.getStationWithLines(value);
                        showStartSuggestions = value.isNotEmpty;
                      });
                    },
                  ),
                  if (showStartSuggestions)
                    _buildSuggestionsList(filteredStartStations, _startController, true),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'e.g., Masjid Jamek',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (final value) {
                      setState(() {
                        filteredDestStations = StationFormatter.getStationWithLines(value);
                        showDestSuggestions = value.isNotEmpty;
                      });
                    },
                  ),
                  if (showDestSuggestions)
                    _buildSuggestionsList(filteredDestStations, _destinationController, false),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainScheduleScreen(
                      initialStart: _startController.text,
                      initialDestination: _destinationController.text,
                    ),
                  ),
                ),
                icon: const Icon(Icons.train),
                label: const Text('Train Schedule & Location'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BusScheduleScreen(
                    start: _startController.text,
                    destination: _destinationController.text,
                  ),),
                ),
                icon: const Icon(Icons.directions_bus),
                label: const Text('Bus Schedule'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BusTrackingScreen(
                    start: 'Current Location',
                    destination: 'Nearby Buses',
                  ),),
                ),
                icon: const Icon(Icons.map),
                label: const Text('Live Bus Locations'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RideHailingScreen()),
                ),
                icon: const Icon(Icons.local_taxi),
                label: const Text('Ride Hailing Services'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}