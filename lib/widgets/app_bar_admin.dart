import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Text('Espace Admin', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            // Navigate to login screen
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  const NavigationDrawer({Key? key, required this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: Container(
      color: Colors.indigo.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Container(
    color: Colors.indigo,
    padding: EdgeInsets.only(
      top: 24 + MediaQuery.of(context).padding.top,
      bottom: 40,
    ),
    child: const Column(
      children: [
        Text(
          'Sirine Ben Hassen',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        SizedBox(height: 12),
        Text(
          'Email:123sirinebenhassen@gamil.com',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    ),
  );

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('espace admin'),
          onTap: () => onItemTapped(0),
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Liste Des Employees'),
          onTap: () => onItemTapped(1),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('ajouter un employee'),
          onTap: () => onItemTapped(2),
        ),
      ],
    ),
  );
}
