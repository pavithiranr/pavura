import 'package:flutter/material.dart';
// import '../generated/passenger.pb.dart'; // TODO: Re-enable when passenger.proto is implemented
import '../services/passenger_service.dart';

class PassengerForm extends StatefulWidget {
  final Function(dynamic) onPassengerTracked;

  const PassengerForm({super.key, required this.onPassengerTracked});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _service = PassengerTrackingService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Passenger tracking is coming soon!\nThis feature requires proto implementation.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            enabled: false,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            enabled: false,
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Current Location'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            enabled: false,
          ),
          TextFormField(
            controller: _destinationController,
            decoration: const InputDecoration(labelText: 'Destination'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            enabled: false,
          ),
          ElevatedButton(
            onPressed: null,
            child: const Text('Track Passenger (Coming Soon)'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _destinationController.dispose();
    _service.dispose();
    super.dispose();
  }
}