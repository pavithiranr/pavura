import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/components/button.dart';

class TrainTrackingScreen extends StatefulWidget {
  const TrainTrackingScreen({super.key});

  @override
  State<TrainTrackingScreen> createState() => _TrainTrackingScreenState();
}

class _TrainTrackingScreenState extends State<TrainTrackingScreen> {
  int _selectedTrainIndex = 0;

  final List<Map<String, dynamic>> trains = [
    {
      'id': 'KA-150',
      'name': 'Argo Parahyangan',
      'line': 'Jakarta - Bandung',
      'status': 'On Time',
      'currentStation': 'Depok',
      'nextStation': 'Bogor',
      'departure': '08:30',
      'arrival': '10:00',
      'progress': 0.45,
      'capacity': '320',
      'occupancy': '85%',
    },
    {
      'id': 'KA-200',
      'name': 'Jabodetabek Line',
      'line': 'Jakarta - Tangerang',
      'status': 'Delayed',
      'currentStation': 'Sudirman',
      'nextStation': 'Blok M',
      'departure': '09:15',
      'arrival': '09:45',
      'progress': 0.25,
      'capacity': '800',
      'occupancy': '92%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentTrain = trains[_selectedTrainIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Train Tracking',
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
            // Route visualization
            Container(
              color: AppTheme.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTrain['line'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.grey600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Visual route
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.grey600,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:
                                            (currentTrain['progress'] * 100)
                                                .toInt(),
                                        child: Container(
                                          height: 3,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            (100 -
                                                    (currentTrain['progress'] *
                                                        100))
                                                .toInt(),
                                        child: Container(
                                          height: 3,
                                          color: AppTheme.grey300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${(currentTrain['progress'] * 100).toStringAsFixed(0)}% complete',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.grey300,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppTheme.grey600,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'End',
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
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppTheme.primary),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          'Current: ${currentTrain['currentStation']} → Next: ${currentTrain['nextStation']}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Train selector
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trains.length,
                itemBuilder: (context, index) {
                  final train = trains[index];
                  final isSelected = _selectedTrainIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTrainIndex = index),
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
                            train['id'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? AppTheme.white : AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            train['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? AppTheme.white
                                      : AppTheme.grey600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppTheme.white
                                      : train['status'] == 'On Time'
                                      ? AppTheme.success.withValues(alpha: 0.1)
                                      : AppTheme.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              train['status'],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected
                                        ? AppTheme.primary
                                        : train['status'] == 'On Time'
                                        ? AppTheme.success
                                        : AppTheme.orange,
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
            // Train details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Train Information',
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
                        _DetailRow(
                          label: 'Train ID',
                          value: currentTrain['id'],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Name', value: currentTrain['name']),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Capacity',
                          value: currentTrain['capacity'],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Occupancy',
                          value: currentTrain['occupancy'],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Status',
                          value: currentTrain['status'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Schedule',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Departure',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.grey600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentTrain['departure'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 80,
                          height: 1,
                          color: AppTheme.grey300,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Arrival',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.grey600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentTrain['arrival'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(label: 'Get Ticket', onPressed: () {}),
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
