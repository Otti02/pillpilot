import '../../controllers/base_controller.dart';
import '../../models/appointment_model.dart';
import '../../models/medication_model.dart';
import '../../models/home_state_model.dart';
import '../../services/appointment_service.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';
import '../../services/base_service.dart';
import '../../theme/app_strings.dart';

class HomeController extends BlocController<HomeState> {
  final MedicationService _medicationService;
  final AppointmentService _appointmentService;

  HomeController({MedicationService? medicationService, AppointmentService? appointmentService})
      : _medicationService = medicationService ?? ServiceProvider.instance.medicationService,
        _appointmentService = appointmentService ?? ServiceProvider.instance.appointmentService,
        super(HomeState.initial());

  @override
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    await Future.wait([
      loadMedications(),
      loadAppointments(),
    ]);
    emit(state.copyWith(isLoading: false));
  }

  @override
  void handleError(String message, [Object? error]) {
    String userMessage = message;
    if (error is NetworkException) {
      userMessage = AppStrings.networkError;
    } else if (error is ValidationException) {
      userMessage = AppStrings.validationError;
    } else if (error is AppException) {
      userMessage = error.message.isNotEmpty ? error.message : AppStrings.unknownError;
    } else {
      userMessage = AppStrings.unknownError;
    }
    emit(state.copyWith(isLoading: false, error: userMessage));
  }

  Future<void> loadMedications() async {
    try {
      final todayWeekday = DateTime.now().weekday;
      final allMedications = await _medicationService.getMedications();
      final todaysMedications = allMedications
          .where((medication) => medication.daysOfWeek.contains(todayWeekday))
          .toList();
      emit(state.copyWith(medications: todaysMedications));
    } catch (e) {
      handleError('Failed to load medications:  ${e.toString()}', e);
    }
  }

  Future<void> loadAppointments() async {
    try {
      final appointments = await _appointmentService.getAppointmentsForDate(DateTime.now());
      emit(state.copyWith(appointments: appointments));
    } catch (e) {
      handleError('Failed to load appointments:  ${e.toString()}', e);
    }
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    try {
      final medication = await _medicationService.getMedicationById(id);
      final updatedMedication = medication.copyWith(isCompleted: isCompleted);
      await _medicationService.updateMedication(updatedMedication);
      await loadMedications();
    } catch (e) {
      handleError('Failed to update medication:  ${e.toString()}', e);
    }
  }

  void setWelcomeMessage(String name) {
    emit(state.copyWith(welcomeMessage: name));
  }
}
