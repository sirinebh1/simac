import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomNavigationBarAdmin extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const CustomNavigationBarAdmin({required this.index, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index,
      items: const <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.list, size: 30),
        Icon(Icons.add, size: 30),
      ],
      onTap: onTap,
      backgroundColor: Colors.white,
      color: Colors.indigo,
      buttonBackgroundColor: Colors.indigo,
      height: 50,
    );
  }
}
