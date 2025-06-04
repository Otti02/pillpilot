import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/medication_item.dart';
import 'package:intl/intl.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({Key? key}) : super(key: key);

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  // Mock data for medications
  final List<Map<String, dynamic>> medications = [
    {
      'name': 'Ibuprofen',
      'dosage': '200mg',
      'timeOfDay': 'Morgens',
      'isCompleted': false,
    },
    {
      'name': 'Aspirin',
      'dosage': '500mg',
      'timeOfDay': 'Mittags',
      'isCompleted': false,
    },
    {
      'name': 'Paracetamol',
      'dosage': '500mg',
      'timeOfDay': 'Abends',
      'isCompleted': true,
    },
  ];

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCurrentTime(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Deine Einnahmen Heute',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Übersicht aller heutigen Einnahmen',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
                  return MedicationItem(
                    medicationName: medication['name'],
                    dosage: medication['dosage'],
                    timeOfDay: medication['timeOfDay'],
                    isCompleted: medication['isCompleted'],
                    onToggle: () {
                      setState(() {
                        medications[index]['isCompleted'] =
                            !medications[index]['isCompleted'];
                      });

                      // Show a notification when medication status changes
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            medications[index]['isCompleted']
                                ? '${medication['name']} als eingenommen markiert'
                                : '${medication['name']} als nicht eingenommen markiert',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
