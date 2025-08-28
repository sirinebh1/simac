import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CongeScreen extends StatefulWidget {
  @override
  _CongeScreenState createState() => _CongeScreenState();
}

class _CongeScreenState extends State<CongeScreen> {
  String? _selectedType;
  DateTime _focusedDay = DateTime.now();
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _utilisateurId;

  final List<String> _types = ['maladie', 'mariage', 'vacances'];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _utilisateurId = prefs.getInt('utilisateurId');
      print('Loaded utilisateurId: $_utilisateurId'); // Debug print
    });
  }

  int getSelectedDays() {
    if (_fromDate != null && _toDate != null) {
      return _toDate!.difference(_fromDate!).inDays + 1; // +1 to include the last day
    }
    return 0;
  }

  String getApplyButtonText() {
    int days = getSelectedDays();
    if (days > 0) {
      return 'Demande pour $days jours de congé';
    } else {
      return 'Demander';
    }
  }

  Future<void> submitDemande(DemandeConge demande) async {
    final url = 'http://10.0.2.2:8084/api/demandes/create';
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(demande.toJson());

    print('Request URL: $url');
    print('Request Headers: $headers');
    print('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demande créée avec succès'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la création de la demande: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      print('Error creating demande: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite. Veuillez réessayer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/type.png'),
                ),
                SizedBox(width: 5),
                Text('Type: ', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedType,
                  hint: Text('choisir un type'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items: _types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/detinastion.png'),
                ),
                Text('De: ', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                _fromDate == null
                    ? Text('Sélectionner')
                    : Text(DateFormat('yyyy-MM-dd').format(_fromDate!)),
                SizedBox(width: 20),
                Text('A: ', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                _toDate == null
                    ? Text('Sélectionne')
                    : Text(DateFormat('yyyy-MM-dd').format(_toDate!)),
              ],
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2101),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_fromDate, day) || isSameDay(_toDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  if (_fromDate == null || (_fromDate != null && _toDate != null)) {
                    _fromDate = selectedDay;
                    _toDate = null;
                  } else if (_toDate == null) {
                    _toDate = selectedDay;
                    if (_toDate!.isBefore(_fromDate!)) {
                      // Swap the dates if selected end date is before start date
                      final temp = _fromDate;
                      _fromDate = _toDate;
                      _toDate = temp;
                    }
                  }
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFF5C63D6),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Color(0xFF5C63D6), // Background color
                  ),
                  onPressed: () {
                    print('Selected Type: $_selectedType');
                    print('From Date: $_fromDate');
                    print('To Date: $_toDate');
                    print('Utilisateur ID: $_utilisateurId');

                    if (_selectedType != null && _fromDate != null && _toDate != null && _utilisateurId != null) {
                      final demande = DemandeConge(
                        type: _selectedType!,
                        startDate: _fromDate!,
                        endDate: _toDate!,
                        utilisateurId: _utilisateurId!,
                      );
                      submitDemande(demande);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Veuillez remplir tous les champs'),
                        ),
                      );
                    }
                  },
                  child: Text(getApplyButtonText()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemandeConge {
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final int utilisateurId;

  DemandeConge({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.utilisateurId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'utilisateur': {
        'id': utilisateurId,
      },
    };
  }
}
