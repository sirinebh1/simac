import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoriqueScreen extends StatefulWidget {
  @override
  _HistoriqueScreenState createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  List<dynamic> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8084/api/demandes/list'));
    if (response.statusCode == 200) {
      setState(() {
        leaveRequests = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load leave requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> categorizedRequests = {};

    for (var request in leaveRequests) {
      String? startDate = request['startDate'];
      if (startDate != null) {
        String monthYear = startDate.substring(0, 7);
        if (categorizedRequests[monthYear] == null) {
          categorizedRequests[monthYear] = [];
        }
        categorizedRequests[monthYear]!.add(request);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Etat de s Demandes'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: categorizedRequests.keys.length,
        itemBuilder: (context, index) {
          String monthYear = categorizedRequests.keys.elementAt(index);
          List<dynamic> requests = categorizedRequests[monthYear]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  monthYear,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...requests.map((request) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${request['prenom']} ${request['nom']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Date De Depart: ${request['startDate']} - ${request['endDate']}'),
                        SizedBox(height: 4),
                        Text('Duree: ${request['duration']} days'),
                        SizedBox(height: 4),
                        Text('Raison: ${request['type']}'),
                        SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: request['status'] == 'approved'
                                ? Colors.green.withOpacity(0.1)
                                : request['status'] == 'rejected'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
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
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
