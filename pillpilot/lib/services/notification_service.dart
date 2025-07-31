import '../models/medication_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleMedicationNotification({required Medication medication});
  Future<void> cancelMedicationNotifications(String medicationId);
  Future<void> cancelAllNotifications();
}

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationServiceImpl._internal();

  static final NotificationServiceImpl _instance =
      NotificationServiceImpl._internal();
  factory NotificationServiceImpl() => _instance;

  @override
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {}

  @override
  Future<void> scheduleMedicationNotification({
    required Medication medication,
  }) async {
    await cancelMedicationNotifications(medication.id);

    for (int dayNumber in medication.daysOfWeek) {
      final int notificationId =
          (medication.id.hashCode.abs() % 1000000) * 10 + dayNumber;

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        medication.time.hour,
        medication.time.minute,
      );

      while (scheduledDate.weekday != dayNumber ||
          scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        '${medication.name} - Erinnerung',
        'Zeit für deine Dosis von ${medication.dosage}!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_channel',
            'Medikamentenerinnerungen',
            channelDescription: 'Erinnert Sie an die Einnahme von Medikamenten',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: medication.id,
      );
    }
  }

  @override
  Future<void> cancelMedicationNotifications(String medicationId) async {
    await Future.wait([
      for (int i = 1; i <= 7; i++)
        _flutterLocalNotificationsPlugin.cancel(
          (medicationId.hashCode.abs() % 1000000) * 10 + i,
        ),
    ]);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
