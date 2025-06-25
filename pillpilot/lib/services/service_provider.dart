import 'auth_service.dart';
import 'base_service.dart';
import 'medication_service.dart';
import 'lexicon_service.dart';
import 'appointment_service.dart';


class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() {
    return _instance;
  }

  ServiceProvider._internal();

  late final AuthService _authService;

  late final PersistenceService _persistenceService;

  late final MedicationService _medicationService;

  late final LexiconService _lexiconService;

  late final AppointmentService _appointmentService;

  Future<void> initialize() async {
    _persistenceService = ServiceFactory().getPersistenceService();

    if (_persistenceService is HivePersistenceService) {
      await (_persistenceService).initialize();
    }

    _authService = AuthServiceImpl();
    _medicationService = MedicationServiceImpl();
    _lexiconService = LexiconServiceImpl();
    _appointmentService = AppointmentServiceImpl();
  }

  AuthService get authService => _authService;

  PersistenceService get persistenceService => _persistenceService;

  MedicationService get medicationService => _medicationService;

  LexiconService get lexiconService => _lexiconService;

  AppointmentService get appointmentService => _appointmentService;
}
