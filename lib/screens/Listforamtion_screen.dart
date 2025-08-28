import 'package:flutter/material.dart';
import 'package:pfe/screens/formation_screen.dart';
import 'package:pfe/screens/edit_screen.dart'; // Import the FormationScreen
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListFormationScreen extends StatefulWidget {
  const ListFormationScreen({Key? key, required String title}) : super(key: key);

  @override
  _ListFormationScreenState createState() => _ListFormationScreenState();
}

class _ListFormationScreenState extends State<ListFormationScreen> {
  List<Formation> formations = []; // List to store formations

  @override
  void initState() {
    super.initState();
    fetchFormations(); // Call the method to fetch formations when the screen initializes
  }

  Future<void> fetchFormations() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8084/api/formation/listforamtion'),
        headers: {
          'Content-Type': 'application/json', // Ensure appropriate headers
        },
      );

      // Print request headers for debugging
      print('Request Headers: ${response.request?.headers}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          formations = (json.decode(response.body) as List)
              .map((data) => Formation.fromJson(data))
              .toList(); // Convert JSON to list of Formation objects
        });
      } else {
        print('Failed to load formations: ${response.statusCode}');
        throw Exception('Failed to load formations');
      }
    } catch (error) {
      print('Error fetching formations: $error');
    }
  }

  void _editFormation(Formation formation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFormationScreen(formation: formation),
      ),
    ).then((result) {
      if (result == true) {
        fetchFormations(); // Refresh the list of formations after editing
      }
    });
  }

  Future<void> _deleteFormation(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8084/api/formation/$id/deleteformation'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        formations.removeWhere((formation) => formation.id == id);
      });
    } else {
      // Handle error
      print('Failed to delete formation: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Liste Des Formations',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
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
                          Text('Time: ${formation.time}'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editFormation(formation);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteFormation(formation.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomDeFormation': nomDeFormation,
      'animerPar': animerPar,
      'location': location,
      'date': date,
      'time': time,
    };
  }
}
