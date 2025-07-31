import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';

class AppointmentDetailsDialog extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AppointmentDetailsDialog({
    super.key,
    required this.appointment,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Datum: ${DateFormat('dd.MM.yyyy').format(appointment.date)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Uhrzeit: ${appointment.time.format(context)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (appointment.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Notizen:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(appointment.notes),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  tooltip: 'Löschen',
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onEdit();
                  },
                  icon: const Icon(Icons.edit, size: 32),
                  tooltip: 'Bearbeiten',
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
