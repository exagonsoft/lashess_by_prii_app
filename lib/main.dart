import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lashess_by_prii_app/styles/theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'views/splash_screen.dart';
import 'views/auth_screen.dart';
import 'views/home_screen.dart';
import 'providers/user_provider.dart';
import 'controllers/main_controller.dart';
import 'repositories/events_repository.dart';
import 'repositories/offers_repository.dart';
import 'repositories/styles_repository.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => MainController(
            eventsRepository: EventsRepository(),
            offersRepository: OffersRepository(),
            stylesRepository: StylesRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Lashess by Prii',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  ],
);
