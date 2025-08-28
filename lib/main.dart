import 'package:flutter/material.dart';
import 'package:pfe/screens/Listforamtion_screen.dart';
import 'package:pfe/screens/acompterh_screen.dart';
import 'package:pfe/screens/attestationrh_screen.dart';
import 'package:pfe/screens/demande_screen.dart';
import 'package:pfe/screens/formation_screen.dart';
import 'package:pfe/screens/login.dart';
import 'package:pfe/screens/politique_screen.dart';
import 'package:pfe/screens/rh_screen.dart';
import 'package:pfe/screens/user_screen.dart';
import 'package:pfe/screens/welecome_screen.dart';
import 'package:pfe/screens/default_screen.dart';
import 'package:pfe/screens/dashboard_screen.dart';
import 'package:pfe/screens/congerh_screen.dart';
import 'package:pfe/screens/directeur_screen.dart';
import 'package:pfe/screens/formationuser_screen.dart';
import 'package:pfe/screens/participantlist_screen.dart';
import 'package:pfe/screens/adduser_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelecomeScreen(),
        '/default_screen': (context) => const DefaultScreen(),
        '/dashboard_screen': (context) => const DashboardScreen(),
        '/user_screen': (context) => UserScreen(),
        '/demandes': (context) => DemandeScreen(),
        '/directeur_screen': (context) => DirecteurScreen(),
        '/rh_screen': (context) => RhScreen(),
        '/participe': (context) => FormationuserScreen(),
        '/formation': (context) => FormationScreen(title: 'ajouter formation'),
        '/listformation': (context) => ListFormationScreen(title: 'ajouter formation'),
        '/listparticipant': (context) => ParticipantListScreen(title: 'Liste Des participants'),
        '/congerh_screen': (context) => CongeRhScreen(),
        '/acompterh_screen': (context) => AcompteRhScreen(),
        '/attestation':(context)=>AttestationRhScreen(),
        '/adduser_screen': (context) => AdduserScreen(),
         '/polotiqueScreen': (context) => PolotiqueScreen()

      },
      navigatorObservers: [NavigatorObserver()],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
