import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/components/button.dart';

class VehiclePositionsScreen extends StatefulWidget {
  const VehiclePositionsScreen({super.key});

  @override
  State<VehiclePositionsScreen> createState() => _VehiclePositionsScreenState();
}

class _VehiclePositionsScreenState extends State<VehiclePositionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _mapAnimController;
  String _selectedVehicleType = 'all';
  bool _showFilters = false;
  int _selectedVehicleIndex = -1;

  final List<Map<String, dynamic>> vehicles = [
    {
      'id': 'BUS-001',
      'type': 'bus',
      'name': 'City Bus RT-15',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'speed': 45,
      'bearing': 90,
      'occupancy': 75,
      'route': 'Halim → Cicayur',
      'lastUpdate': '2 min ago',
    },
    {
      'id': 'TRN-001',
      'type': 'train',
      'name': 'Argo Parahyangan',
      'latitude': -6.1944,
      'longitude': 106.8296,
      'speed': 85,
      'bearing': 180,
      'occupancy': 85,
      'route': 'Jakarta → Bandung',
      'lastUpdate': '1 min ago',
    },
    {
      'id': 'BUS-002',
      'type': 'bus',
      'name': 'City Bus RT-22',
      'latitude': -6.2144,
      'longitude': 106.8544,
      'speed': 30,
      'bearing': 45,
      'occupancy': 90,
      'route': 'Kota → Cikarang',
      'lastUpdate': '3 min ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mapAnimController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mapAnimController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredVehicles {
    if (_selectedVehicleType == 'all') {
      return vehicles;
    }
    return vehicles.where((v) => v['type'] == _selectedVehicleType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Vehicle Positions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.primary),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map view
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
                          const Icon(
                            Icons.map,
                            size: 80,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Live Vehicle Map',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${filteredVehicles.length} vehicles active',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Map controls
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _MapControlButton(icon: Icons.add, onPressed: () {}),
                        const SizedBox(height: 8),
                        _MapControlButton(icon: Icons.remove, onPressed: () {}),
                        const SizedBox(height: 8),
                        _MapControlButton(
                          icon: Icons.my_location,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Filters (if shown)
            if (_showFilters)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by Type',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected: _selectedVehicleType == 'all',
                          onTap:
                              () =>
                                  setState(() => _selectedVehicleType = 'all'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Buses',
                          isSelected: _selectedVehicleType == 'bus',
                          onTap:
                              () =>
                                  setState(() => _selectedVehicleType = 'bus'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Trains',
                          isSelected: _selectedVehicleType == 'train',
                          onTap:
                              () => setState(
                                () => _selectedVehicleType = 'train',
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            // Vehicles list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Vehicles',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = filteredVehicles[index];
                      final isSelected = _selectedVehicleIndex == index;
                      return GestureDetector(
                        onTap:
                            () => setState(() => _selectedVehicleIndex = index),
                        child: _VehicleCard(
                          vehicle: vehicle,
                          isSelected: isSelected,
                        ),
                      );
                    },
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

class _VehicleCard extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final bool isSelected;

  const _VehicleCard({required this.vehicle, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppTheme.primary.withValues(alpha: 0.1)
                : AppTheme.white,
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.grey300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          vehicle['type'] == 'bus'
                              ? const Color(0x1AFF9500)
                              : const Color(0x1A007AFF),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      vehicle['type'] == 'bus'
                          ? Icons.directions_bus
                          : Icons.train,
                      color:
                          vehicle['type'] == 'bus'
                              ? const Color(0xFFFF9500)
                              : const Color(0xFF007AFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['id'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vehicle['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
              ),
            ],
          ),
          if (isSelected) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailItem(label: 'Speed', value: '${vehicle['speed']} km/h'),
                _DetailItem(
                  label: 'Occupancy',
                  value: '${vehicle['occupancy']}%',
                ),
                _DetailItem(label: 'Updated', value: vehicle['lastUpdate']),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Route: ${vehicle['route']}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.grey600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'View Details',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(label: 'Get Ticket', onPressed: () {}),
                ),
              ],
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 12),
                Text(
                  vehicle['route'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.grey600,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.speed, size: 14, color: AppTheme.grey600),
                    const SizedBox(width: 4),
                    Text(
                      '${vehicle['speed']} km/h',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppTheme.grey600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.grey100,
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.grey300,
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.white : AppTheme.black,
          ),
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(color: AppTheme.grey300),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 18),
      ),
    );
  }
}
