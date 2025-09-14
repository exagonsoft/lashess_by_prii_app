import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import '../firebase_options.dart';

/// Background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

/// Notification channel & plugin
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool _notificationsInitialized = false;

/// Setup notifications (channel + iOS presentation options)
Future<void> setupFlutterNotifications() async {
  if (_notificationsInitialized) return;
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(showFlutterNotification);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  _notificationsInitialized = true;
}

/// Show local notification when a message is received
Future<void> showFlutterNotification(RemoteMessage message) async {
  final notification = message.notification;
  final android = message.notification?.android;
  final route = message.data['route']; // 👈 Extract custom payload
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'ic_stat_ic_notification',
          color: AppColors.lightPrimary
        ),
      ),
      payload: route, // 👈 Pass custom payload to be handled on tap
    );
  }
}

/// Initialize FCM for foreground & background
Future<String?> initFCM({
  Function(RemoteMessage)? onMessageOpenedApp,
}) async {
  // Request permissions (iOS/macOS)
  await FirebaseMessaging.instance.requestPermission();
  // Subscribe to "offers" topic
  await FirebaseMessaging.instance.subscribeToTopic("offers");
  // Get token
  final token = await FirebaseMessaging.instance.getToken();

  //Foreground messages
  FirebaseMessaging.onMessage.listen((message) {
    showFlutterNotification(message);
  });
  //Tapped notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    if (onMessageOpenedApp != null) onMessageOpenedApp(message);
    final route = message.data['route'];
  });
  return token;
}
