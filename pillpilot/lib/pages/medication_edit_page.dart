import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/medication/medication_controller.dart';
import '../models/medication_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';

class MedicationEditPage extends StatefulWidget {
  final Medication? medication;

  const MedicationEditPage({Key? key, this.medication}) : super(key: key);

  @override
  State<MedicationEditPage> createState() => _MedicationEditPageState();
}

class _MedicationEditPageState extends State<MedicationEditPage> {
  // No form key needed for manual validation
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeOfDayController = TextEditingController();
  final _notesController = TextEditingController();

  late final MedicationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = MedicationController();

    // If editing an existing medication, populate the form
    if (widget.medication != null) {
      _nameController.text = widget.medication!.name;
      _dosageController.text = widget.medication!.dosage;
      _timeOfDayController.text = widget.medication!.timeOfDay;
      _notesController.text = widget.medication!.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeOfDayController.dispose();
    _notesController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  Future<void> _saveMedication() async {
    // Manual validation
    bool isValid = true;
    String errorMessage = '';

    if (_nameController.text.isEmpty) {
      isValid = false;
      errorMessage = 'Bitte gib einen Namen ein';
    } else if (_dosageController.text.isEmpty) {
      isValid = false;
      errorMessage = 'Bitte gib eine Dosierung ein';
    } else if (_timeOfDayController.text.isEmpty) {
      isValid = false;
      errorMessage = 'Bitte gib eine Einnahmezeit ein';
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.medication == null) {
        // Create new medication
        await _controller.createMedication(
          _nameController.text,
          _dosageController.text,
          _timeOfDayController.text,
          notes: _notesController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medikament erstellt')),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Update existing medication
        final updatedMedication = widget.medication!.copyWith(
          name: _nameController.text,
          dosage: _dosageController.text,
          timeOfDay: _timeOfDayController.text,
          notes: _notesController.text,
        );

        await _controller.updateMedication(updatedMedication);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medikament aktualisiert')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medication != null;

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                          isEditing ? 'Medikament bearbeiten' : 'Neues Medikament',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        Text(
                          isEditing ? 'Aktualisiere die Medikamentendetails' : 'Füge ein neues Medikament hinzu',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form fields
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Field
                          CustomTextField(
                            label: 'Name',
                            hint: 'z.B. Ibuprofen',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),

                          // Dosage Field
                          CustomTextField(
                            label: 'Dosierung',
                            hint: 'z.B. 200mg',
                            controller: _dosageController,
                          ),
                          const SizedBox(height: 16),

                          // Time of Day Field
                          CustomTextField(
                            label: 'Einnahmezeit',
                            hint: 'z.B. Morgens',
                            controller: _timeOfDayController,
                          ),
                          const SizedBox(height: 16),

                          // Notes Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notizen',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextField(
                                  controller: _notesController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: 'Zusätzliche Informationen zum Medikament',
                                    hintStyle: TextStyle(color: Colors.grey.shade500),
                                    contentPadding: const EdgeInsets.all(16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveMedication,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                isEditing ? 'Aktualisieren' : 'Erstellen',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
