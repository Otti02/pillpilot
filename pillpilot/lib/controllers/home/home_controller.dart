import '../../controllers/base_controller.dart';
import '../../models/medication_model.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';

class HomeController extends Controller implements InitializableController {
  void Function(String)? onUserInfoLoaded;
  void Function(String)? onError;
  void Function(List<Medication>)? onMedicationsLoaded;

  final MedicationService _medicationService;

  HomeController({MedicationService? medicationService})
      : _medicationService = medicationService ?? ServiceProvider().medicationService;

  @override
  Future<void> initialize() async {
    _loadUserInfo();
    loadMedications();
  }

  void _loadUserInfo() {
    try {
      onUserInfoLoaded?.call('Welcome to Pill Pilot');
    } catch (e) {
      onError?.call('Failed to load user info: ${e.toString()}');
    }
  }

  Future<void> loadMedications() async {
    try {
      final medications = await _medicationService.getMedications();
      onMedicationsLoaded?.call(medications);
    } catch (e) {
      onError?.call('Failed to load medications: ${e.toString()}');
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
