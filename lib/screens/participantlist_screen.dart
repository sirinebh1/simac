import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParticipantListScreen extends StatefulWidget {
  final String title;

  const ParticipantListScreen({Key? key, required this.title}) : super(key: key);

  @override
  _ParticipantListScreenState createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  List<Participant> participants = [];

  @override
  void initState() {
    super.initState();
    fetchFormationIds().then((formationIds) {
      // Use the formation IDs to load participants
      for (var formationId in formationIds) {
        fetchParticipants(formationId);
      }
    });
  }

  Future<List<int>> fetchFormationIds() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8084/api/formation/listforamtion'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<int> formationIds = data.map((item) => item['id'] as int).toList();
      return formationIds;
    } else {
      throw Exception('Failed to load formation IDs');
    }
  }

  Future<void> fetchParticipants(int formationId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8084/api/formation/$formationId/participants'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Participant> fetchedParticipants =
      data.map((item) => Participant.fromJson(item)).toList();
      setState(() {
        participants.addAll(fetchedParticipants);
      });
    } else {
      throw Exception('Failed to load participants for formation $formationId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final participant = participants[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 8.0),
                  Text('Nom de formation: ${participant.nomDeFormation}',
                    style: TextStyle(
                    fontSize: 18.0, // Increased font size
                  ),

            ),

                  SizedBox(height: 8.0),
                  Text('Nom: ${participant.nom} ${participant.prenom}',
                    style: TextStyle(
                    fontSize: 18.0, // Increased font size
                  ),

            ),

                  SizedBox(height: 8.0),
                  Text('Email: ${participant.email}',
                    style: TextStyle(
                    fontSize: 18.0, // Increased font size
                  ),

          ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Participant {
  final String nomDeFormation;
  final String nom;
  final String prenom;
  final String email;

  Participant({
    required this.nomDeFormation,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      nomDeFormation: json['formationName'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
