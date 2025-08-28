import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/adduser_screen.dart';
import 'package:pfe/screens/list_screen.dart';
import 'package:pfe/widgets/app_bar_admin.dart' as custom;
import 'package:pfe/widgets/custom_navigation_bar_admin.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardHome(onItemTapped: (index) => _onNavBarTap(index)),
      ListScreen(),
      AdduserScreen(),
    ];
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onDrawerItemTap(int index) {
    Navigator.pop(context); // Close the drawer
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom.AppBarAdmin(),
      drawer: custom.NavigationDrawer(onItemTapped: (index) => _onDrawerItemTap(index)),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBarAdmin(
        index: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  final Function(int) onItemTapped;

  DashboardHome({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        SizedBox(height: 20),
        itemDashboard(
          context,
          'ajouter des employee',
          CupertinoIcons.add_circled,
          Colors.indigo.shade700,
          onTap: () => onItemTapped(2),
        ),
        SizedBox(height: 30),
        itemDashboard(
          context,
          'liste des employees',
          CupertinoIcons.person_2,
          Colors.indigo.shade700,
          onTap: () => onItemTapped(1),
        ),
      ],
    );
  }

  Widget itemDashboard(BuildContext context, String title, IconData iconData, Color background, {required Function onTap}) => GestureDetector(
    onTap: () => onTap(),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5),
          ]),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)),
          const SizedBox(width: 20),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.headline6),
        ],
      ),
    ),
  );
}
