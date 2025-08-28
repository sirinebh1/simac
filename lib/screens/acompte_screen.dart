import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AcompteScreen extends StatefulWidget {
  const AcompteScreen({Key? key}) : super(key: key);

  @override
  State<AcompteScreen> createState() => _AcompteScreenState();
}

class _AcompteScreenState extends State<AcompteScreen> {
  final TextEditingController montantController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> sendRequest() async {
    final String apiUrl = "http://10.0.2.2:8084/api/demandeacompte/createacompte";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "montant": double.tryParse(montantController.text),
        "datePaiementSouhaite": dateController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully sent request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande envoyée avec succès')),
      );
      Navigator.pop(context);
    } else {
      // Error sending request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de la demande')),
      );
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
        title: const Text('demande d\'accompte'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MONTANT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Monatant Desireé',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Date de paiement souhaité',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today),
                hintText: 'Date',
                border: const OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = pickedDate.toString().split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                  'envoyer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
