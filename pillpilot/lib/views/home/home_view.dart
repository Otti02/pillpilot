import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/home/home_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/medication_item.dart';
import '../../models/medication_model.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';
import '../../services/service_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  late final AppointmentService _appointmentService;
  String _welcomeMessage = '';
  List<Medication> _medications = [];
  List<Appointment> _todayAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _appointmentService = ServiceProvider().appointmentService;

    _controller.onUserInfoLoaded = _showUserInfo;
    _controller.onError = _showError;
    _controller.onMedicationsLoaded = _showMedications;

    _controller.initialize();
    _loadTodayAppointments();
  }

  Future<void> _loadTodayAppointments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appointments = await _appointmentService.getAppointmentsForDate(
        DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _todayAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Termine: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showUserInfo(String name) {
    setState(() {
      _welcomeMessage = name;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _showMedications(List<Medication> medications) {
    setState(() {
      _medications = medications;
      _isLoading = false;
    });
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void _toggleMedicationCompletion(Medication medication) async {
    await _controller.toggleMedicationCompletion(
      medication.id,
      !medication.isCompleted,
    );

    // Show a notification when medication status changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !medication.isCompleted
              ? '${medication.name} als eingenommen markiert'
              : '${medication.name} als nicht eingenommen markiert',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildAppointmentItem(Appointment appointment) {
    return InkWell(
      onTap: () => _showAppointmentDetails(appointment),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.event,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormat('HH:mm').format(appointment.dateTime),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                        Text(
                          ' | ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            appointment.notes!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              Icon(
                Icons.info_outline,
                color: AppTheme.secondaryTextColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.event,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  appointment.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm').format(appointment.dateTime),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note,
                      color: AppTheme.secondaryTextColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Schließen',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
                    'Deine Einnahmen Heute',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Übersicht aller heutigen Einnahmen',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  if (_welcomeMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _welcomeMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medications section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Deine Medikamente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _medications.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Keine Medikamente vorhanden',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ),
                    )
                        : Container(
                      height: 200, // Fixed height for medications list
                      child: ListView.builder(
                        itemCount: _medications.length,
                        itemBuilder: (context, index) {
                          final medication = _medications[index];
                          return MedicationItem(
                            medicationName: medication.name,
                            dosage: medication.dosage,
                            timeOfDay: medication.timeOfDay,
                            isCompleted: medication.isCompleted,
                            notes: medication.notes,
                            onToggle:
                                () =>
                                _toggleMedicationCompletion(medication),
                          );
                        },
                      ),
                    ),

                    // Today's appointments section
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Heutige Termine',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _todayAppointments.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Keine Termine für heute',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ),
                    )
                        : Container(
                      height: 200, // Fixed height for appointments list
                      child: ListView.builder(
                        itemCount: _todayAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = _todayAppointments[index];
                          return _buildAppointmentItem(appointment);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}