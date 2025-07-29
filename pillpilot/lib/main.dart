import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import 'services/service_provider.dart';
import 'controllers/medication/medication_controller.dart';
import 'controllers/appointment/appointment_controller.dart';
import 'controllers/lexicon/lexicon_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();

  // Initialize services
  await ServiceProvider.instance.initialize();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.instance.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicationController>(
          create: (context) => MedicationController(
            medicationService: ServiceProvider.instance.medicationService,
              notificationService: ServiceProvider.instance.notificationService,
          )..initialize(),
        ),
        BlocProvider<AppointmentController>(
          create: (context) => AppointmentController(
            appointmentService: ServiceProvider.instance.appointmentService,
          )..initialize(),
        ),
        BlocProvider<LexiconController>(
          create: (context) => LexiconController(
            lexiconService: ServiceProvider.instance.lexiconService,
          )..initialize(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              title: 'Pill Pilot',
              theme: themeProvider.theme,
              routerConfig: router,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('de', ''),
                Locale('en', ''),
              ],
              locale: const Locale('de'),
            );
          },
        ),
      ),
    );
  }
}
