import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../controllers/appointment/appointment_controller.dart';

import '../widgets/custom_button.dart';

class EditAppointmentDialog extends StatefulWidget {
  final Appointment appointment;
  final VoidCallback onAppointmentUpdated;

  const EditAppointmentDialog({
    super.key,
    required this.appointment,
    required this.onAppointmentUpdated,
  });

  @override
  State<EditAppointmentDialog> createState() => _EditAppointmentDialogState();
}

class _EditAppointmentDialogState extends State<EditAppointmentDialog> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  late TimeOfDay _selectedTime;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.appointment.title;
    _notesController.text = widget.appointment.notes;
    _selectedTime = widget.appointment.time;
    _selectedDate = widget.appointment.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateAppointment() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib einen Titel ein')),
      );
      return;
    }

    try {
      final controller = BlocProvider.of<AppointmentController>(context);
      final updatedAppointment = widget.appointment.copyWith(
        title: _titleController.text,
        date: _selectedDate,
        time: _selectedTime,
        notes: _notesController.text,
      );

      await controller.updateAppointment(updatedAppointment);

      if (!mounted) return;

      Navigator.of(context).pop();
      widget.onAppointmentUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Termin erfolgreich aktualisiert')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Termin bearbeiten'),
      contentPadding: const EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Titel',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Datum',
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
              initialEntryMode: TimePickerEntryMode.input,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (time != null) {
              setState(() {
                _selectedTime = time;
              });
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
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notizen',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Abbrechen',
            ),
            const SizedBox(width: 8),
            CustomButton(onPressed: _updateAppointment, text: 'Speichern'),
          ],
        ),
      ],
    );
  }
}
