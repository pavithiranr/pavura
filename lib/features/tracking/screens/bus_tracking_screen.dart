import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/components/button.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int _selectedBusIndex = 0;

  final List<Map<String, dynamic>> buses = [
    {
      'id': 'BUS-001',
      'route': 'RT-15',
      'operator': 'PO Haryanto',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'status': 'On Time',
      'nextStop': 'Halim Terminal',
      'occupancy': 75,
      'speed': 45,
    },
    {
      'id': 'BUS-002',
      'route': 'RT-22',
      'operator': 'PO Efisiensi',
      'latitude': -6.1944,
      'longitude': 106.8296,
      'status': 'Delayed',
      'nextStop': 'Kota Station',
      'occupancy': 90,
      'speed': 25,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentBus = buses[_selectedBusIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Bus Tracking',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map area
            Container(
              color: AppTheme.white,
              height: 300,
              child: Stack(
                children: [
                  // Simulated map
                  Container(
                    color: AppTheme.bgLight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated pulse
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 120 + (_pulseController.value * 40),
                                height: 120 + (_pulseController.value * 40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primary.withValues(
                                      alpha: 1 - _pulseController.value,
                                    ),
                                    width: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              color: AppTheme.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Live Location',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioning controls
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        border: Border.all(color: AppTheme.grey300),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppTheme.primary,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: AppTheme.primary,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Bus info cards
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  final isSelected = _selectedBusIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedBusIndex = index),
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : AppTheme.white,
                        border: Border.all(
                          color:
                              isSelected ? AppTheme.primary : AppTheme.grey300,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bus['id'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? AppTheme.white : AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Route: ${bus['route']}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color:
                                  isSelected
                                      ? AppTheme.white.withValues(alpha: 0.8)
                                      : AppTheme.grey600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppTheme.white
                                      : AppTheme.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              bus['status'],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected
                                        ? AppTheme.success
                                        : AppTheme.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Detailed info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bus Details',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      border: Border.all(color: AppTheme.grey300),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(label: 'Bus ID', value: currentBus['id']),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Route', value: currentBus['route']),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Operator',
                          value: currentBus['operator'],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Next Stop',
                          value: currentBus['nextStop'],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Occupancy',
                          value: '${currentBus['occupancy']}%',
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Speed',
                          value: '${currentBus['speed']} km/h',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Status Information',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          currentBus['status'] == 'On Time'
                              ? AppTheme.success.withValues(alpha: 0.1)
                              : AppTheme.orange.withValues(alpha: 0.1),
                      border: Border.all(
                        color:
                            currentBus['status'] == 'On Time'
                                ? AppTheme.success
                                : AppTheme.orange,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          currentBus['status'] == 'On Time'
                              ? Icons.check_circle
                              : Icons.info,
                          color:
                              currentBus['status'] == 'On Time'
                                  ? AppTheme.success
                                  : AppTheme.orange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentBus['status'] == 'On Time'
                                    ? 'Bus is On Schedule'
                                    : 'Bus Running Late',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentBus['status'] == 'On Time'
                                    ? 'Expected to arrive at ${currentBus['nextStop']} on time'
                                    : 'Approximately 15 minutes delayed',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: 'Set Reminder',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.grey600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
      ],
    );
  }
}
