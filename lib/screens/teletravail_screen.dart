import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeletravailScreen extends StatefulWidget {
  const TeletravailScreen({Key? key}) : super(key: key);

  @override
  State<TeletravailScreen> createState() => _TeletravailScreenState();
}

class _TeletravailScreenState extends State<TeletravailScreen> {
  bool _isWorkingFromHome = false;
  String _reasons = '';
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8084/api/teletravail/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': _selectedDate?.toIso8601String(),
        'isWorkingFromHome': _isWorkingFromHome,
        'reasons': _reasons,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request submitted successfully'),
        ),
      );
      Navigator.pop(context);
    } else {
      // Handle error
      print('Failed to submit request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Demande de télétravail'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Souhaitez-vous travailler à domicile aujourd\'hui?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Oui'),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: _isWorkingFromHome,
                          onChanged: (value) {
                            setState(() {
                              _isWorkingFromHome = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Non'),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: !_isWorkingFromHome,
                          onChanged: (value) {
                            setState(() {
                              _isWorkingFromHome = !value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_isWorkingFromHome) ...[
              const Text(
                'Merci de préciser les raisons de votre demande:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Raisons',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    _reasons = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                    'Envoyer',
                     style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
