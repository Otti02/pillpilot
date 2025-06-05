import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class MedicationDetailPage extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String timeOfDay;
  final bool isCompleted;
  final String notes;
  final void Function(bool) onToggle;

  const MedicationDetailPage({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.timeOfDay,
    required this.isCompleted,
    this.notes = '',
    required this.onToggle,
  });

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
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
      backgroundColor: AppTheme.backgroundColor,
      // Add a back button at the top
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with time, title, and subtitle
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
                    'Medikament Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Informationen zum Medikament',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medication Name
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.medicationName,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dosage
                    Text(
                      'Dosierung',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.dosage,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Time of Day
                    Text(
                      'Einnahmezeit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.timeOfDay,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Notes
                    Text(
                      'Notizen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.notes.isNotEmpty ? widget.notes : 'Keine Notizen vorhanden.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: widget.notes.isEmpty ? FontStyle.italic : FontStyle.normal,
                        color: widget.notes.isEmpty ? AppTheme.secondaryTextColor : AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Slider to mark as taken
                    Row(
                      children: [
                        Text(
                          'Als eingenommen markieren:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryTextColor,
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
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAndGoBack,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Speichern', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
