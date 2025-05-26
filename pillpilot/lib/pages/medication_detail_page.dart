import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MedicationDetailPage extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String timeOfDay;
  final bool isCompleted;
  final Function(bool) onToggle;

  const MedicationDetailPage({
    Key? key,
    required this.medicationName,
    required this.dosage,
    required this.timeOfDay,
    required this.isCompleted,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  late bool _isCompleted;

  // A slightly more pink color than the primary color
  static const Color textColor = Color(0xFF7A5AA6);

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  void _toggleCompletion(bool value) {
    setState(() {
      _isCompleted = value;
    });
  }

  void _saveAndGoBack() {
    widget.onToggle(_isCompleted);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medikament Details'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication Name
            Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.medicationName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // Intake Time
            Text(
              'Einnahme Uhrzeit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.dosage}, ${widget.timeOfDay}',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.primaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // Notes/Info
            Text(
              'Notizen/Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keine Notizen vorhanden.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 40),

            // Slider to mark as taken
            Row(
              children: [
                Text(
                  'Als eingenommen markieren:',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: _isCompleted,
                  onChanged: _toggleCompletion,
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndGoBack,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Speichern'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
