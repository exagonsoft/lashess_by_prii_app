import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool _notificationsInitialized = false;

/// Foreground/local notification display
Future<void> showFlutterNotification(RemoteMessage message) async {
  final notif = message.notification;
  final android = notif?.android;
  if (notif == null || android == null) return;

  // Put ALL data in payload (JSON) so a single tap handler can decode it
  final payload = jsonEncode(message.data);

  await flutterLocalNotificationsPlugin.show(
    notif.hashCode,
    notif.title,
    notif.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: 'ic_stat_ic_notification',     // your white mono icon
        color: AppColors.lightPrimary,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: payload,
  );
}

/// MUST be top-level. Do NOT show local notifications here.
/// Android will show push automatically when app is background/terminated
/// if your payload contains a "notification" block.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No local plugin calls here; just minimal work if needed
}

/// Initialize notifications + tap handling
Future<void> setupFlutterNotifications({
  required void Function(Map<String, dynamic> data) onTapData,
}) async {
  if (_notificationsInitialized) return;

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Create channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Init plugin with tap handler (for foreground local notifications)
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('ic_stat_ic_notification'),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      if (response.payload == null) return;
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        onTapData(data);
      } catch (_) {}
    },
  );

  // Foreground presentation (iOS/macOS)
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Foreground messages → show local notif
  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  // Background/terminated taps
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    onTapData(message.data);
  });

  _notificationsInitialized = true;
}
