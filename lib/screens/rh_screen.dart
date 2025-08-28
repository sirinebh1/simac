// lib/rh_screen.dart
import 'package:flutter/material.dart';

class RhScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RH Espace'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          children: <Widget>[
            _buildDashboardItem(context, 'demande de conge', '/congerh_screen'),
            _buildDashboardItem(context, 'demande de accompe', '/acompterh_screen'),
            _buildDashboardItem(context, 'Attestation', '/attestation'),
            _buildDashboardItem(context, 'demande de teletravail', '/congerh_screen'),
            _buildDashboardItem(context, 'changement de poste', '/congerh_screen'),
            _buildDashboardItem(context, 'Demission', '/demision_screen'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: Colors.indigo,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
