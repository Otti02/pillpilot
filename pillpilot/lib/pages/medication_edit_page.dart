import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/medication/medication_controller.dart';
import '../models/medication_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_strings.dart';
import '../widgets/custom_text_field.dart';

class MedicationEditPage extends StatefulWidget {
  final Medication? medication;

  const MedicationEditPage({super.key, this.medication});

  @override
  State<MedicationEditPage> createState() => _MedicationEditPageState();
}

class _MedicationEditPageState extends State<MedicationEditPage> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();


  late TimeOfDay _selectedTime;
  final Set<int> _selectedDays = {};

  late final MedicationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = MedicationController();

    if (widget.medication != null) {
      _nameController.text = widget.medication!.name;
      _dosageController.text = widget.medication!.dosage;
      _notesController.text = widget.medication!.notes;
      _selectedTime = widget.medication!.time;
      _selectedDays.addAll(widget.medication!.daysOfWeek);
    } else {
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMedication() async {
    if (_nameController.text.isEmpty) {
      _showError(AppStrings.bitteGibEinenNamenEin);
      return;
    }
    if (_dosageController.text.isEmpty) {
      _showError(AppStrings.bitteGibEineDosierungEin);
      return;
    }
    if (_selectedDays.isEmpty) {
      _showError(AppStrings.bitteWaehleMindestensEinenWochentagAus);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.medication == null) {
        await _controller.createMedication(
          _nameController.text,
          _dosageController.text,
          _selectedTime,
          _selectedDays.toList(),
          notes: _notesController.text,
        );
      } else {
        final updatedMedication = widget.medication!.copyWith(
          name: _nameController.text,
          dosage: _dosageController.text,
          time: _selectedTime,
          daysOfWeek: _selectedDays.toList(),
          notes: _notesController.text,
        );
        await _controller.updateMedication(updatedMedication);
      }

      if (mounted) {
        final message = widget.medication == null ? AppStrings.medikamentErstellt : AppStrings.medikamentAktualisiert;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Fehler: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.red),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
          initialEntryMode: TimePickerEntryMode.input,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          setState(() => _selectedTime = pickedTime);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Uhrzeit',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedTime.format(context)),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    final weekdays = AppTheme.weekdays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Einnahmetage', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppTheme.smallPadding),
        Wrap(
          spacing: AppTheme.smallPadding,
          runSpacing: AppTheme.smallPadding,
          children: weekdays.entries.map((entry) {
            final isSelected = _selectedDays.contains(entry.key);
            return FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(entry.key);
                  } else {
                    _selectedDays.remove(entry.key);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: AppTheme.white,
              labelStyle: TextStyle(color: isSelected ? AppTheme.white : AppTheme.primaryTextColor),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medication != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.medikamentBearbeiten : AppStrings.neuesMedikament),
        backgroundColor: AppTheme.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: AppStrings.name,
                hint: AppStrings.zB,
                controller: _nameController,
              ),
              const SizedBox(height: AppTheme.smallPadding),
              CustomTextField(
                label: AppStrings.dosierung,
                hint: AppStrings.zB,
                controller: _dosageController,
              ),
              const SizedBox(height: AppTheme.smallPadding),

              _buildTimePicker(),
              const SizedBox(height: AppTheme.largePadding),
              _buildWeekdaySelector(),
              const SizedBox(height: AppTheme.smallPadding),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedDays.length == AppTheme.daysInWeek) {
                        _selectedDays.clear();
                      } else {
                        _selectedDays.clear();
                        _selectedDays.addAll([1, 2, 3, 4, 5, 6, 7]);
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
                    ),
                  ),
                  child: Text(AppStrings.alleTageAuswaehlen),
                ),
              ),
              const SizedBox(height: AppTheme.largePadding),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: AppStrings.notizenOptional,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.iconCircleSize),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMedication,
                  child: Text(isEditing ? AppStrings.aktualisieren : AppStrings.speichern),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

