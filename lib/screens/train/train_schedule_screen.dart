import 'package:flutter/material.dart';
import '../../services/gtfs_static_service.dart';

class TrainScheduleScreen extends StatefulWidget {
  final String start;
  final String destination;

  const TrainScheduleScreen({
    super.key,
    required this.start,
    required this.destination,
  });

  @override
  State<TrainScheduleScreen> createState() => _TrainScheduleScreenState();
}

class _TrainScheduleScreenState extends State<TrainScheduleScreen> {
  List<Map<String, dynamic>> _schedules = [];
  bool _isLoading = true;
  String? _error;
  static const Color grabGreen = Color(0xFF00B14F);
  late GTFSStaticService _gtfsService;

  @override
  void initState() {
    super.initState();
    _gtfsService = GTFSStaticService();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Initialize GTFS data for KTMB (trains)
      await _gtfsService.initialize(agency: 'ktmb');

      // Get schedules between the two stations
      final schedules = await _gtfsService.getSchedules(
        startStopName: widget.start,
        endStopName: widget.destination,
      );

      if (mounted) {
        setState(() {
          _schedules = schedules;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Trains'),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(grabGreen),
              ),
            )
          : _error != null
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _loadSchedules,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _schedules.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No schedules found for these stations'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadSchedules,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadSchedules,
                      color: grabGreen,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [grabGreen, grabGreen.withValues(alpha: 0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From: ${widget.start}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'To: ${widget.destination}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.white),
                                  onPressed: _loadSchedules,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _schedules.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final schedule = _schedules[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: grabGreen,
                                      child: Text(
                                        schedule['routeName'] != null
                                            ? (schedule['routeName'] as String)
                                                .substring(
                                                    0,
                                                    1.clamp(0, 2))
                                            : 'T',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time,
                                                size: 16, color: grabGreen),
                                            const SizedBox(width: 8),
                                            Text(
                                              schedule['departureTime'] ?? 'N/A',
                                              style: const TextStyle(
                                                color: grabGreen,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Route: ${schedule['routeName'] ?? 'Unknown'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(Icons.flag,
                                            size: 16, color: grabGreen),
                                        const SizedBox(width: 8),
                                        Text(
                                          schedule['arrivalTime'] ?? 'N/A',
                                          style: const TextStyle(
                                            color: grabGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: grabGreen.withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        schedule['duration'] ?? 'N/A',
                                        style: const TextStyle(
                                          color: grabGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
