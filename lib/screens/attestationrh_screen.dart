import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttestationRhScreen extends StatefulWidget {
  @override
  _AttestationRhScreenState createState() => _AttestationRhScreenState();
}

class _AttestationRhScreenState extends State<AttestationRhScreen> {
  List<dynamic> attestationRequests = [];
  bool _requestHandled = false;

  @override
  void initState() {
    super.initState();
    fetchAttestationRequests();
  }

  Future<void> fetchAttestationRequests() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8084/api/attestations/list'));
    if (response.statusCode == 200) {
      setState(() {
        attestationRequests = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load attestation requests');
    }
  }

  Future<void> approveRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandeattestation/$id/approve'),
        body: jsonEncode({'status': 'approved'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        attestationRequests[index]['status'] = 'approved';
        _requestHandled = true;
      });
    } else {
      throw Exception('Failed to approve attestation request');
    }
  }

  Future<void> rejectRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandeattestation/$id/reject'),
        body: jsonEncode({'status': 'rejected'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        attestationRequests[index]['status'] = 'rejected';
        _requestHandled = true;
      });
    } else {
      throw Exception('Failed to reject attestation request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Demande Attestation'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: attestationRequests.length,
        itemBuilder: (context, index) {
          var request = attestationRequests[index];
          return Card(
            child: ListTile(
              title: Text('${request['prenom']} ${request['nom']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date of Birth: ${request['dateNaissance']}'),
                  Text('Poste: ${request['poste']}'),
                  Text('Reason: ${request['raison']}'),
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
                      if (!_requestHandled && request['status'] != 'approved' && request['status'] != 'rejected')
                        ElevatedButton(
                          onPressed: () {
                            approveRequest(request['id'], index);
                            setState(() {
                              _requestHandled = true;
                            });
                          },
                          child: Text('Approve'),
                        ),
                      SizedBox(width: 8), // Spacer
                      if (!_requestHandled && request['status'] != 'approved' && request['status'] != 'rejected')
                        ElevatedButton(
                          onPressed: () {
                            rejectRequest(request['id'], index);
                            setState(() {
                              _requestHandled = true;
                            });
                          },
                          child: Text('Reject'),
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
