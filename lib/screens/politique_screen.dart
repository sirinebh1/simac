import 'package:flutter/material.dart';

class PolotiqueScreen extends StatelessWidget {
  final String policyContent = '''
    Objectif :
    Assurer la sécurité des informations et des systèmes informatiques de l'entreprise, protéger la confidentialité, l'intégrité et la disponibilité des données.

    Responsabilités :

    - La direction est responsable de définir la politique de sécurité informatique, de l'approuver et de la promouvoir au sein de l'entreprise.
    - Les responsables informatiques sont responsables de la mise en œuvre et de l'application de la politique de sécurité informatique.
    - Les employés doivent respecter la politique de sécurité informatique et signaler tout incident ou problème de sécurité.

    Accès aux systèmes :

    - Chaque employé recevra un identifiant unique pour accéder aux systèmes informatiques de l'entreprise.
    - L'accès aux informations sensibles sera limité aux employés autorisés uniquement.

    Protection des données :

    - Les données sensibles doivent être stockées de manière sécurisée et protégées contre tout accès non autorisé.
    - Les sauvegardes régulières doivent être effectuées pour prévenir la perte de données.

    Utilisation des ressources informatiques :

    - Les ressources informatiques de l'entreprise doivent être utilisées à des fins professionnelles uniquement.
    - Les logiciels piratés ou non autorisés ne doivent pas être installés sur les ordinateurs de l'entreprise.

    Gestion des incidents de sécurité :

    - Tout incident de sécurité informatique doit être signalé immédiatement à l'équipe informatique.
    - Une enquête sera menée pour déterminer la cause de l'incident et des mesures correctives seront prises pour prévenir de futurs incidents.

    Formation et sensibilisation :

    - Des formations régulières sur la sécurité informatique seront dispensées aux employés pour les sensibiliser aux risques et aux meilleures pratiques de sécurité.

    Sanctions :

    - Tout employé ne respectant pas la politique de sécurité informatique sera passible de sanctions disciplinaires, pouvant aller jusqu'au licenciement.

    Révision de la politique :

    - La politique de sécurité informatique sera régulièrement révisée et mise à jour pour prendre en compte les nouvelles menaces et les nouvelles technologies.
    ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Sécurité Informatique'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              policyContent,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
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
