import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttestationScreen extends StatefulWidget {
  const AttestationScreen({Key? key}) : super(key: key);

  @override
  State<AttestationScreen> createState() => _AttestationScreenState();
}

class _AttestationScreenState extends State<AttestationScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _posteController = TextEditingController();
  final TextEditingController _raisonController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8084/api/attestations/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'dateNaissance': _selectedDate?.toIso8601String(),
        'poste': _posteController.text,
        'raison': _raisonController.text,
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
        title: const Text('Demande d\'attestation de travail'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prenom',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: _selectedDate == null ? '' : "${_selectedDate!.toLocal()}".split(' ')[0],
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _posteController,
                decoration: const InputDecoration(
                  labelText: 'Poste',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _raisonController,
                decoration: const InputDecoration(
                  labelText: 'Raison',
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text(
                  'Envoyer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
