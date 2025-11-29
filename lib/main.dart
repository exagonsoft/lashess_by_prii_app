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

  // Top-level background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Init notification system with a navigator callback
  await setupFlutterNotifications(
    onTapData: (data) {
      // Prefer routeName + params if provided
      final routeName = data['routeName'];
      final id = data['id'];
      final route = data['route'];

      if (routeName == 'offer-details' && id != null && id is String) {
        router.pushNamed(
          'offer-details',
          pathParameters: {'id': id},
        );
      } else if (route is String && route.isNotEmpty) {
        router.go(route); // works if you sent '/offer-details/:id'
      }
    },
  );

  // (Optional) cold start tap
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // Delay to ensure router is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = initialMessage.data;
      final routeName = data['routeName'];
      final id = data['id'];
      final route = data['route'];
      if (routeName == 'offer-details' && id != null && id is String) {
        router.pushNamed(
          'offer-details',
          pathParameters: {'id': id},
        );
      } else if (route is String && route.isNotEmpty) {
        router.go(route);
      }
    });
  }

  // Permissions + topic
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.subscribeToTopic("offers");

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
