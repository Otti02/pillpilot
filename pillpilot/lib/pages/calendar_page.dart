import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../controllers/appointment/appointment_controller.dart';
import '../models/appointment_model.dart';
import '../models/appointment_state_model.dart';
import '../theme/app_theme.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

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
        const SnackBar(content: Text('Bitte gib einen Titel ein')),
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Termin erfolgreich erstellt')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen des Termins: $e')),
      );
    }
  }

  Future<void> _deleteAppointment(String id) async {
    try {
      final controller = BlocProvider.of<AppointmentController>(context);
      await controller.deleteAppointment(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Termin erfolgreich gelöscht')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen des Termins: $e')),
      );
    }
  }

  void _showAddAppointmentDialog(BuildContext context) {
    _titleController.clear();
    _notesController.clear();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Neuer Termin'),
        contentPadding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Datum: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titel',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final TimeOfDay? time = await showTimePicker(
                context: dialogContext,
                initialTime: _selectedTime,
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
                labelText: 'Uhrzeit',
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
              labelText: 'Notizen',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Abbrechen'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addAppointment(dialogContext),
                child: const Text('Speichern'),
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
            'Datum: ${DateFormat('dd.MM.yyyy').format(appointment.date)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Uhrzeit: ${appointment.time.format(dialogContext)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (appointment.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Notizen:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointment.notes),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _deleteAppointment(appointment.id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Löschen'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kalender',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Plane deine Termine',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildSimpleCalendar(context),
              const SizedBox(height: 16),
              _buildAppointmentsList(context),
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
  }

  Widget _buildSimpleCalendar(BuildContext context) {
    final DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);

    final DateTime lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    int firstWeekdayOfMonth = firstDayOfMonth.weekday - 1;
    if (firstWeekdayOfMonth == -1) firstWeekdayOfMonth = 6;

    final int daysInMonth = lastDayOfMonth.day;

    final int totalDays = firstWeekdayOfMonth + daysInMonth;
    final int numberOfRows = (totalDays / 7).ceil();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      // Move to previous month
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month - 1,
                        min(_selectedDate.day, DateTime(_selectedDate.year, _selectedDate.month, 0).day),
                      );
                    });
                    _loadAppointments();
                  },
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    DateFormat('MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      // Move to next month
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month + 1,
                        min(_selectedDate.day, DateTime(_selectedDate.year, _selectedDate.month + 2, 0).day),
                      );
                    });
                    _loadAppointments();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Day of week headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (String day in ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'])
                  SizedBox(
                    width: 30,
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Calendar grid
            for (int row = 0; row < numberOfRows; row++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int col = 0; col < 7; col++) 
                      _buildMonthDayButton(context, row, col, firstWeekdayOfMonth, daysInMonth),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDayButton(BuildContext context, int row, int col, int firstWeekdayOfMonth, int daysInMonth) {
    // Calculate the day number (1-based)
    final int dayNumber = row * 7 + col + 1 - firstWeekdayOfMonth;

    // Check if the day is within the current month
    final bool isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;

    if (!isCurrentMonth) {
      // Return an empty container for days outside the current month
      return Container(
        width: 30,
        height: 30,
      );
    }

    // Create a DateTime for this day
    final DateTime day = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      dayNumber,
    );

    // Check if this is the selected day
    final bool isSelected = day.day == _selectedDate.day && 
                           day.month == _selectedDate.month && 
                           day.year == _selectedDate.year;

    // Check if this is today
    final DateTime now = DateTime.now();
    final bool isToday = day.day == now.day && 
                         day.month == now.month && 
                         day.year == now.year;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = day;
        });
        _loadAppointments();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected 
              ? AppTheme.primaryColor 
              : isToday 
                  ? AppTheme.primaryColor.withOpacity(0.3) 
                  : Colors.transparent,
        ),
        child: Center(
          child: Text(
            dayNumber.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected 
                  ? Colors.white 
                  : isToday 
                      ? AppTheme.primaryColor 
                      : AppTheme.primaryTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Termine am ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                  return const Center(child: Text('Keine Termine an diesem Tag'));
                }
                
                return ListView.builder(
                  itemCount: model.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = model.appointments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(appointment.title),
                        subtitle: Text(appointment.time.format(context)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showAppointmentDetails(context, appointment),
                      ),
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