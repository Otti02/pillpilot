import 'base_service.dart';
import 'medication_service.dart';
import 'lexicon_service.dart';
import 'appointment_service.dart';
import 'notification_service.dart';


class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() {
    return _instance;
  }

  ServiceProvider._internal();

  late final PersistenceService _persistenceService;

  late final MedicationService _medicationService;

  late final LexiconService _lexiconService;

  late final AppointmentService _appointmentService;

  late final NotificationService _notificationService;

  Future<void> initialize() async {
    _persistenceService = ServiceFactory().getPersistenceService();

    if (_persistenceService is HivePersistenceService) {
      await (_persistenceService).initialize();
    }

    _medicationService = MedicationServiceImpl();
    _lexiconService = LexiconServiceImpl();
    _appointmentService = AppointmentServiceImpl();
    _notificationService = NotificationServiceImpl();
    await _notificationService.initialize();
  }


  PersistenceService get persistenceService => _persistenceService;

  MedicationService get medicationService => _medicationService;

  LexiconService get lexiconService => _lexiconService;

  AppointmentService get appointmentService => _appointmentService;

  NotificationService get notificationService => _notificationService;
}
