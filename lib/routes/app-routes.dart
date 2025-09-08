import 'package:go_router/go_router.dart';
import 'package:lashess_by_prii_app/views/auth_screen.dart';
import 'package:lashess_by_prii_app/views/business_info_screen.dart';
import 'package:lashess_by_prii_app/views/forgot_password_screen.dart';
import 'package:lashess_by_prii_app/views/map_screen.dart';
import 'package:lashess_by_prii_app/views/payment_screen.dart';
import 'package:lashess_by_prii_app/views/profile_screen.dart';
import 'package:lashess_by_prii_app/views/settings_screen.dart';
import 'package:lashess_by_prii_app/views/splash_screen.dart';
import '../views/main_screen.dart';
import '../views/booking_screen.dart';

final router = GoRouter(
  initialLocation: '/splash', // ✅ Start here
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      name: 'bookings',
      path: '/bookings',
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      name: 'info',
      path: '/info',
      builder: (context, state) => const BusinessInfoScreen(),
    ),
    GoRoute(
      name: 'map',
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: 'forgot-password',
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
        name: 'auth', path: '/auth', builder: (context, state) => AuthScreen()),
    GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => ProfileScreen()),
    GoRoute(
      name: 'payments',
      path: '/payments',
      builder: (context, state) => const PaymentScreen(),
    ),
  ],
);
