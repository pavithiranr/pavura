import 'package:flutter/material.dart';

class StationPicker extends StatefulWidget {
  final String label;
  final Function(String) onStationSelected;
  final List<String> availableStations;
  final String? initialValue;

  const StationPicker({
    super.key,
    required this.label,
    required this.onStationSelected,
    required this.availableStations,
    this.initialValue,
  });

  @override
  State<StationPicker> createState() => _StationPickerState();
}

class _StationPickerState extends State<StationPicker> {
  late TextEditingController _controller;
  List<String> _filteredStations = [];
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _filteredStations = widget.availableStations;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = widget.availableStations;
      } else {
        _filteredStations = widget.availableStations
            .where((station) =>
                station.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _showDropdown = true;
    });
  }

  void _selectStation(String station) {
    _controller.text = station;
    widget.onStationSelected(station);
    setState(() => _showDropdown = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: _filterStations,
          onTap: () {
            setState(() => _showDropdown = true);
            if (_controller.text.isEmpty) {
              _filterStations('');
            }
          },
          decoration: InputDecoration(
            hintText: widget.label,
            prefixIcon: const Icon(Icons.location_on, color: Color(0xFF00B14F)),
            suffixIcon:
                _controller.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _filteredStations = widget.availableStations;
                          _showDropdown = false;
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00B14F)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00B14F), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (_showDropdown && _filteredStations.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: const Border(
                left: BorderSide(color: Color(0xFF00B14F)),
                right: BorderSide(color: Color(0xFF00B14F)),
                bottom: BorderSide(color: Color(0xFF00B14F)),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: ListView.builder(
              itemCount: _filteredStations.length,
              itemBuilder: (context, index) {
                final station = _filteredStations[index];
                return ListTile(
                  title: Text(station),
                  onTap: () => _selectStation(station),
                  selected: _controller.text == station,
                  selectedTileColor: const Color(0xFF00B14F).withValues(alpha: 0.1),
                  leading: const Icon(Icons.train, color: Color(0xFF00B14F), size: 18),
                );
              },
            ),
          ),
      ],
    );
  }
}
