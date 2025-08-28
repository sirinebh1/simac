import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edituser_screen.dart';

class User {
  int id;
  String nom;
  String prenom;
  int matricule;
  String departement;
  String poste;
  String email;
  String? role;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.departement,
    required this.poste,
    required this.email,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'departement': departement,
      'poste': poste,
      'email': email,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      matricule: json['matricule'],
      departement: json['departement'],
      poste: json['poste'],
      email: json['email'],
      role: json['role'],
    );
  }
}

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    print('Fetching users...');
    final response = await http.get(Uri.parse('http://10.0.2.2:8084/getEmployees'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Response data: $jsonData');
      setState(() {
        users = (jsonData as List<dynamic>)
            .map((userJson) {
          print('User JSON: $userJson');
          return User.fromJson(userJson);
        })
            .where((user) => user.role != null && user.role!.isNotEmpty) // Include users with non-null roles
            .toList();
      });
      print('Parsed users: $users');
    } else {
      print('Failed to fetch users. Status code: ${response.statusCode}');
    }
  }

  void _editUser(User user) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EdituserScreen(user: user)),
    );

    if (result == true) {
      fetchUsers(); // Refresh the list of users if the user was edited
    }
  }

  Future<void> _deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8084/deleteUser/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        users.removeWhere((user) => user.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } else {
      print('Failed to delete user. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste Des Employeés'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('${user.nom} ${user.prenom}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Matricule: ${user.matricule}'),
                      Text('Departement: ${user.departement}'),
                      Text('Poste: ${user.poste}'),
                      Text('Email: ${user.email}'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.lightGreen.shade300,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.green,
                          onPressed: () => _editUser(user),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.red.shade300,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _deleteUser(user.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
