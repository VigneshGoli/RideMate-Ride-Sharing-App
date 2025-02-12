import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rideshare/widgets/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stops = <String>[];
  String _newStop = '';
  bool _isLoading = false;
  String? _error;

  // Form fields
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleRegistrationController = TextEditingController();
  final _seatsController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _vehicleModelController.dispose();
    _vehicleRegistrationController.dispose();
    _seatsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      _dateController.text = date.toIso8601String().split('T')[0];
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      _timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _addStop() {
    if (_newStop.trim().isNotEmpty && !_stops.contains(_newStop.trim())) {
      setState(() {
        _stops.add(_newStop.trim());
        _newStop = '';
      });
    }
  }

  void _removeStop(int index) {
    setState(() {
      _stops.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final supabase = Supabase.instance.client;
      
      await supabase.from('rides').insert({
        'origin': _originController.text,
        'destination': _destinationController.text,
        'date': _dateController.text,
        'departure_time': _timeController.text,
        'vehicle_model': _vehicleModelController.text,
        'vehicle_registration': _vehicleRegistrationController.text,
        'available_seats': int.parse(_seatsController.text),
        'price_per_seat': double.parse(_priceController.text),
        'stops': _stops,
        'status': 'active',
      });

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride posted successfully!')),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer a Ride'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),

                TextFormField(
                  controller: _originController,
                  decoration: const InputDecoration(
                    labelText: 'From',
                    prefixIcon: Icon(LucideIcons.mapPin),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter origin' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'To',
                    prefixIcon: Icon(LucideIcons.mapPin),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter destination' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(LucideIcons.calendar),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Please select date' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: _selectTime,
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          prefixIcon: Icon(LucideIcons.clock),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Please select time' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stops section
                const Text(
                  'Stops',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => _newStop = value,
                        onSubmitted: (_) => _addStop(),
                        decoration: const InputDecoration(
                          hintText: 'Add a stop',
                          prefixIcon: Icon(LucideIcons.mapPin),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addStop,
                      icon: const Icon(LucideIcons.plus),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (_stops.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _stops.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        onDeleted: () => _removeStop(entry.key),
                        backgroundColor: Colors.indigo.shade50,
                        labelStyle: const TextStyle(color: Colors.indigo),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),

                TextFormField(
                  controller: _vehicleModelController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Model',
                    prefixIcon: Icon(LucideIcons.car),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter vehicle model' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _vehicleRegistrationController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Registration',
                    prefixIcon: Icon(LucideIcons.fileText),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter registration number' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _seatsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Available Seats',
                          prefixIcon: Icon(LucideIcons.users),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter seats';
                          }
                          final seats = int.tryParse(value!);
                          if (seats == null || seats < 1) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price per Seat',
                          prefixIcon: Icon(LucideIcons.dollarSign),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter price';
                          }
                          final price = double.tryParse(value!);
                          if (price == null || price < 0) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: Text(_isLoading ? 'Posting...' : 'Post Ride'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}