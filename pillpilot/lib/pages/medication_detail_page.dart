import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/medication_state_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../models/medication_model.dart';
import '../controllers/medication/medication_controller.dart';
import 'medication_edit_page.dart';

class MedicationDetailPage extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final TimeOfDay time;
  final List<int> daysOfWeek;
  final bool isCompleted;
  final String notes;
  final void Function(bool) onToggle;

  const MedicationDetailPage({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.daysOfWeek,
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

  void _toggleCompletion(bool value) {
    setState(() {
      _isCompleted = value;
    });
  }

  void _saveAndGoBack() {
    widget.onToggle(_isCompleted);
    Navigator.pop(context);
  }

  String _formatDaysOfWeek(List<int> days) {
    if (days.length == 7) return 'Täglich';
    if (days.isEmpty) return 'Keine Tage ausgewählt';

    const dayMap = {1: 'Mo', 2: 'Di', 3: 'Mi', 4: 'Do', 5: 'Fr', 6: 'Sa', 7: 'So'};
    days.sort();
    return days.map((d) => dayMap[d] ?? '').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Medikament Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard('Name', widget.medicationName),
              const SizedBox(height: 16),
              _buildDetailCard('Dosierung', widget.dosage),
              const SizedBox(height: 16),

              _buildDetailCard('Uhrzeit', widget.time.format(context)),
              const SizedBox(height: 16),
              _buildDetailCard('Einnahmetage', _formatDaysOfWeek(widget.daysOfWeek)),
              const SizedBox(height: 16),
              _buildDetailCard('Notizen', widget.notes.isNotEmpty ? widget.notes : 'Keine Notizen vorhanden.', isNote: true),

              const SizedBox(height: 32),

              SwitchListTile(
                title: const Text('Als eingenommen markieren'),
                value: _isCompleted,
                onChanged: _toggleCompletion,
                activeColor: AppTheme.primaryColor,
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Bearbeiten',
                      isOutlined: true,
                      onPressed: _navigateToEditMedication,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'Speichern',
                      onPressed: _saveAndGoBack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, {bool isNote = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryTextColor,
            fontStyle: isNote && value == 'Keine Notizen vorhanden.' ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToEditMedication() async {

    final currentMedication = Medication(
      id: 'temp_id',
      name: widget.medicationName,
      dosage: widget.dosage,
      time: widget.time,
      daysOfWeek: widget.daysOfWeek,
      isCompleted: _isCompleted,
      notes: widget.notes,
    );

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => MedicationEditPage(medication: currentMedication),
      ),
    );
    if (result == true) {

    }
  }

}
