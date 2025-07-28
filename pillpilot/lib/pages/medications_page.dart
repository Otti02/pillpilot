import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/medication/medication_controller.dart';
import '../models/medication_model.dart';
import '../models/medication_state_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_button.dart'; // Import für den CustomButton
import '../widgets/medication_item.dart';
import 'medication_edit_page.dart';


class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

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
      BlocProvider.of<MedicationController>(context).loadMedications();
    }
  }

  void _deleteMedication(BuildContext context, Medication medication) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Medikament löschen'),
        content: Text('Möchtest du "${medication.name}" wirklich löschen?'),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Abbrechen',
                  isOutlined: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'Löschen',
                  color: Colors.red,
                  onPressed: () async {
                    final medicationName = medication.name;
                    Navigator.of(dialogContext).pop();
                    await BlocProvider.of<MedicationController>(context)
                        .deleteMedication(medication.id);
                  },
                ),
              ),
            ],
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
                  Text(_getCurrentTime(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Deine Medikamente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('Übersicht aller Medikamente', style: TextStyle(fontSize: 14, color: AppTheme.secondaryTextColor)),
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
                    return Center(child: Text('Keine Medikamente vorhanden', style: TextStyle(fontSize: 16, color: AppTheme.secondaryTextColor)));
                  }

                  return ListView.builder(
                    itemCount: model.medications.length,
                    itemBuilder: (context, index) {
                      final medication = model.medications[index];
                      return MedicationItem(
                        medication: medication,
                        onTap: () => _navigateToEditMedication(context, medication),
                        trailingWidget: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMedication(context, medication),
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
