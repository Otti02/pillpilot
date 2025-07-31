import 'base_service.dart';
import 'medication_service.dart';
import 'lexicon_service.dart';
import 'appointment_service.dart';
import 'notification_service.dart';

class ServiceProvider {
  static ServiceProvider? _instance;

  late final PersistenceService _persistenceService;
  late final MedicationService _medicationService;
  late final LexiconService _lexiconService;
  late final AppointmentService _appointmentService;
  late final NotificationService _notificationService;

  ServiceProvider._();

  static ServiceProvider get instance {
    _instance ??= ServiceProvider._();
    return _instance!;
  }

  Future<void> initialize() async {
    _persistenceService = HivePersistenceService();
    await _persistenceService.initialize();

    _medicationService = MedicationServiceImpl(_persistenceService);
    _lexiconService = LexiconServiceImpl(_persistenceService);
    _appointmentService = AppointmentServiceImpl(_persistenceService);
    _notificationService = NotificationServiceImpl();
    await _notificationService.initialize();
  }

  static void reset() {
    _instance = null;
  }

  PersistenceService get persistenceService => _persistenceService;
  MedicationService get medicationService => _medicationService;
  LexiconService get lexiconService => _lexiconService;
  AppointmentService get appointmentService => _appointmentService;
  NotificationService get notificationService => _notificationService;
}
