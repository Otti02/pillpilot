import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../controllers/medication/medication_controller.dart';
import '../models/medication_model.dart';
import '../models/medication_state_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_button.dart'; // Import für den CustomButton
import '../widgets/medication_item.dart';
import 'medication_edit_page.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void _navigateToCreateMedication(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (context) => MedicationEditPage()),
    );
    if (result == true && mounted) {
      BlocProvider.of<MedicationController>(context).loadMedications();
    }
  }

  void _navigateToEditMedication(
    BuildContext context,
    Medication medication,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => MedicationEditPage(medication: medication),
      ),
    );
    if (result == true && mounted) {
      BlocProvider.of<MedicationController>(context).loadMedications();
    }
  }

  void _deleteMedication(BuildContext context, Medication medication) {
    showDialog<void>(
      context: context,
      builder:
          (dialogContext) => Consumer<ThemeProvider>(
            builder: (consumerContext, themeProvider, child) {
              return AlertDialog(
                title: Text(
                  'Medikament löschen',
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
                content: Text(
                  'Möchtest du "${medication.name}" wirklich löschen?',
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
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
                          color: AppTheme.red,
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await BlocProvider.of<MedicationController>(
                              context,
                            ).deleteMedication(medication.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
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
                          fontSize: AppTheme.mainTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.primaryTextColor,
                        ),
                      ),
                      Text(
                        'Deine Medikamente',
                        style: TextStyle(
                          fontSize: AppTheme.sectionTitleFontSize,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.primaryTextColor,
                        ),
                      ),
                      Text(
                        'Übersicht aller Medikamente',
                        style: TextStyle(
                          fontSize: AppTheme.subtitleFontSize,
                          color: themeProvider.secondaryTextColor,
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
                              fontSize: AppTheme.subtitleFontSize,
                              color: themeProvider.secondaryTextColor,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: model.medications.length,
                        itemBuilder: (context, index) {
                          final medication = model.medications[index];
                          return MedicationItem(
                            medication: medication,
                            onTap:
                                () => _navigateToEditMedication(
                                  context,
                                  medication,
                                ),
                            showCompletedStyling: false,
                            trailingWidget: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppTheme.red,
                              ),
                              onPressed:
                                  () => _deleteMedication(context, medication),
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
      },
    );
  }
}
