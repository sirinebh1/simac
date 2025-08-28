import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pfe/screens/Listforamtion_screen.dart';
import 'package:pfe/screens/formation_screen.dart'; // Adjust the path accordingly

class EditFormationScreen extends StatefulWidget {
  final Formation formation;

  EditFormationScreen({required this.formation});

  @override
  _EditFormationScreenState createState() => _EditFormationScreenState();
}

class _EditFormationScreenState extends State<EditFormationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nomDeFormation;
  late String _animerPar;
  late String _location;
  late String _date;
  late String _time;

  @override
  void initState() {
    super.initState();
    _nomDeFormation = widget.formation.nomDeFormation;
    _animerPar = widget.formation.animerPar;
    _location = widget.formation.location;
    _date = widget.formation.date;
    _time = widget.formation.time;
  }

  Future<void> _saveFormation() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8084/api/formation/${widget.formation.id}/updateformation'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nomDeFormation': _nomDeFormation,
        'animerPar': _animerPar,
        'location': _location,
        'date': _date,
        'time': _time,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('modifier Formation'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nomDeFormation,
                decoration: InputDecoration(labelText: 'Nom de Formation'),
                onChanged: (value) {
                  setState(() {
                    _nomDeFormation = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _animerPar,
                decoration: InputDecoration(labelText: 'Animer Par'),
                onChanged: (value) {
                  setState(() {
                    _animerPar = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (value) {
                  setState(() {
                    _date = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _time,
                decoration: InputDecoration(labelText: 'heure'),
                onChanged: (value) {
                  setState(() {
                    _time = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFormation,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
