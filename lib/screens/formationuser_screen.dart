import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FormationuserScreen extends StatefulWidget {
  const FormationuserScreen({Key? key}) : super(key: key);

  @override
  _FormationuserScreenState createState() => _FormationuserScreenState();
}

class _FormationuserScreenState extends State<FormationuserScreen> {
  List<Formation> formations = []; // List to store formations
  int? _utilisateurId;

  @override
  void initState() {
    super.initState();
    fetchFormations();
    _loadUserId(); // Call the method to fetch formations when the screen initializes
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _utilisateurId = prefs.getInt('utilisateurId');
      print('Loaded utilisateurId: $_utilisateurId'); // Debug print
    });
  }

  Future<void> fetchFormations() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8084/api/formation/listforamtion'));
      if (response.statusCode == 200) {
        setState(() {
          formations = (json.decode(response.body) as List)
              .map((data) => Formation.fromJson(data))
              .toList(); // Convert JSON to list of Formation objects
        });
      } else {
        throw Exception('Failed to load formations');
      }
    } catch (error) {
      print('Error fetching formations: $error');
    }
  }

  Future<void> participateInFormation(int formationId, int userId) async {
    try {
      print('Formation ID: $formationId');
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8084/api/formation/participate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'formationId': formationId, 'userId': userId}),
      );
      print('Response status code: ${response.statusCode}'); // Print the response status code
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully registered for the formation')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to register for the formation');
      }
    } catch (error) {
      print('Error participating in formation: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register for the formation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Formations'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: formations.length,
          itemBuilder: (context, index) {
            final formation = formations[index];
            return Card(
              child: ListTile(
                title: Text(formation.nomDeFormation),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Animer par: ${formation.animerPar}'),
                    Text('Location: ${formation.location}'),
                    Text('Date: ${formation.date}'),
                    Text('Heure: ${formation.time}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => participateInFormation(formation.id, _utilisateurId ?? 0),
                  child: Text('participer'),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        child: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/user_screen');
          },
        ),
      ),
    );
  }
}

class Formation {
  final int id;
  final String nomDeFormation;
  final String animerPar;
  final String location;
  final String date;
  final String time;

  Formation({
    required this.id,
    required this.nomDeFormation,
    required this.animerPar,
    required this.location,
    required this.date,
    required this.time,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'],
      nomDeFormation: json['nomDeFormation'],
      animerPar: json['animerPar'],
      location: json['location'],
      date: json['date'],
      time: json['time'],
    );
  }
}
