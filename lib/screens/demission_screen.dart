import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemissionScreen extends StatefulWidget {
  const DemissionScreen({Key? key}) : super(key: key);

  @override
  State<DemissionScreen> createState() => _DemissionScreenState();
}

class _DemissionScreenState extends State<DemissionScreen> {
  String _reasons = '';
  DateTime _dateDeDepart = DateTime.now();
  String _motifDepart = '';

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8084/api/demission/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'reasons': _reasons,
        'dateDeDepart': _dateDeDepart.toIso8601String(),
        'motifDepart': _motifDepart,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Request submitted successfully: ${response.body}');
    } else {
      // Handle error
      print('Failed to submit request: ${response.statusCode}, ${response.body}');
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
        title: const Text('Demande de démission'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demande de démission',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Merci de préciser les raisons de votre départ:',
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
            const SizedBox(height: 16.0),
            const Text(
              'Date de départ souhaitée:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dateDeDepart,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    _dateDeDepart = picked;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                'Sélectionner une date: ${_dateDeDepart.day}/${_dateDeDepart.month}/${_dateDeDepart.year}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Motif de départ:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Motif de départ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _motifDepart = value;
                });
              },
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                  print('Demande de démission envoyée!');
                },
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
