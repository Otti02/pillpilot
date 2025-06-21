import 'auth_service.dart';
import 'base_service.dart';
import 'medication_service.dart';
import 'lexicon_service.dart';
import 'appointment_service.dart';

/// Service provider for dependency injection.
///
/// Provides centralized access to all services in the application.
class ServiceProvider {
  /// Singleton instance of the service provider.
  static final ServiceProvider _instance = ServiceProvider._internal();

  /// Factory constructor that returns the singleton instance.
  factory ServiceProvider() {
    return _instance;
  }

  /// Internal constructor.
  ServiceProvider._internal();

  /// Authentication service instance.
  late final AuthService _authService;

  /// Persistence service instance.
  late final PersistenceService _persistenceService;

  /// Medication service instance.
  late final MedicationService _medicationService;

  /// Lexicon service instance.
  late final LexiconService _lexiconService;

  /// Appointment service instance.
  late final AppointmentService _appointmentService;

  /// Initializes all services.
  ///
  /// Must be called before using any services.
  Future<void> initialize() async {
    // Initialize persistence service
    _persistenceService = ServiceFactory().getPersistenceService();

    // Initialize Hive
    if (_persistenceService is HivePersistenceService) {
      await (_persistenceService as HivePersistenceService).initialize();
    }

    // Initialize other services
    _authService = AuthServiceImpl();
    _medicationService = MedicationServiceImpl();
    _lexiconService = LexiconServiceImpl();
    _appointmentService = AppointmentServiceImpl();
  }

  /// Returns the authentication service.
  AuthService get authService => _authService;

  /// Returns the persistence service.
  PersistenceService get persistenceService => _persistenceService;

  /// Returns the medication service.
  MedicationService get medicationService => _medicationService;

  /// Returns the lexicon service.
  LexiconService get lexiconService => _lexiconService;

  /// Returns the appointment service.
  AppointmentService get appointmentService => _appointmentService;
}
