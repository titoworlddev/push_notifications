// Variant: debugAndroidTest
// Config: debug
// Store: C:\Users\Cristian\.android\debug.keystore
// Alias: AndroidDebugKey
// MD5: A9:F8:5C:B2:82:DB:38:89:85:A5:54:72:DB:3E:66:83
// SHA1: 79:94:DC:B5:A4:31:13:11:76:5F:85:34:AF:81:C7:A3:95:14:51:31
// SHA-256: A4:89:B9:D8:3B:41:3D:33:5F:D7:05:C9:D9:4E:8C:1F:DE:1B:3A:12:59:99:68:1A:37:1F:BE:DA:18:18:51:7A
// Valid until: lunes, 16 de enero de 2051
// Tonek: cgN_RQP1T5KKOIG-FhmRQa:APA91bHCkw3eL9Hr6p9srFzsfr64oHNXGyT_lNoiRe8MkdB9Pstgs1isHClyZQJVm5QEKPznq8GRPIIKIGuMLCv1OKEbIpWnxrTP9crhXah2KrudN4HPdsD3CYjTrZkDq8Zg9v96K-SQ

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler: ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler: ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('onMessageOpenApp Handler: ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    // Push notifications
    await Firebase.initializeApp();
    await requestPermision();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local notifications
  }

  // Apple / Web
  static requestPermision() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
