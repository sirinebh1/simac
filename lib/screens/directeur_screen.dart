import 'package:flutter/material.dart';
import 'package:pfe/screens/Listforamtion_screen.dart';
import 'package:pfe/screens/formation_screen.dart';
import 'package:pfe/screens/participantlist_screen.dart';

class DirecteurScreen extends StatefulWidget {
  @override
  _DirecteurScreenState createState() => _DirecteurScreenState();
}

class _DirecteurScreenState extends State<DirecteurScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    FormationScreen(title: 'Ajouter Formation'),
    ListFormationScreen(title: 'Liste de Formations'),
    ParticipantListScreen(title: 'Liste Des participants'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/formation');
        break;
      case 1:
        Navigator.pushNamed(context, '/listformation');
        break;
      case 2:
        Navigator.pushNamed(context, '/listparticipant');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Directeur'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              SizedBox(height: 24.0),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardTile(
                    icon: Icons.school,
                    title: 'Ajouter Formation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormationScreen(title: 'Ajouter Formation')),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    icon: Icons.list,
                    title: 'Liste Des Formation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListFormationScreen(title: 'Liste de Formations')),
                      );
                    },
                  ),
                  _buildDashboardTile(
                      icon: Icons.check,
                      title: 'Liste Des participants',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParticipantListScreen(title: 'Liste Des participants')),
                        );

                      }
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        backgroundColor: Colors.indigo,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Ajouter Formation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste Formations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Liste Participants',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile({required IconData icon, required String title, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
