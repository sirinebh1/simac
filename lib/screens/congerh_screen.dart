import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CongeRhScreen extends StatefulWidget {
  @override
  _CongeRhScreenState createState() => _CongeRhScreenState();
}

class _CongeRhScreenState extends State<CongeRhScreen> {
  List<dynamic> leaveRequests = [];
  bool _requestHandled = false;

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8084/api/demandes/list'));
    if (response.statusCode == 200) {
      setState(() {
        leaveRequests = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load leave requests');
    }
  }

  Future<void> approveRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandes/$id/update'),
        body: jsonEncode({'status': 'approved'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        leaveRequests[index]['status'] = 'approved';
        _requestHandled = true;
      });
    } else {
      throw Exception('Failed to approve leave request');
    }
  }


  Future<void> rejectRequest(int id, int index) async {
    final response = await http.put(
        Uri.parse('http://10.0.2.2:8084/api/demandes/$id/update'),
        body: jsonEncode({'status': 'rejected'}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      // Update the status in the leaveRequests list
      setState(() {
        leaveRequests[index]['status'] = 'rejected';
        _requestHandled = true;
      });
    } else {
      throw Exception('Failed to reject leave request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de congé'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: leaveRequests.length,
        itemBuilder: (context, index) {
          var request = leaveRequests[index];
          return Card(
            child: ListTile(
              title: Text('${request['prenom']} ${request['nom']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Leave Date: ${request['startDate']} - ${request['endDate']}'),
                  Text('Duration: ${request['duration']} days'),
                  Text('Reason: ${request['type']}'),
                  Text(
                    request['status'] == 'approved'
                        ? 'Approved'
                        : request['status'] == 'rejected'
                        ? 'Rejected'
                        : '',
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