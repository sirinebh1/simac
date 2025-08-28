import 'package:flutter/material.dart';
import 'package:pfe/screens/attestation_screen.dart';
import 'package:pfe/screens/changementposte_screen.dart';
import 'package:pfe/screens/conge_screen.dart';
import 'package:pfe/screens/demission_screen.dart';
import 'package:pfe/screens/historique_screen.dart';
import 'package:pfe/screens/acompte_screen.dart';
import 'package:pfe/screens/teletravail_screen.dart';

class DemandeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> demandes = [
    {'title': 'Demande de Congé', 'icon': Icons.beach_access, 'screen': CongeScreen()},
    {'title': 'Demande Acompte', 'icon': Icons.attach_money, 'screen': AcompteScreen()},
    {'title': 'Attestation de Travail', 'icon': Icons.work, 'screen': AttestationScreen()},
    {'title': 'Teletravail', 'icon': Icons.home, 'screen':TeletravailScreen()},
    {'title': 'Changement de Poste', 'icon': Icons.swap_horiz, 'screen':ChangementPosteScreen()},
    {'title': 'Demission', 'icon': Icons.exit_to_app,'screen':DemissionScreen()},
    {'title': 'Historique des Demandes', 'icon': Icons.history,'screen':  HistoriqueScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: demandes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Icon(demandes[index]['icon'], color: Color(0xFF5C63D6)),
              title: Text(demandes[index]['title'], style: TextStyle(fontSize: 18.0)),
              onTap: () {
                var screen = demandes[index]['screen'];
                if (screen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                } else {
                  // Handle other navigation if necessary
                }
              },
            ),
          );
        },
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

void main() {
  runApp(MaterialApp(
    home: DemandeScreen(),
  ));
}
