import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/home/home_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/appointment_item.dart';
import '../widgets/medication_item.dart';
import '../models/medication_model.dart';
import '../models/appointment_model.dart';
import '../theme/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/home_state_model.dart';
import '../controllers/appointment/appointment_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/appointment_details_dialog.dart';
import '../widgets/edit_appointment_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        duration: const Duration(seconds: AppTheme.snackBarDuration),
      ),
    );
  }

  Future<void> _deleteAppointment(String id) async {
    try {
      final controller = BlocProvider.of<AppointmentController>(context);
      await controller.deleteAppointment(id);

      if (!mounted) return;
      _reloadData();

    } catch (e) {
      if (!mounted) return;
    }
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (dialogContext) => AppointmentDetailsDialog(
        appointment: appointment,
        onDelete: () => _deleteAppointment(appointment.id),
        onEdit: () => _showEditAppointmentDialog(context, appointment),
      ),
    );
  }

  void _showEditAppointmentDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditAppointmentDialog(
        appointment: appointment,
        onAppointmentUpdated: () {
          _reloadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      bloc: _controller,
      builder: (context, state) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Scaffold(
              backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppTheme.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getCurrentTime(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.primaryTextColor,
                                  ),
                                ),
                                Text(
                                  AppStrings.deineEinnahmenHeute,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: themeProvider.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Theme toggle switch
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return Row(
                                children: [
                                  Icon(
                                    themeProvider.isDarkMode 
                                        ? Icons.dark_mode 
                                        : Icons.light_mode,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: AppTheme.smallPadding),
                                  Switch(
                                    value: themeProvider.isDarkMode,
                                    onChanged: (value) {
                                      themeProvider.toggleTheme();
                                    },
                                    activeColor: AppTheme.primaryColor,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      if (state.welcomeMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppTheme.smallPadding),
                          child: Text(
                            state.welcomeMessage,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.secondaryTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.medications.isEmpty
                                  ? _buildEmptyState(AppStrings.keineMedikamenteVorhanden)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.medications.length,
                                      itemBuilder: (context, index) {
                                        final medication = state.medications[index];
                                        return MedicationItem(
                                          medication: medication,
                                          onToggle: () => _toggleMedicationCompletion(medication),
                                          onDataChanged: _reloadData,
                                        );
                                      },
                                    ),
                              const SizedBox(height: AppTheme.largePadding),
                              _buildSectionTitle(AppStrings.heutigeTermine),
                              state.appointments.isEmpty
                                  ? _buildEmptyState(AppStrings.keineTermineFuerHeute)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.appointments.length,
                                      itemBuilder: (context, index) {
                                        final appointment = state.appointments[index];
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
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.defaultPadding),
                    child: Text(
                      state.error!,
                      style: TextStyle(color: AppTheme.red),
                    ),
                  ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.defaultPadding),
            child: Text(
              message,
              style: TextStyle(fontSize: 16, color: themeProvider.secondaryTextColor),
            ),
          ),
        );
      },
    );
  }
}
