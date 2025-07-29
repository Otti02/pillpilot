import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home/home_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/appointment_item.dart';
import '../widgets/medication_item.dart';
import '../models/medication_model.dart';
import '../models/appointment_model.dart';
import '../theme/app_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  String _welcomeMessage = '';
  List<Medication> _medications = [];
  List<Appointment> _todayAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();

    _controller.onUserInfoLoaded = _showUserInfo;
    _controller.onError = _showError;
    _controller.onMedicationsLoaded = _showMedications;
    _controller.onAppointmentsLoaded = _showAppointments;

    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showUserInfo(String name) {
    setState(() => _welcomeMessage = name);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() => _isLoading = false);
  }

  void _showMedications(List<Medication> medications) {
    setState(() => _medications = medications);
  }

  void _showAppointments(List<Appointment> appointments) {
    setState(() {
      _todayAppointments = appointments;
      _isLoading = false;
    });
  }

  void _reloadData() {
    _controller.loadMedications();
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void _toggleMedicationCompletion(Medication medication) {
    _controller.toggleMedicationCompletion(
      medication.id,
      !medication.isCompleted,
    );
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
              if (appointment.notes.isNotEmpty) ...[
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
                        appointment.notes,
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
                AppStrings.schliessen,
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
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
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
                    AppStrings.deineEinnahmenHeute,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  if (_welcomeMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppTheme.smallPadding),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _medications.isEmpty
                        ? _buildEmptyState(AppStrings.keineMedikamenteVorhanden)
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _medications.length,
                      itemBuilder: (context, index) {
                        final medication = _medications[index];
                        return MedicationItem(
                          medication: medication,
                          onToggle: () => _toggleMedicationCompletion(medication),
                          onDataChanged: _reloadData,
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.largePadding),
                    _buildSectionTitle(AppStrings.heutigeTermine),
                    _todayAppointments.isEmpty
                        ? _buildEmptyState(AppStrings.keineTermineFuerHeute)
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _todayAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _todayAppointments[index];
                        return AppointmentItem(
                          appointment: appointment,
                          onTap: () => _showAppointmentDetails(appointment),
                        );
                      },
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryTextColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.defaultPadding),
        child: Text(
          message,
          style: TextStyle(fontSize: 16, color: AppTheme.secondaryTextColor),
        ),
      ),
    );
  }
}
