import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe/widgets/custom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<loginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController MotPasseController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    MotPasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 4,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formLoginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Entrer votre Email',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: MotPasseController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrer votre mot de passe',
                        ),
                      ),
                      

                      ElevatedButton(
                        onPressed: () async {
                          String email = emailController.text;
                          String MotPasse = MotPasseController.text;
                          await loginUser(email, MotPasse, context);
                        },
                        child: const Text('Connexion'),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> loginUser(String email, String password, BuildContext context) async {
  try {
    print('Sending login request...');
    print('Email: $email');
    print('Password: $password');


    final response = await http.post(
      Uri.parse('http://10.0.2.2:8084/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, String>{
        'email': email,
        'motPasse': password,
      }),
    );
    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      final authToken = responseData['jwt'];
      final utilisateurId = responseData['utilisateurId'];
      await prefs.setString('authToken', authToken);
      await prefs.setInt('utilisateurId', utilisateurId);


      switch (responseData['role']) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/dashboard_screen');
          break;
        case 'user':
          Navigator.pushReplacementNamed(context, '/user_screen');
          break;
        case 'rh':
          Navigator.pushReplacementNamed(context, '/rh_screen');
          break;
        case 'directeur':
          Navigator.pushReplacementNamed(context, '/directeur_screen');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/default_screen');
   }
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email or password incorrect.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to login. Please check your credentials.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
