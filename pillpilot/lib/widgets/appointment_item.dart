import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';

class AppointmentItem extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentItem({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.event_available, // Ein passenderes Icon
          color: AppTheme.primaryColor,
        ),
        title: Text(appointment.title),
        subtitle: Text(appointment.time.format(context)),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}
