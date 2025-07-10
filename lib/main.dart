import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/providers/theme_mode_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'styles/theme.dart';
import 'views/splash_screen.dart';
import 'views/auth_screen.dart';
import 'views/home_screen.dart';
import 'providers/user_provider.dart';
import 'controllers/main_controller.dart';
import 'repositories/events_repository.dart';
import 'repositories/offers_repository.dart';
import 'repositories/styles_repository.dart';
import 'providers/locale_provider.dart'; // ✅ Create this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(
          create: (_) => MainController(
            eventsRepository: EventsRepository(),
            offersRepository: OffersRepository(),
            stylesRepository: StylesRepository(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // ✅ Locale
      ],
      child: Consumer2<LocaleProvider, ThemeModeProvider>(
        builder: (context, localeProvider, themeModeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Lashess by Prii',
            themeMode: themeModeProvider.themeMode,
            theme: AppTheme.lightTheme,// 🔥 controlled dynamically
            darkTheme: AppTheme.darkTheme,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);
