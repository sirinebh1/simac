import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class FormationScreen extends StatefulWidget {
  final String title;

  const FormationScreen({Key? key, required this.title}) : super(key: key);

  @override
  _FormationScreenState createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomDeFormationController = TextEditingController();
  final _animerParController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nomDeFormationController.dispose();
    _animerParController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTraining() async {
    if (_formKey.currentState!.validate()) {
      final String nomDeFormation = _nomDeFormationController.text;
      final String animerPar = _animerParController.text;
      final String location = _locationController.text;
      final String date = _selectedDate != null ? _selectedDate!.toIso8601String().split('T').first : '';
      final String time = _selectedTime != null ? _selectedTime!.format(context) : '';
      final DateFormat timeFormat = DateFormat.Hms();
      final DateTime parsedTime = DateFormat.jm().parse(time);
      final String formattedTime = timeFormat.format(parsedTime);

      final Map<String, dynamic> trainingData = {
        'nomDeFormation': nomDeFormation,
        'animerPar': animerPar,
        'location': location,
        'date': date,
        'time': formattedTime,
      };

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8084/api/formation/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(trainingData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Training saved successfully');
          Navigator.pop(context);
        } else {
          print('Failed to save training: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (error) {
        print('Failed to save training: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nom de formation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomDeFormationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un nom de formation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Animer par',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _animerParController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'animateur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('à'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      controller: TextEditingController(
                        text: _selectedTime != null
                            ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTraining,
                child: const Text('Créer',

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
