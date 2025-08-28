import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'list_screen.dart';

class EdituserScreen extends StatefulWidget {
  final User user;

  EdituserScreen({required this.user});

  @override
  _EdituserScreenState createState() => _EdituserScreenState();
}

class _EdituserScreenState extends State<EdituserScreen> {
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController matriculeController;
  late TextEditingController departementController;
  late TextEditingController posteController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.user.nom);
    prenomController = TextEditingController(text: widget.user.prenom);
    matriculeController = TextEditingController(text: widget.user.matricule.toString());
    departementController = TextEditingController(text: widget.user.departement);
    posteController = TextEditingController(text: widget.user.poste);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextFormField(
              controller: prenomController,
              decoration: InputDecoration(labelText: 'Prenom'),
            ),
            TextFormField(
              controller: matriculeController,
              decoration: InputDecoration(labelText: 'Matricule'),
            ),
            TextFormField(
              controller: departementController,
              decoration: InputDecoration(labelText: 'Departement'),
            ),
            TextFormField(
              controller: posteController,
              decoration: InputDecoration(labelText: 'Poste'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                User updatedUser = User(
                  id: widget.user.id,
                  nom: nomController.text,
                  prenom: prenomController.text,
                  matricule: int.tryParse(matriculeController.text) ?? 0,
                  departement: departementController.text,
                  poste: posteController.text,
                  email: emailController.text,
                  role: widget.user.role,
                );

                http.Response response = await http.put(
                  Uri.parse('http://10.0.2.2:8084/updateUser'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(updatedUser.toJson()),
                );
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User updated successfully')),
                  );
                  Navigator.of(context).pop(true); // Return true to indicate success
                } else {
                  print('Failed to update user. Status code: ${response.statusCode}');
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    matriculeController.dispose();
    departementController.dispose();
    posteController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
