import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../services/gtfs_static_service.dart';
import '../../widgets/station_picker.dart';

class TrainScheduleScreen extends StatefulWidget {
  final String? initialStart;
  final String? initialDestination;
  final String? initialAgency;

  const TrainScheduleScreen({
    super.key,
    this.initialStart,
    this.initialDestination,
    this.initialAgency,
  });

  @override
  State<TrainScheduleScreen> createState() => _TrainScheduleScreenState();
}

class _TrainScheduleScreenState extends State<TrainScheduleScreen> {
  late GTFSStaticService _gtfsService;

  // Form state
  String _selectedAgency = 'ktmb';
  String _startStation = '';
  String _endStation = '';
  List<String> _availableStops = [];
  List<Map<String, dynamic>> _schedules = [];

  // UI state
  bool _isLoadingAgency = true;
  bool _isSearching = false;
  String? _error;

  static const Color grabGreen = Color(0xFF00B14F);

  static const List<String> agencies = [
    'ktmb',
    'prasarana-rapid-rail-kl',
    'prasarana-rapid-bus-kl',
  ];

  static const Map<String, String> agencyLabels = {
    'ktmb': '?? KTMB (Trains)',
    'prasarana-rapid-rail-kl': '?? Prasarana LRT (Rapid KL)',
    'prasarana-rapid-bus-kl': '?? Prasarana Bus (Rapid KL)',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialAgency != null) {
      _selectedAgency = widget.initialAgency!;
    }
    if (widget.initialStart != null) {
      _startStation = widget.initialStart!;
    }
    if (widget.initialDestination != null) {
      _endStation = widget.initialDestination!;
    }
    _gtfsService = GTFSStaticService();
    _loadAgencyData();
  }

  Future<void> _loadAgencyData() async {
    if (!mounted) return;
    setState(() {
      _isLoadingAgency = true;
      _error = null;
      _schedules = [];
    });

    try {
      final (agency, category) = _parseAgency(_selectedAgency);
      developer.log('Loading data for: $agency (category: $category)');

      await _gtfsService.initialize(agency: agency, category: category);

      final stops = _gtfsService.getAllStops();
      developer.log('Loaded ${stops.length} stops');

      if (mounted) {
        setState(() {
          _availableStops = stops;
          _isLoadingAgency = false;
        });
      }

      // Auto-search if both stations provided
      if (_startStation.isNotEmpty && _endStation.isNotEmpty) {
        _searchSchedules();
      }
    } catch (e) {
      developer.log('Error loading agency data: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load stations: $e';
          _isLoadingAgency = false;
        });
      }
    }
  }

  (String, String?) _parseAgency(String agencyStr) {
    if (agencyStr.startsWith('prasarana')) {
      final parts = agencyStr.split('-');
      final category = parts.length > 2 ? parts.sublist(1).join('-') : null;
      return ('prasarana', category);
    }
    return (agencyStr, null);
  }

  Future<void> _searchSchedules() async {
    if (_startStation.isEmpty || _endStation.isEmpty) {
      setState(() => _error = 'Please select both stations');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final schedules = await _gtfsService.getSchedules(
        startStopName: _startStation,
        endStopName: _endStation,
      );

      if (mounted) {
        setState(() {
          _schedules = schedules;
          _isSearching = false;
          if (schedules.isEmpty) {
            _error = 'No schedules found between these stations';
          }
        });
      }
    } catch (e) {
      developer.log('Error searching schedules: $e');
      if (mounted) {
        setState(() {
          _error = 'Search failed: $e';
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Search'),
        backgroundColor: grabGreen,
        elevation: 0,
      ),
      body:
          _isLoadingAgency
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(grabGreen),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Transit System',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: grabGreen),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedAgency,
                        isExpanded: true,
                        underline: const SizedBox(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items:
                            agencies
                                .map(
                                  (agency) => DropdownMenuItem(
                                    value: agency,
                                    child: Text(agencyLabels[agency] ?? agency),
                                  ),
                                )
                                .toList(),
                        onChanged: (newAgency) {
                          if (newAgency != null &&
                              newAgency != _selectedAgency) {
                            setState(() => _selectedAgency = newAgency);
                            _loadAgencyData();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'From:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StationPicker(
                      label: 'Departure Station',
                      availableStations: _availableStops,
                      initialValue: _startStation,
                      onStationSelected: (station) {
                        setState(() => _startStation = station);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'To:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StationPicker(
                      label: 'Destination Station',
                      availableStations: _availableStops,
                      initialValue: _endStation,
                      onStationSelected: (station) {
                        setState(() => _endStation = station);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSearching ? null : _searchSchedules,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: grabGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isSearching
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Search Schedules',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (_schedules.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Found ${_schedules.length} schedule(s)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._schedules.map((schedule) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: grabGreen.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            schedule['routeName'] ?? 'N/A',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: grabGreen,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: grabGreen,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          schedule['duration'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: grabGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Departure',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                schedule['departureTime'] ??
                                                    'N/A',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: grabGreen,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Arrival',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                schedule['arrivalTime'] ??
                                                    'N/A',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }
}
