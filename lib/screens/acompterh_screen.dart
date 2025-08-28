import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AcompteRhScreen extends StatefulWidget {
  @override
  _AcompteRhScreenState createState() => _AcompteRhScreenState();
}

class _AcompteRhScreenState extends State<AcompteRhScreen> {
  List<dynamic> acompteRequests = [];
  bool _requestHandled = false;

  @override
  void initState() {
    super.initState();
    fetchAcompteRequests();
  }

  Future<void> fetchAcompteRequests() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8084/api/demandeacompte/list'));
    if (response.statusCode == 200) {
      setState(() {
        acompteRequests = json.decode(response.body);
      });
      print('Acompte Requests: $acompteRequests');
    } else {
      throw Exception('Failed to load acompte requests');
    }
  }

  Future<void> approveRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandeacompte/$id/approve'),
        body: jsonEncode({'status': 'approved'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        acompteRequests[index]['status'] = 'approved';
        _requestHandled = false;
      });
    } else {
      throw Exception('Failed to approve acompte request');
    }
  }

  Future<void> rejectRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandeacompte/$id/reject'),
        body: jsonEncode({'status': 'rejected'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        acompteRequests[index]['status'] = 'rejected';
        _requestHandled = false;
      });
    } else {
      throw Exception('Failed to reject acompte request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Demandes Acompte'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: acompteRequests.length,
        itemBuilder: (context, index) {
          var request = acompteRequests[index];
          return Card(
            child: ListTile(
              //title: Text('${request['prenom']} ${request['nom']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date souhaité: ${request['datePaiementSouhaite']}'),
                  Text('montant: ${request['montant']}'),
                  Text(
                    request['status'] == 'approved'
                        ? 'Approved'
                        : request['status'] == 'rejected'
                        ? 'Rejected'
                        : 'Pending',
                    style: TextStyle(
                      color: request['status'] == 'approved'
                          ? Colors.green
                          : request['status'] == 'rejected'
                          ? Colors.red
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (!_requestHandled &&
                          request['status'] != 'approved' &&
                          request['status'] != 'rejected')
                        ElevatedButton(
                          onPressed: () {
                            approveRequest(request['id'], index);
                            setState(() {
                              _requestHandled = true;
                            });
                          },
                          child: Text('Approver'),
                        ),
                      SizedBox(width: 8), // Spacer
                      if (!_requestHandled &&
                          request['status'] != 'approved' &&
                          request['status'] != 'rejected')
                        ElevatedButton(
                          onPressed: () {
                            rejectRequest(request['id'], index);
                            setState(() {
                              _requestHandled = true;
                            });
                          },
                          child: Text('Rejecter'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
