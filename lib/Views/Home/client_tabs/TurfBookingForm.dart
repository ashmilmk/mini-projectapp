import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PaymentScreen.dart'; // Import the PaymentScreen

class TurfBookingForm extends StatefulWidget {
  const TurfBookingForm({super.key});

  @override
  _TurfBookingFormState createState() => _TurfBookingFormState();
}

class _TurfBookingFormState extends State<TurfBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  int? _selectedDuration;
  String? _contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Turf'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate?.toString() ?? 'Select Date'),
              ),
              TextButton.icon(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _selectedStartTime = selectedTime;
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text(
                    _selectedStartTime?.format(context) ?? 'Select Start Time'),
              ),
              DropdownButtonFormField<int>(
                value: _selectedDuration,
                hint: const Text('Select Duration'),
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('1 Hour'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('2 Hours'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('3 Hours'),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact',
                ),
                onChanged: (value) {
                  _contact = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Navigate to the PaymentScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          bookingData: {
                            'date': _selectedDate?.toIso8601String(),
                            'startTime': _selectedStartTime?.format(context),
                            'duration': _selectedDuration,
                            'contact': _contact,
                          },
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
