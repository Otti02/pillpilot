import '../../controllers/base_controller.dart';
import '../../models/appointment_model.dart';
import '../../models/medication_model.dart';
import '../../services/appointment_service.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';

class HomeController extends Controller implements InitializableController {
  void Function(String)? onUserInfoLoaded;
  void Function(String)? onError;
  void Function(List<Medication>)? onMedicationsLoaded;
  void Function(List<Appointment>)? onAppointmentsLoaded;


  final MedicationService _medicationService;
  final AppointmentService _appointmentService;

  HomeController({MedicationService? medicationService, AppointmentService? appointmentService,})
      : _medicationService = medicationService ?? ServiceProvider().medicationService,
        _appointmentService = appointmentService ?? ServiceProvider().appointmentService;

  @override
  Future<void> initialize() async {
    await Future.wait([
      loadMedications(),
      loadAppointments(),
    ]);
  }


  Future<void> loadMedications() async {
    try {
      final todayWeekday = DateTime.now().weekday;

      final allMedications = await _medicationService.getMedications();

      final todaysMedications = allMedications
          .where((medication) => medication.daysOfWeek.contains(todayWeekday))
          .toList();

      onMedicationsLoaded?.call(todaysMedications);
    } catch (e) {
      onError?.call('Failed to load medications: ${e.toString()}');
    }
  }


  Future<void> loadAppointments() async {
    try {
      final appointments = await _appointmentService.getAppointmentsForDate(DateTime.now());
      onAppointmentsLoaded?.call(appointments);
    } catch (e) {
      onError?.call('Failed to load appointments: ${e.toString()}');
    }
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    try {
      final medication = await _medicationService.getMedicationById(id);
      final updatedMedication = medication.copyWith(isCompleted: isCompleted);
      await _medicationService.updateMedication(updatedMedication);
      await loadMedications();
    } catch (e) {
      onError?.call('Failed to update medication: ${e.toString()}');
    }
  }

}
