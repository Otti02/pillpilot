import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/medication/medication_controller.dart';
import '../models/medication_model.dart';
import '../models/medication_state_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'medication_edit_page.dart';

class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if needed
    final controller = BlocProvider.of<MedicationController>(context);
    if (controller.state.medications.isEmpty) {
      controller.loadMedications();
    }
    
    return _MedicationsPageContent();
  }
}

class _MedicationsPageContent extends StatelessWidget {
  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void _navigateToCreateMedication(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => MedicationEditPage(),
      ),
    );

    if (result == true) {
      // Medication was created, refresh the list
      BlocProvider.of<MedicationController>(context).loadMedications();
    }
  }

  void _navigateToEditMedication(BuildContext context, Medication medication) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => MedicationEditPage(medication: medication),
      ),
    );

    if (result == true) {
      // Medication was updated, refresh the list
      BlocProvider.of<MedicationController>(context).loadMedications();
    }
  }

  void _deleteMedication(BuildContext context, Medication medication) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Medikament löschen'),
        content: Text('Möchtest du "${medication.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              // Store medication name before async operation
              final medicationName = medication.name;
              Navigator.pop(context);
              await BlocProvider.of<MedicationController>(context).deleteMedication(medication.id);

              // Check if the widget is still mounted before using context
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$medicationName wurde gelöscht'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateMedication(context),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
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
                    'Deine Medikamente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Übersicht aller Medikamente',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MedicationController, MedicationModel>(
                builder: (context, model) {
                  if (model.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (model.medications.isEmpty) {
                    return Center(
                      child: Text(
                        'Keine Medikamente vorhanden',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: model.medications.length,
                    itemBuilder: (context, index) {
                      final medication = model.medications[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowColor,
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Medication Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.iconBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.medication,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Medication Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medication.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${medication.dosage}, ${medication.timeOfDay}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: AppTheme.primaryColor),
                                  onPressed: () => _navigateToEditMedication(context, medication),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteMedication(context, medication),
                                ),
                              ],
                            ),
                          ],
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