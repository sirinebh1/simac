import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;

class Employee {
  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String cin;
  final String poste;
  final String departement;
  final String email;
  final String motPasse;
  final String role;

  Employee({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.cin,
    required this.poste,
    required this.departement,
    required this.email,
    required this.motPasse,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'cin': cin,
      'poste': poste,
      'departement': departement,
      'email': email,
      'motPasse': motPasse,
      'role': role,
    };
  }
}

class AdduserScreen extends StatefulWidget {
  const AdduserScreen({Key? key}) : super(key: key);

  @override
  _AdduserScreenState createState() => _AdduserScreenState();
}

class _AdduserScreenState extends State<AdduserScreen> {
  List<Employee> employees = [];

  void _addEmployee(Employee employee) async {
    try {
      var url = Uri.parse('http://10.0.2.2:8084/addEmployee');
      String hashedPassword = BCrypt.hashpw(employee.motPasse, BCrypt.gensalt());

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(employee.toJson()..['motPasse'] = hashedPassword),
      );
      if (response.statusCode == 200) {
        print('Employee added successfully. Status code: ${response.statusCode}');
       // Navigator.pushReplacementNamed(context, '/adduser_screen');
      } else {
        print('Failed to add employee. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to add employee. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdduserWidget(
        employees: employees,
        addEmployee: _addEmployee,
      ),
    );
  }
}

class AdduserWidget extends StatelessWidget {
  const AdduserWidget({
    Key? key,
    required this.employees,
    required this.addEmployee,
  }) : super(key: key);

  final List<Employee> employees;
  final void Function(Employee employee) addEmployee;

  @override
  Widget build(BuildContext context) {
    String newEmployeeId = '';
    String newEmployeeMatricule = '';
    String newEmployeeNom = '';
    String newEmployeePrenom = '';
    String newEmployeeDateNaissance = '';
    String newEmployeeCIN = '';
    String newEmployeePoste = '';
    String newEmployeeDepartement = '';
    String newEmployeeEmail = '';
    String newEmployeePassword = '';
    String newEmployeeRole = 'USER';

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajouter employee',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeId = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'ID',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeMatricule = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Matricule',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeNom = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nom',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeePrenom = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Prénom',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeDateNaissance = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Date de naissance (yyyy-mm-dd)',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeCIN = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'CIN',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeePoste = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Poste',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeDepartement = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Département',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeeEmail = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    newEmployeePassword = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Mot de passe',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: newEmployeeRole,
                  items: <String>['USER', 'RH', 'DIRECTEUR', 'ADMIN'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    newEmployeeRole = newValue!;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      try {
                        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(newEmployeeDateNaissance);
                        String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                        addEmployee(Employee(
                          id: newEmployeeId,
                          matricule: newEmployeeMatricule,
                          nom: newEmployeeNom,
                          prenom: newEmployeePrenom,
                          dateNaissance: formattedDate,
                          cin: newEmployeeCIN,
                          poste: newEmployeePoste,
                          departement: newEmployeeDepartement,
                          email: newEmployeeEmail,
                          motPasse: newEmployeePassword,
                          role: newEmployeeRole,
                        ));
                      } catch (e) {
                        print('Error parsing date: $e');
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
