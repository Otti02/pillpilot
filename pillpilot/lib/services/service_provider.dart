import 'base_service.dart';
import 'medication_service.dart';
import 'lexicon_service.dart';
import 'appointment_service.dart';
import 'notification_service.dart';

/// Dependency Injection Container for managing service instances
class ServiceProvider {
  static ServiceProvider? _instance;
  
  // Services
  late final PersistenceService _persistenceService;
  late final MedicationService _medicationService;
  late final LexiconService _lexiconService;
  late final AppointmentService _appointmentService;
  late final NotificationService _notificationService;

  /// Private constructor for singleton pattern
  ServiceProvider._();

  /// Get the singleton instance
  static ServiceProvider get instance {
    _instance ??= ServiceProvider._();
    return _instance!;
  }

  /// Initialize all services with proper dependency injection
  Future<void> initialize() async {
    // Initialize persistence service first
    _persistenceService = HivePersistenceService();
    await _persistenceService.initialize();

    // Initialize other services with dependencies
    _medicationService = MedicationServiceImpl(_persistenceService);
    _lexiconService = LexiconServiceImpl(_persistenceService);
    _appointmentService = AppointmentServiceImpl(_persistenceService);
    _notificationService = NotificationServiceImpl();
    await _notificationService.initialize();
  }

  /// Reset the singleton instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  // Getters for services
  PersistenceService get persistenceService => _persistenceService;
  MedicationService get medicationService => _medicationService;
  LexiconService get lexiconService => _lexiconService;
  AppointmentService get appointmentService => _appointmentService;
  NotificationService get notificationService => _notificationService;
}
