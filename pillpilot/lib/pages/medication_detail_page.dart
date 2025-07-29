import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/medication_state_model.dart';
import '../services/service_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../models/medication_model.dart';
import '../controllers/medication/medication_controller.dart';
import '../widgets/large_checkbox_tile.dart';
import 'medication_edit_page.dart';

class MedicationDetailPage extends StatefulWidget {
  final Medication medication;
  final void Function(bool) onToggle;

  const MedicationDetailPage({
    super.key,
    required this.medication,
    required this.onToggle,
  });

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  late bool _isCompleted;
  late bool _enableReminders;
  late final MedicationController _medicationController;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.medication.isCompleted;
    _enableReminders = widget.medication.enableReminders;
    _medicationController = MedicationController(
      medicationService: ServiceProvider.instance.medicationService,
      notificationService: ServiceProvider.instance.notificationService,
    );
  }

  Future<void> _toggleEnableReminders(bool newValue) async {
    setState(() {
      _enableReminders = newValue;
    });
  }

  void _toggleCompletion(bool value) {
    setState(() {
      _isCompleted = value;
    });
  }

  Future<void> _saveAndGoBack() async {
    final updatedMedication = widget.medication.copyWith(
      isCompleted: _isCompleted,
      enableReminders: _enableReminders,
    );

    await _medicationController.updateMedication(updatedMedication);

    if (mounted) {
      Navigator.pop(context, true);
    }
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Medikament Details',
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: themeProvider.primaryTextColor),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard('Name', widget.medication.name, themeProvider),
                  const SizedBox(height: 16),
                  _buildDetailCard('Dosierung', widget.medication.dosage, themeProvider),
                  const SizedBox(height: 16),
                  _buildDetailCard('Uhrzeit', widget.medication.time.format(context), themeProvider),
                  const SizedBox(height: 16),
                  _buildDetailCard('Einnahmetage', _formatDaysOfWeek(widget.medication.daysOfWeek), themeProvider),
                  const SizedBox(height: 16),
                  _buildDetailCard('Notizen', widget.medication.notes.isNotEmpty ? widget.medication.notes : 'Keine Notizen vorhanden.', themeProvider, isNote: true),
                  const SizedBox(height: 32),
                  LargeCheckboxListTile(
                    title: 'Erinnerungen aktivieren',
                    value: _enableReminders,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        _toggleEnableReminders(newValue);
                      }
                    },
                    scale: 1.5,
                  ),
                  const SizedBox(height: 16),
                  LargeCheckboxListTile(
                    title: 'Eingenommen',
                    value: _isCompleted,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        _toggleCompletion(newValue);
                      }
                    },
                    scale: 1.5,
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
      },
    );
  }

  Widget _buildDetailCard(String title, String value, ThemeProvider themeProvider, {bool isNote = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: themeProvider.primaryTextColor,
            fontStyle: isNote && value == 'Keine Notizen vorhanden.' ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToEditMedication() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => MedicationEditPage(medication: widget.medication),
      ),
    );
  }
}
