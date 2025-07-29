import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../controllers/appointment/appointment_controller.dart';
import '../models/appointment_model.dart';
import '../models/appointment_state_model.dart';
import '../theme/app_theme.dart';
import '../widgets/appointment_item.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_calendar.dart';
import '../theme/app_strings.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _CalendarPageContent();
  }
}

class _CalendarPageContent extends StatefulWidget {
  @override
  State<_CalendarPageContent> createState() => _CalendarPageContentState();
}

class _CalendarPageContentState extends State<_CalendarPageContent> {
  DateTime _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadAppointments() {
    final controller = BlocProvider.of<AppointmentController>(context);
    controller.loadAppointmentsForDate(_selectedDate);
  }

  Future<void> _addAppointment(BuildContext context) async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.bitteGibEinenTitelEin)),
      );
      return;
    }

    try {
      final controller = BlocProvider.of<AppointmentController>(context);
      await controller.createAppointment(
        _titleController.text,
        _selectedDate,
        _selectedTime,
        notes: _notesController.text,
      );

      _titleController.clear();
      _notesController.clear();

      if (!mounted) return;

      Navigator.of(context).pop();

      _loadAppointments();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.terminErfolgreichErstellt)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.fehler}: $e')),
      );
    }
  }

  Future<void> _deleteAppointment(String id) async {
    try {
      final controller = BlocProvider.of<AppointmentController>(context);
      await controller.deleteAppointment(id);

      if (!mounted) return;
      _loadAppointments();

    } catch (e) {
      if (!mounted) return;
    }
  }

  void _showAddAppointmentDialog(BuildContext context) {
    _titleController.clear();
    _notesController.clear();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text(AppStrings.neuerTermin),
        contentPadding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '${AppStrings.datum}: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: AppStrings.titel,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final TimeOfDay? time = await showTimePicker(
                context: dialogContext,
                initialTime: _selectedTime,
                initialEntryMode: TimePickerEntryMode.input,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true,
                    ),
                    child: child!,
                  );
                  },
              );
              if (time != null && mounted) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: AppStrings.uhrzeit,
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedTime.format(dialogContext)),
                  const Icon(Icons.access_time),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: AppStrings.notizen,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                text: AppStrings.abbrechen,
              ),
              const SizedBox(width: 8),
              CustomButton(
                onPressed: () => _addAppointment(dialogContext),
                text: AppStrings.speichern,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(appointment.title),
        contentPadding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '${AppStrings.datum}: ${DateFormat('dd.MM.yyyy').format(appointment.date)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.uhrzeit}: ${appointment.time.format(dialogContext)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (appointment.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '${AppStrings.notizen}:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointment.notes),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: AppStrings.loeschen,
                color: Colors.red,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _deleteAppointment(appointment.id);
                },
              ),
              const SizedBox(width: 8),
              CustomButton(
                text: AppStrings.schliessen,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.kalender,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.planeDeineTermine,
                    style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    color: themeProvider.cardBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomCalendar(
                        initialDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                          _loadAppointments();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAppointmentsList(context, themeProvider),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddAppointmentDialog(context),
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsList(BuildContext context, ThemeProvider themeProvider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.termineAm} ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<AppointmentController, AppointmentModel>(
              builder: (context, model) {
                if (model.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (model.appointments.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.keineTermineAnDiesemTag,
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: model.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = model.appointments[index];
                    return AppointmentItem(
                      appointment: appointment,
                      onTap: () => _showAppointmentDetails(context, appointment),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}