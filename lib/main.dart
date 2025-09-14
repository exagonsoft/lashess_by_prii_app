import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lashess_by_prii_app/firebase_options.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/providers/theme_mode_provider.dart';
import 'package:lashess_by_prii_app/repositories/services_repository.dart';
import 'package:lashess_by_prii_app/routes/app-routes.dart';
import 'package:provider/provider.dart';
import 'styles/theme.dart';
import 'providers/user_provider.dart';
import 'controllers/main_controller.dart';
import 'repositories/events_repository.dart';
import 'repositories/offers_repository.dart';
import 'repositories/styles_repository.dart';
import 'providers/locale_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'utils/firebase_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup FCM background handler + local notifications
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Pass a callback for navigation
  await setupFlutterNotifications();
  await FirebaseMessaging.instance.requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // ✅ Now handles FCM token sync
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(
          create: (_) => MainController(
            eventsRepository: EventsRepository(),
            offersRepository: OffersRepository(),
            stylesRepository: StylesRepository(),
            servicesRepository: ServicesRepository(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<LocaleProvider, ThemeModeProvider>(
        builder: (context, localeProvider, themeModeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Lashess by Prii',
            themeMode: themeModeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}
