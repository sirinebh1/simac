import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChangementPosteScreen extends StatefulWidget {
  const ChangementPosteScreen({Key? key}) : super(key: key);

  @override
  State<ChangementPosteScreen> createState() => _ChangementPosteScreenState();
}

class _ChangementPosteScreenState extends State<ChangementPosteScreen> {
  String _currentPoste = '';
  String _newPoste = '';
  String _reasons = '';

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8084/api/changementposte/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({

        'currentPoste': _currentPoste,
        'newPoste': _newPoste,
        'reasons': _reasons,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Request submitted successfully');
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
        title: const Text('Demande de changement de poste'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demande de changement de poste',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Poste actuel',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _currentPoste = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nouveau poste',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _newPoste = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                  print('Demande de changement de poste envoyée!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Envoyer',
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
