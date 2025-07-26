import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import 'services/service_provider.dart';
import 'controllers/medication/medication_controller.dart';
import 'controllers/appointment/appointment_controller.dart';
import 'controllers/lexicon/lexicon_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await ServiceProvider().initialize();

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
            medicationService: ServiceProvider().medicationService,
          )..initialize(),
        ),
        BlocProvider<AppointmentController>(
          create: (context) => AppointmentController(
            appointmentService: ServiceProvider().appointmentService,
          )..initialize(),
        ),
        BlocProvider<LexiconController>(
          create: (context) => LexiconController(
            lexiconService: ServiceProvider().lexiconService,
          )..initialize(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pill Pilot',
        theme: AppTheme.themeData,
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
      ),
    );
  }
}
