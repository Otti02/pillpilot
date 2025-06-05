import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/home/home_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/medication_item.dart';
import '../../models/medication_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  String _welcomeMessage = '';
  List<Medication> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();

    _controller.onUserInfoLoaded = _showUserInfo;
    _controller.onError = _showError;
    _controller.onMedicationsLoaded = _showMedications;

    _controller.initialize();
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
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
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
      !medication.isCompleted
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
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _medications.isEmpty
                  ? Center(
                      child: Text(
                        'Keine Medikamente vorhanden',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _medications.length,
                      itemBuilder: (context, index) {
                        final medication = _medications[index];
                        return MedicationItem(
                          medicationName: medication.name,
                          dosage: medication.dosage,
                          timeOfDay: medication.timeOfDay,
                          isCompleted: medication.isCompleted,
                          notes: medication.notes,
                          onToggle: () => _toggleMedicationCompletion(medication),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
