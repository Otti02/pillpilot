import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import '../services/service_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppointmentService _appointmentService;
  List<Appointment> _todayAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _appointmentService = ServiceProvider().appointmentService;
    _loadTodayAppointments();
  }

  Future<void> _loadTodayAppointments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appointments = await _appointmentService.getAppointmentsForDate(DateTime.now());

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Pill Pilot',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Heutige Termine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todayAppointments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Keine Termine für heute'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _todayAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = _todayAppointments[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(appointment.title),
                              subtitle: Text(appointment.time.format(context)),
                              leading: Icon(
                                Icons.event,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
